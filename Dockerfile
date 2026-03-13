############################################################
# Author:        Fabian Szukat
# Date:          04.03.2026
# KernelVersion: 7 (Mainline / Rust-for-Linux)
# License:       Dockerfile, Content (GPL-2.0)
############################################################

FROM debian:trixie-slim AS base

# Metadaten für das Image-Manifest
LABEL org.opencontainers.image.authors="Fabian Szukat"
LABEL org.opencontainers.image.title="Linux Kernel 7 Rust Build Environment"
LABEL org.opencontainers.image.licenses="GPL-2.0-only"
LABEL org.opencontainers.image.description="Build-Umgebung für Rust-for-Linux Kernel 7 (ARM64)"
LABEL org.opencontainers.image.version="1.0.0"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]


RUN apt-get update && apt-get install --no-install-recommends -y \
    # Basis-Build-Tools
    build-essential flex bison make cmake pkg-config \
    # LLVM/Clang Suite (Ideal für Cross-Compiling)
    clang llvm lld \
    # Header und Bibliotheken
    libelf-dev libssl-dev libncurses-dev \
    # Cross-Compiler für diverse Architekturen
    gcc-aarch64-linux-gnu g++-aarch64-linux-gnu \
    gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf \
    gcc-riscv64-linux-gnu g++-riscv64-linux-gnu \
    gcc-powerpc64le-linux-gnu g++-powerpc64le-linux-gnu \
    gcc-s390x-linux-gnu g++-s390x-linux-gnu \
    # Hilfswerkzeuge
    curl wget git kmod bc ca-certificates python3 \
    u-boot-tools xz-utils \
    # Bereinigung
    && rm -rf /var/lib/apt/lists/*

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


FROM base AS build-arm64
# arm64
ENV KERNEL_SRC=/usr/src/linux
ENV ARCH=arm64
ENV KBUILD_OUTPUT=/build/${ARCH}
ENV KDIR=/build/${ARCH}
ENV LLVM=1
ENV LLVM_IAS=1
# Konfiguration
RUN mkdir -p /build/arm64

RUN make O=/build/arm64 ARCH=arm64 LLVM=1 defconfig && \
    ./scripts/config --file /build/arm64/.config --enable CONFIG_RUST && \
    ./scripts/config --file /build/arm64/.config --enable RUST_IS_AVAILABLE && \
    ./scripts/config --file /build/arm64/.config --enable CONFIG_64BIT && \
    make O=/build/arm64 ARCH=arm64 LLVM=1 olddefconfig

## 1. Grundlegende Vorbereitung
# RUN make ARCH=arm64 LLVM=1 olddefconfig

# 2. Rust-Objekte bauen (erzeugt rust/core.o, rust/kernel.o etc.)
RUN make O=/build/arm64 ARCH=arm64 LLVM=1 "-j$(nproc)" rust/

# 3. Den Kernel-Tree zwingen, die Symbole aus den Rust-Objekten in die Module.symvers zu schreiben
# Das ist der entscheidende Befehl, der die Warnungen im Keim erstickt:
# 1. Den Kernel-Kern (vmlinux) bauen
RUN make O=/build/arm64 ARCH=arm64 LLVM=1 -j$(nproc) vmlinux && \
# 2. Vorbereitung für die Module (Header/Scripts)
    make O=/build/arm64 ARCH=arm64 LLVM=1 modules_prepare && \
# 3. Die Module selbst bauen
    make O=/build/arm64 ARCH=arm64 LLVM=1 -j$(nproc) modules


# DER FIX: Wir bauen die Rust-Teile UND erstellen eine initiale Symbol-Datei
# 1. Prüfen, ob die Rust-Umgebung (Toolchain/Bindgen) passt
RUN make O=/build/arm64 ARCH=arm64 LLVM=1 rustavailable && \
# 2. Den Build vorbereiten (generiert u.a. bounds.h, asm-offsets.h)
    make O=/build/arm64 ARCH=arm64 LLVM=1 "-j$(nproc)" prepare && \
# 3. Den Rust-spezifischen Teil (core, alloc, bindings) bauen
    make O=/build/arm64 ARCH=arm64 LLVM=1 "-j$(nproc)" rust/ && \
# 4. Symbol-Tabelle erstellen (WICHTIG: im Output-Ordner!)
    touch /build/arm64/Module.symvers && \
# 5. Finale Vorbereitung für Module
    make O=/build/arm64 ARCH=arm64 LLVM=1 modules_prepare

WORKDIR /src

CMD ["bash"]

FROM base AS build-arm
# arm
ENV KERNEL_SRC=/usr/src/linux
ENV ARCH=arm
ENV KBUILD_OUTPUT=/build/${ARCH}
ENV KDIR=/build/${ARCH}
ENV LLVM=1
ENV LLVM_IAS=1

# Konfiguration
RUN mkdir -p /build/arm
RUN make O=/build/arm ARCH=${ARCH} LLVM=1 defconfig && \
    ./scripts/config --file ${KBUILD_OUTPUT}/.config --enable CONFIG_RUST && \
    ./scripts/config --file ${KBUILD_OUTPUT}/.config --enable RUST_IS_AVAILABLE && \
    ./scripts/config --file ${KBUILD_OUTPUT}/.config --enable CONFIG_64BIT && \
    make O=/build/arm ARCH=${ARCH} LLVM=1 olddefconfig

## 1. Grundlegende Vorbereitung
# RUN make ARCH=${ARCH}64 LLVM=1 olddefconfig

# 2. Rust-Objekte bauen (erzeugt rust/core.o, rust/kernel.o etc.)
RUN make O=${KBUILD_OUTPUT} ARCH=${ARCH} LLVM=1 "-j$(nproc)" rust/

# 3. Den Kernel-Tree zwingen, die Symbole aus den Rust-Objekten in die Module.symvers zu schreiben
# Das ist der entscheidende Befehl, der die Warnungen im Keim erstickt:
# 1. Den Kernel-Kern (vmlinux) bauen
RUN make O=${KBUILD_OUTPUT} ARCH=${ARCH} LLVM=1 -j$(nproc) vmlinux && \
# 2. Vorbereitung für die Module (Header/Scripts)
    make O=${KBUILD_OUTPUT} ARCH=${ARCH} LLVM=1 modules_prepare && \
# 3. Die Module selbst bauen
    make O=${KBUILD_OUTPUT} ARCH=${ARCH} LLVM=1 -j$(nproc) modules


# DER FIX: Wir bauen die Rust-Teile UND erstellen eine initiale Symbol-Datei
# 1. Prüfen, ob die Rust-Umgebung (Toolchain/Bindgen) passt
RUN make O=${KBUILD_OUTPUT} ARCH=${ARCH} LLVM=1 rustavailable && \
# 2. Den Build vorbereiten (generiert u.a. bounds.h, asm-offsets.h)
    make O=${KBUILD_OUTPUT} ARCH=${ARCH} LLVM=1 "-j$(nproc)" prepare && \
# 3. Den Rust-spezifischen Teil (core, alloc, bindings) bauen
    make O=${KBUILD_OUTPUT} ARCH=${ARCH} LLVM=1 "-j$(nproc)" rust/ && \
# 4. Symbol-Tabelle erstellen (WICHTIG: im Output-Ordner!)
    touch ${KBUILD_OUTPUT} Module.symvers && \
# 5. Finale Vorbereitung für Module
    make O=${KBUILD_OUTPUT} ARCH=arm LLVM=1 modules_prepare

WORKDIR /src

CMD ["bash"]

FROM base AS build-riscv
# riscv
# Konfiguration
RUN mkdir -p /build/riscv
RUN make O=/build/riscv ARCH=riscv LLVM=1 defconfig && \
    ./scripts/config --file /build/riscv/.config --enable CONFIG_RUST && \
    ./scripts/config --file /build/riscv/.config --enable RUST_IS_AVAILABLE && \
    ./scripts/config --file /build/riscv/.config --enable CONFIG_64BIT && \
    make O=/build/riscv ARCH=riscv LLVM=1 olddefconfig

## 1. Grundlegende Vorbereitung
# RUN make ARCH=arm64 LLVM=1 olddefconfig

# 2. Rust-Objekte bauen (erzeugt rust/core.o, rust/kernel.o etc.)
RUN make O=/build/riscv ARCH=riscv LLVM=1 "-j$(nproc)" rust/

# 3. Den Kernel-Tree zwingen, die Symbole aus den Rust-Objekten in die Module.symvers zu schreiben
# Das ist der entscheidende Befehl, der die Warnungen im Keim erstickt:
# 1. Den Kernel-Kern (vmlinux) bauen
RUN make O=/build/riscv ARCH=riscv LLVM=1 -j$(nproc) vmlinux && \
# 2. Vorbereitung für die Module (Header/Scripts)
    make O=/build/riscv ARCH=riscv LLVM=1 modules_prepare && \
# 3. Die Module selbst bauen
    make O=/build/riscv ARCH=riscv LLVM=1 -j$(nproc) modules


# DER FIX: Wir bauen die Rust-Teile UND erstellen eine initiale Symbol-Datei
# 1. Prüfen, ob die Rust-Umgebung (Toolchain/Bindgen) passt
RUN make O=/build/riscv ARCH=riscv LLVM=1 rustavailable && \
# 2. Den Build vorbereiten (generiert u.a. bounds.h, asm-offsets.h)
    make O=/build/riscv ARCH=riscv LLVM=1 "-j$(nproc)" prepare && \
# 3. Den Rust-spezifischen Teil (core, alloc, bindings) bauen
    make O=/build/riscv ARCH=riscv LLVM=1 "-j$(nproc)" rust/ && \
# 4. Symbol-Tabelle erstellen (WICHTIG: im Output-Ordner!)
    touch /build/riscv/Module.symvers && \
# 5. Finale Vorbereitung für Module
    make O=/build/riscv ARCH=riscv LLVM=1 modules_prepare

WORKDIR /src

CMD ["bash"]

FROM base AS build-loongarch
# loongarch
ENV KERNEL_SRC=/usr/src/linux
ENV ARCH=loongarch
ENV KBUILD_OUTPUT=/build/${ARCH}
ENV KDIR=/build/${ARCH}
ENV LLVM=1
ENV LLVM_IAS=1
# Konfiguration loongarch
RUN mkdir -p /build/loongarch
RUN make O=/build/loongarch ARCH=loongarch LLVM=1 defconfig && \
    ./scripts/config --file /build/loongarch/.config --enable CONFIG_RUST && \
    ./scripts/config --file /build/loongarch/.config --enable RUST_IS_AVAILABLE && \
    ./scripts/config --file /build/loongarch/.config --enable CONFIG_64BIT && \
    make O=/build/loongarch ARCH=loongarch LLVM=1 olddefconfig

## 1. Grundlegende Vorbereitung
# RUN make ARCH=arm64 LLVM=1 olddefconfig

# 2. Rust-Objekte bauen (erzeugt rust/core.o, rust/kernel.o etc.)
RUN make O=/build/loongarch ARCH=loongarch LLVM=1 "-j$(nproc)" rust/

# 3. Den Kernel-Tree zwingen, die Symbole aus den Rust-Objekten in die Module.symvers zu schreiben
# Das ist der entscheidende Befehl, der die Warnungen im Keim erstickt:
# 1. Den Kernel-Kern (vmlinux) bauen
RUN make O=/build/loongarch ARCH=loongarch LLVM=1 -j$(nproc) vmlinux && \
# 2. Vorbereitung für die Module (Header/Scripts)
    make O=/build/loongarch ARCH=loongarch LLVM=1 modules_prepare && \
# 3. Die Module selbst bauen
    make O=/build/loongarch ARCH=loongarch LLVM=1 -j$(nproc) modules


# DER FIX: Wir bauen die Rust-Teile UND erstellen eine initiale Symbol-Datei
# 1. Prüfen, ob die Rust-Umgebung (Toolchain/Bindgen) passt
RUN make O=/build/loongarch ARCH=loongarch LLVM=1 rustavailable && \
# 2. Den Build vorbereiten (generiert u.a. bounds.h, asm-offsets.h)
    make O=/build/loongarch ARCH=loongarch LLVM=1 "-j$(nproc)" prepare && \
# 3. Den Rust-spezifischen Teil (core, alloc, bindings) bauen
    make O=/build/loongarch ARCH=loongarch LLVM=1 "-j$(nproc)" rust/ && \
# 4. Symbol-Tabelle erstellen (WICHTIG: im Output-Ordner!)
    touch /build/loongarch/Module.symvers && \
# 5. Finale Vorbereitung für Module
    make O=/build/loongarch ARCH=loongarch LLVM=1 modules_prepare

WORKDIR /src

CMD ["bash"]


FROM base AS build-s390
# loongarch
# Konfiguration loongarch
RUN mkdir -p /build/s390
RUN make O=/build/s390 ARCH=s390 LLVM=1 defconfig && \
    ./scripts/config --file /build/s390/.config --enable CONFIG_RUST && \
    ./scripts/config --file /build/s390/.config --enable RUST_IS_AVAILABLE && \
    ./scripts/config --file /build/s390/.config --enable CONFIG_64BIT && \
    make O=/build/s390 ARCH=s390 LLVM=1 olddefconfig

## 1. Grundlegende Vorbereitung
# RUN make ARCH=arm64 LLVM=1 olddefconfig

# 2. Rust-Objekte bauen (erzeugt rust/core.o, rust/kernel.o etc.)
RUN make O=/build/s390 ARCH=s390 LLVM=1 "-j$(nproc)" rust/

# 3. Den Kernel-Tree zwingen, die Symbole aus den Rust-Objekten in die Module.symvers zu schreiben
# Das ist der entscheidende Befehl, der die Warnungen im Keim erstickt:
# 1. Den Kernel-Kern (vmlinux) bauen
RUN make O=/build/s390 ARCH=s390 LLVM=1 -j$(nproc) vmlinux && \
# 2. Vorbereitung für die Module (Header/Scripts)
    make O=/build/s390 ARCH=s390 LLVM=1 modules_prepare && \
# 3. Die Module selbst bauen
    make O=/build/s390 ARCH=s390 LLVM=1 -j$(nproc) modules


# DER FIX: Wir bauen die Rust-Teile UND erstellen eine initiale Symbol-Datei
# 1. Prüfen, ob die Rust-Umgebung (Toolchain/Bindgen) passt
RUN make O=/build/s390 ARCH=s390 LLVM=1 rustavailable && \
# 2. Den Build vorbereiten (generiert u.a. bounds.h, asm-offsets.h)
    make O=/build/s390 ARCH=s390 LLVM=1 "-j$(nproc)" prepare && \
# 3. Den Rust-spezifischen Teil (core, alloc, bindings) bauen
    make O=/build/s390 ARCH=s390 LLVM=1 "-j$(nproc)" rust/ && \
# 4. Symbol-Tabelle erstellen (WICHTIG: im Output-Ordner!)
    touch /build/s390/Module.symvers && \
# 5. Finale Vorbereitung für Module
    make O=/build/s390 ARCH=s390 LLVM=1 modules_prepare

WORKDIR /src

CMD ["bash"]

FROM base AS build-x86_64
#x86_64
ENV KERNEL_SRC=/usr/src/linux
ENV ARCH=x86_64
ENV KBUILD_OUTPUT=/build/${ARCH}
ENV KDIR=/build/${ARCH}
ENV LLVM=1
ENV LLVM_IAS=1
# Konfiguration loongarch
RUN mkdir -p /build/x86_64
RUN make O=/build/x86_64 ARCH=x86_64 LLVM=1 defconfig && \
    ./scripts/config --file /build/x86_64/.config --enable CONFIG_RUST && \
    ./scripts/config --file /build/x86_64/.config --enable RUST_IS_AVAILABLE && \
    ./scripts/config --file /build/x86_64/.config --enable CONFIG_64BIT && \
    make O=/build/x86_64 ARCH=x86_64 LLVM=1 olddefconfig

## 1. Grundlegende Vorbereitung
# RUN make ARCH=arm64 LLVM=1 olddefconfig

# 2. Rust-Objekte bauen (erzeugt rust/core.o, rust/kernel.o etc.)
RUN make O=/build/x86_64 ARCH=x86_64 LLVM=1 "-j$(nproc)" rust/

# 3. Den Kernel-Tree zwingen, die Symbole aus den Rust-Objekten in die Module.symvers zu schreiben
# Das ist der entscheidende Befehl, der die Warnungen im Keim erstickt:
# 1. Den Kernel-Kern (vmlinux) bauen
RUN make O=/build/x86_64 ARCH=x86_64 LLVM=1 -j$(nproc) vmlinux && \
# 2. Vorbereitung für die Module (Header/Scripts)
    make O=/build/x86_64 ARCH=x86_64 LLVM=1 modules_prepare && \
# 3. Die Module selbst bauen
    make O=/build/x86_64 ARCH=x86_64 LLVM=1 -j$(nproc) modules


# DER FIX: Wir bauen die Rust-Teile UND erstellen eine initiale Symbol-Datei
# 1. Prüfen, ob die Rust-Umgebung (Toolchain/Bindgen) passt
RUN make O=/build/x86_64 ARCH=x86_64 LLVM=1 rustavailable && \
# 2. Den Build vorbereiten (generiert u.a. bounds.h, asm-offsets.h)
    make O=/build/x86_64 ARCH=x86_64 LLVM=1 "-j$(nproc)" prepare && \
# 3. Den Rust-spezifischen Teil (core, alloc, bindings) bauen
    make O=/build/x86_64 ARCH=x86_64 LLVM=1 "-j$(nproc)" rust/ && \
# 4. Symbol-Tabelle erstellen (WICHTIG: im Output-Ordner!)
    touch /build/x86_64/Module.symvers && \
# 5. Finale Vorbereitung für Module
    make O=/build/x86_64 ARCH=x86_64 LLVM=1 modules_prepare

WORKDIR /src


CMD ["bash"]

FROM base AS final-package
ENV KERNEL_SRC=/usr/src/linux
ENV ARCH=x86_64
ENV KBUILD_OUTPUT=/build/${ARCH}
ENV KDIR=/build/${ARCH}
ENV LLVM=1
ENV LLVM_IAS=1

COPY --from=build-arm64 /build/arm64 /build/arm64/
COPY --from=build-arm /build/arm /build/arm32/
COPY --from=build-riscv /build/riscv /build/riscv/
COPY --from=build-s390 /build/s390 /build/s390/
COPY --from=build-x86_64 /build/x86_64 /build/x86_64/

WORKDIR /src
CMD ["bash"]