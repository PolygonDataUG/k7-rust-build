############################################################
# Author:        Fabian Szukat
# Date:          04.03.2026
# KernelVersion: 7 (Mainline / Rust-for-Linux)
# License:       Dockerfile, Content (GPL-2.0)
############################################################

FROM debian:trixie-slim

# Metadaten für das Image-Manifest
LABEL org.opencontainers.image.authors="Fabian Szukat"
LABEL org.opencontainers.image.title="Linux Kernel 7 Rust Build Environment"
LABEL org.opencontainers.image.licenses="GPL-2.0-only"
LABEL org.opencontainers.image.description="Build-Umgebung für Rust-for-Linux Kernel 7 (ARM64)"
LABEL org.opencontainers.image.version="1.0.0"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]


RUN apt-get update && apt-r install --no-install-recommends -y \
    build-essential flex bison libelf-dev libssl-dev \
    clang llvm lld curl git kmod bc ca-certificates \
    pkg-config libncurses-dev wget python3 make && \
    rm -rf /var/lib/apt/lists/*

# Rust Toolchain (Version 1.78.0 ist meist der Target für Kernel 6.12+)
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain nightly
ENV PATH="/root/.cargo/bin:${PATH}"

# Spezifische Bindgen Version installieren (wichtig für Kernel-Builds!)
RUN rustup default 1.82.0 && \
    rustup component add rust-src && \
    cargo +nightly install --version 0.69.5 bindgen-cli 

WORKDIR /usr/src
# Wir nehmen nur die letzten Commits (spart Platz/Zeit)
RUN git clone --depth 1 https://github.com/Rust-for-Linux/linux.git

WORKDIR /usr/src/linux

# Konfiguration
RUN make ARCH=arm64 LLVM=1 defconfig && \
    ./scripts/config --enable CONFIG_RUST && \
    scripts/config --enable RUST_IS_AVAILABLE && \
    scripts/config --enable CONFG_64BIT && \
    make ARCH=arm64 LLVM=1 olddefconfig

# 1. Grundlegende Vorbereitung
RUN make ARCH=arm64 LLVM=1 olddefconfig

# 2. Rust-Objekte bauen (erzeugt rust/core.o, rust/kernel.o etc.)
RUN make ARCH=arm64 LLVM=1 "-j$(nproc)" rust/

# 3. Den Kernel-Tree zwingen, die Symbole aus den Rust-Objekten in die Module.symvers zu schreiben
# Das ist der entscheidende Befehl, der die Warnungen im Keim erstickt:
RUN make ARCH=arm64 LLVM=1 vmlinux && \
    make ARCH=arm64 LLVM=1 modules_prepare && \
    make LLVM=1 modules


# DER FIX: Wir bauen die Rust-Teile UND erstellen eine initiale Symbol-Datei
RUN make ARCH=arm64 LLVM=1 rustavailable && \
    make ARCH=arm64 LLVM=1 "-j$(nproc)" prepare && \
    make ARCH=arm64 LLVM=1 "-j$(nproc)" rust/ && \
    touch Module.symvers && \
    make ARCH=arm64 LLVM=1 modules_prepare

WORKDIR /src

CMD ["bash"]
