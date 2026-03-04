############################################################
# Author:        Fabian Szukat
# Date:          04.03.2026
# KernelVersion: 7 (Mainline / Rust-for-Linux)
# License:       Dockerfile (MIT), Content (GPL-2.0)
############################################################

FROM debian:trixie-slim

# Metadaten für das Image-Manifest
LABEL org.opencontainers.image.authors="Fabian Szukat"
LABEL org.opencontainers.image.title="Linux Kernel 7 Rust Build Environment"
LABEL org.opencontainers.image.licenses="GPL-2.0-only"
LABEL org.opencontainers.image.description="Build-Umgebung für Rust-for-Linux Kernel 7 (ARM64)"
FROM debian:trixie-slim

RUN apt-get update && apt-get install -y \
    build-essential flex bison libelf-dev libssl-dev \
    clang llvm lld curl git kmod bc ca-certificates \
    pkg-config libncurses-dev wget python3 make bindgen

# Rust installieren - Wir nutzen die Version, die dein Kernel-Tree erwartet
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Wichtig: Kernel 6.x+ braucht oft eine spezifische Rust-Version
# Wir installieren 1.78.0 und die Source-Komponenten
RUN rustup default 1.78.0 && \
    rustup component add rust-src && \
    rustup target add aarch64-unknown-none

# /usr/src wechseln
WORKDIR /usr/src

#mit git den linux-kernelen aus
RUN git clone --depth 1 https://github.com/Rust-for-Linux/linux.git

WORKDIR /usr/src/linux

# Konfiguration und Rust-Aktivierung
RUN make ARCH=arm64 LLVM=1 defconfig && \
    ./scripts/config --enable CONFIG_RUST

# Der entscheidende Teil: Rust-Infrastruktur im Image vorbauen
# 'rustprep' generiert die target.json und bereitet die Crates vor
RUN make ARCH=arm64 LLVM=1 olddefconfig && \
    make ARCH=arm64 LLVM=1 -j$(nproc) rust/core.o rust/kernel.o modules_prepare

# Workspace
WORKDIR /src
COPY . .

CMD ["bash"]