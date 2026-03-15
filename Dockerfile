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
ENV PATH="/root/.cargo/bin:${PATH}"
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
    gcc-mips-linux-gnu g++-mips-linux-gnu \
    # Hilfswerkzeuge
    curl wget git kmod bc ca-certificates python3 \
    u-boot-tools xz-utils \
    # Bereinigung
    && rm -rf /var/lib/apt/lists/* && \
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain nightly && \
    rustup default 1.82.0 && \
    rustup component add rust-src && \
    cargo +nightly install --version 0.69.5 bindgen-cli && \
    git clone --depth 1 https://github.com/Rust-for-Linux/linux.git /usr/src/linux

WORKDIR /usr/src
# Wir nehmen nur die letzten Commits (spart Platz/Zeit)


WORKDIR /usr/src/linux


FROM base AS build-arm64
# arm64
ENV KERNEL_SRC=/usr/src/linux
ARG ARCH=arm64
ARG KBUILD_OUTPUT=/build/${ARCH}
ARG KDIR=/build/${ARCH}
ARG LLVM=1
ARG LLVM_IAS=1
# Konfiguration
RUN mkdir -p /build/arm64

RUN make O=/build/arm64 ARCH=arm64 LLVM=1 defconfig && \
    ./scripts/config --file /build/arm64/.config --enable CONFIG_RUST && \
    ./scripts/config --file /build/arm64/.config --enable RUST_IS_AVAILABLE && \
    ./scripts/config --file /build/arm64/.config --enable CONFIG_64BIT && \
    make O=/build/arm64 ARCH=arm64 LLVM=1 olddefconfig && \
    make O=/build/arm64 ARCH=arm64 LLVM=1 -j$(nproc) vmlinux && \
    make O=/build/arm64 ARCH=arm64 LLVM=1 modules_prepare && \
    make O=/build/arm64 ARCH=arm64 LLVM=1 -j$(nproc) modules && \
    make O=/build/arm64 ARCH=arm64 LLVM=1 rustavailable && \
    make O=/build/arm64 ARCH=arm64 LLVM=1 "-j$(nproc)" prepare && \
    make O=/build/arm64 ARCH=arm64 LLVM=1 "-j$(nproc)" rust/ && \
    touch /build/arm64/Module.symvers && \
    make O=/build/arm64 ARCH=arm64 LLVM=1 modules_prepare

WORKDIR /src

CMD ["bash"]

FROM base AS build-arm
# arm
ENV KERNEL_SRC=/usr/src/linux
ARG ARCH_ARM=arm
ARG KBUILD_OUTPUT_ARM=/build/${ARCH_ARM}
ARG LLVM=1
ARG LLVM_IAS=1

# Konfiguration
RUN mkdir -p ${KBUILD_OUTPUT_ARM}
RUN make O=/build/arm ARCH=${ARCH_ARM} LLVM=${LLVM} defconfig && \
    ./scripts/config --file ${KBUILD_OUTPUT_ARM}/.config --enable CONFIG_RUST && \
    ./scripts/config --file ${KBUILD_OUTPUT_ARM}/.config --enable RUST_IS_AVAILABLE && \
    ./scripts/config --file ${KBUILD_OUTPUT_ARM}/.config --enable CONFIG_64BIT && \
    make O=/build/arm ARCH=${ARCH_ARM} LLVM=${LLVM} olddefconfig && \
    make O=${KBUILD_OUTPUT_ARM} ARCH=${ARCH_ARM} LLVM=${LLVM} -j$(nproc) vmlinux && \
    make O=${KBUILD_OUTPUT_ARM} ARCH=${ARCH_ARM} LLVM=${LLVM} modules_prepare && \
    make O=${KBUILD_OUTPUT_ARM} ARCH=${ARCH_ARM} LLVM=${LLVM} -j$(nproc) modules && \
    make O=${KBUILD_OUTPUT_ARM} ARCH=${ARCH_ARM} LLVM=${LLVM} rustavailable && \
    make O=${KBUILD_OUTPUT_ARM} ARCH=${ARCH_ARM} LLVM=${LLVM} "-j$(nproc)" prepare && \
    make O=${KBUILD_OUTPUT_ARM} ARCH=${ARCH_ARM} LLVM=${LLVM} "-j$(nproc)" rust/ && \
    touch ${KBUILD_OUTPUT_ARM}/Module.symvers && \
    make O=${KBUILD_OUTPUT_ARM} ARCH=${ARCH_ARM} LLVM=${LLVM} modules_prepare

WORKDIR /src

CMD ["bash"]


FROM base AS build-riscv
# riscv
# Konfiguration
ENV KERNEL_SRC=/usr/src/linux
ARG ARCH_RISCV=riscv
ARG KBUILD_OUTPUT_RISCV=/build/${ARCH_RISCV}
ARG LLVM=1
ARG LLVM_IAS=1

RUN mkdir -p /build/riscv && \
     make O=${KBUILD_OUTPUT_RISCV} ARCH=${ARCH_RISCV} LLVM=${LLVM} defconfig && \
    ./scripts/config --file /build/riscv/.config --enable CONFIG_RUST && \
    ./scripts/config --file /build/riscv/.config --enable RUST_IS_AVAILABLE && \
    ./scripts/config --file /build/riscv/.config --enable CONFIG_64BIT && \
    make O=${KBUILD_OUTPUT_RISCV} ARCH=${ARCH_RISCV} LLVM=${LLVM} olddefconfig && \
    make O=${KBUILD_OUTPUT_RISCV} ARCH=${ARCH_RISCV} LLVM=${LLVM} -j$(nproc) vmlinux && \
    make O=${KBUILD_OUTPUT_RISCV} ARCH=${ARCH_RISCV} LLVM=${LLVM} modules_prepare && \
    make O=${KBUILD_OUTPUT_RISCV} ARCH=${ARCH_RISCV} LLVM=${LLVM} -j$(nproc) modules && \
    make O=${KBUILD_OUTPUT_RISCV} ARCH=${ARCH_RISCV} LLVM=${LLVM} rustavailable && \
    make O=${KBUILD_OUTPUT_RISCV} ARCH=${ARCH_RISCV} LLVM=${LLVM} "-j$(nproc)" prepare && \
    make O=${KBUILD_OUTPUT_RISCV} ARCH=${ARCH_RISCV} LLVM=${LLVM} "-j$(nproc)" rust/ && \
    touch ${KBUILD_OUTPUT_RISCV}/Module.symvers && \
    make O=${KBUILD_OUTPUT_RISCV} ARCH=${ARCH_RISCV} LLVM=${LLVM} modules_prepare

WORKDIR /src

CMD ["bash"]

FROM base AS build-loongarch
# loongarch
ENV KERNEL_SRC=/usr/src/linux
ARG ARCH_LOONGARCH=loongarch
ARG KBUILD_OUTPUT_LOONGARCH=/build/${ARCH_LOONGARCH}
ARG LLVM=1
ARG LLVM_IAS=1
# Konfiguration loongarch
RUN mkdir -p /build/loongarch && \
    make O=${KBUILD_OUTPUT_LOONGARCH} ARCH=${ARCH_LOONGARCH} LLVM=1 defconfig && \
    ./scripts/config --file /build/loongarch/.config --enable CONFIG_RUST && \
    ./scripts/config --file /build/loongarch/.config --enable RUST_IS_AVAILABLE && \
    ./scripts/config --file /build/loongarch/.config --enable CONFIG_64BIT && \
    make O=${KBUILD_OUTPUT_LOONGARCH} ARCH=${ARCH_LOONGARCH} LLVM=${LLVM} olddefconfig && \
    make O=${KBUILD_OUTPUT_LOONGARCH} ARCH=${ARCH_LOONGARCH} LLVM=${LLVM} -j$(nproc) vmlinux && \
    make O=${KBUILD_OUTPUT_LOONGARCH} ARCH=${ARCH_LOONGARCH} LLVM=${LLVM} modules_prepare && \
    make O=${KBUILD_OUTPUT_LOONGARCH} ARCH=${ARCH_LOONGARCH} LLVM=${LLVM} -j$(nproc) modules && \
    make O=${KBUILD_OUTPUT_LOONGARCH} ARCH=${ARCH_LOONGARCH} LLVM=${LLVM} rustavailable && \
    make O=${KBUILD_OUTPUT_LOONGARCH} ARCH=${ARCH_LOONGARCH} LLVM=${LLVM} "-j$(nproc)" prepare && \
    make O=${KBUILD_OUTPUT_LOONGARCH} ARCH=${ARCH_LOONGARCH} LLVM=${LLVM} "-j$(nproc)" rust/ && \
    touch ${KBUILD_OUTPUT_LOONGARCH}/Module.symvers && \
    make O=${KBUILD_OUTPUT_LOONGARCH} ARCH=${ARCH_LOONGARCH} LLVM=${LLVM} modules_prepare

WORKDIR /src

CMD ["bash"]


FROM base AS build-s390
# loongarch
# Konfiguration s390
ENV KERNEL_SRC=/usr/src/linux
ARG ARCH_S390=s390
ARG KBUILD_OUTPUT_S390=/build/${ARCH_S390}
ARG LLVM=1
ARG LLVM_IAS=1

RUN mkdir -p ${KBUILD_OUTPUT_S390} && \
    make O=${KBUILD_OUTPUT_S390} ARCH=${ARCH_S390} LLVM=${LLVM} defconfig && \
    ./scripts/config --file ${KBUILD_OUTPUT_S390}/.config --enable CONFIG_RUST && \
    ./scripts/config --file ${KBUILD_OUTPUT_S390}/.config --enable RUST_IS_AVAILABLE && \
    ./scripts/config --file ${KBUILD_OUTPUT_S390}/.config --enable CONFIG_64BIT && \
    make O=${KBUILD_OUTPUT_S390} ARCH=${ARCH_S390} LLVM=${LLVM} olddefconfig && \
    make O=${KBUILD_OUTPUT_S390} ARCH=${ARCH_S390} LLVM=${LLVM} -j$(nproc) vmlinux && \
    make O=${KBUILD_OUTPUT_S390} ARCH=${ARCH_S390} LLVM=${LLVM} modules_prepare && \
    make O=${KBUILD_OUTPUT_S390} ARCH=${ARCH_S390} LLVM=${LLVM} -j$(nproc) modules && \
    make O=${KBUILD_OUTPUT_S390} ARCH=${ARCH_S390} LLVM=${LLVM} rustavailable && \
    make O=${KBUILD_OUTPUT_S390} ARCH=${ARCH_S390} LLVM=${LLVM} "-j$(nproc)" prepare && \
    make O=${KBUILD_OUTPUT_S390} ARCH=${ARCH_S390} LLVM=${LLVM} "-j$(nproc)" rust/ && \
    touch ${KBUILD_OUTPUT_S390}/Module.symvers && \
    make O=${KBUILD_OUTPUT_S390} ARCH=${ARCH_S390} LLVM=${LLVM} modules_prepare

WORKDIR /src

CMD ["bash"]

FROM base AS build-x86_64
#x86_64
ENV KERNEL_SRC=/usr/src/linux
ARG ARCH_X86_64=x86_64
ARG KBUILD_OUTPUT_X86_64=/build/${ARCH_X86_64}
ARG KDIR=/build/${ARCH_X86_64}
ARG LLVM=1
ARG LLVM_IAS=1
RUN mkdir -p ${KBUILD_OUTPUT_X86_64} && \ 
    make O=${KBUILD_OUTPUT_X86_64} ARCH=${ARCH_X86_64} LLVM=${LLVM} defconfig && \
    ./scripts/config --file ${KBUILD_OUTPUT_X86_64}/.config --enable CONFIG_RUST && \
    ./scripts/config --file ${KBUILD_OUTPUT_X86_64}/.config --enable RUST_IS_AVAILABLE && \
    ./scripts/config --file ${KBUILD_OUTPUT_X86_64}/.config --enable CONFIG_64BIT && \
    make O=${KBUILD_OUTPUT_X86_64} ARCH=${ARCH_X86_64} LLVM=${LLVM} olddefconfig && \
    make O=${KBUILD_OUTPUT_X86_64} ARCH=${ARCH_X86_64} LLVM=${LLVM} -j$(nproc) vmlinux && \
    make O=${KBUILD_OUTPUT_X86_64} ARCH=${ARCH_X86_64} LLVM=${LLVM} modules_prepare && \
    make O=${KBUILD_OUTPUT_X86_64} ARCH=${ARCH_X86_64} LLVM=${LLVM} -j$(nproc) modules && \
    make O=${KBUILD_OUTPUT_X86_64} ARCH=${ARCH_X86_64} LLVM=${LLVM} rustavailable && \
    make O=${KBUILD_OUTPUT_X86_64} ARCH=${ARCH_X86_64} LLVM=${LLVM} "-j$(nproc)" prepare && \
    make O=${KBUILD_OUTPUT_X86_64} ARCH=${ARCH_X86_64} LLVM=${LLVM} "-j$(nproc)" rust/ && \
    touch ${KBUILD_OUTPUT_X86_64}/Module.symvers && \
    make O=${KBUILD_OUTPUT_X86_64} ARCH=${ARCH_X86_64} LLVM=${LLVM} modules_prepare

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
COPY --from=build-arm /build/arm /build/arm/
COPY --from=build-riscv /build/riscv /build/riscv/
COPY --from=build-s390 /build/s390 /build/s390/
COPY --from=build-x86_64 /build/x86_64 /build/x86_64/

WORKDIR /src
CMD ["bash"]