# k7-rust-build

[![OpenSSF Best Practices](https://www.bestpractices.dev/projects/12099/badge)](https://www.bestpractices.dev/projects/12099)  
[![OpenSSF Baseline](https://www.bestpractices.dev/projects/12099/baseline)](https://www.bestpractices.dev/projects/12099)

---

## Overview

Setting up a development environment for **Rust Kernel Modules** is notoriously difficult due to strict version requirements for LLVM, bindgen, and the Rust compiler.

**k7-rust-build** eliminates this dependency hell by providing a fully containerized and pre-configured development environment.

The container includes a prepared **Rust-for-Linux kernel build tree** and allows developers to immediately start building **external Rust kernel modules** without manually configuring the kernel toolchain.

---

# English Version

## Description

This container provides a **build environment only**.

It is **not intended for production runtime use**.

The image contains:

- Rust-for-Linux toolchain
- LLVM / Clang toolchain
- multiple cross-compilers
- prepared Linux kernel build trees
- `Module.symvers` for external kernel modules
- prebuilt Rust kernel objects

The Dockerfile automatically clones the **Rust-for-Linux kernel repository** and prepares the kernel build system for multiple architectures.

---

## Supported Architectures

The container prepares kernel build directories for:

- ARM64
- ARM
- RISC-V
- LoongArch
- s390
- x86_64

Each architecture receives its own prepared kernel build tree in:

```
/build/<architecture>
```

Example:

```
/build/arm64
/build/x86_64
/build/riscv
```

These directories include the files required to build **external Rust kernel modules**.

---

## Toolchain

The container installs:

- Rust **1.82.0**
- `rust-src`
- `bindgen-cli 0.69.5`
- LLVM / Clang
- multiple cross-compilers
- Linux kernel build dependencies

The Rust toolchain is installed via **rustup** and configured automatically.

---

## Kernel Source

The kernel source is cloned from:

https://github.com/Rust-for-Linux/linux

Only the latest commit is cloned to keep the image smaller.

---

## Prebuilt Kernel Artifacts

During the image build process the container compiles:

- `vmlinux`
- kernel modules
- `rust/core.o`
- `rust/kernel.o`

This significantly reduces compile time when building external modules.

The build process also generates:

```
Module.symvers
```

which is required for external kernel module builds.

---

## Build the Image

```bash
docker build -t k7-rust-build .
```

---

## Run the Container

Mount your local module source directory into `/src`.

Example:

```bash
docker run -it -v $(pwd):/src k7-rust-build
```

Inside the container you can build kernel modules against the prepared kernel build trees.

---

## License & Compliance

### Dockerfile

The Dockerfile is licensed under:

GPL-2.0-only

### Included Software

The container downloads the **Linux Kernel**, which is licensed under:

GPLv2

### Third Party Components

Other included tools follow their own licenses:

- Rust → MIT / Apache 2.0
- LLVM / Clang → Apache 2.0 with LLVM exceptions

---

# Deutsche Version

## Beschreibung

Dieses Container-Image stellt eine **vorkonfigurierte Build-Umgebung für Rust-for-Linux Kernelmodule** bereit.

Das Ziel ist es, die komplexe Einrichtung der Toolchain zu vermeiden, die normalerweise notwendig ist, um **Rust-Kernelmodule zu kompilieren**.

Der Container enthält:

- Rust Toolchain
- LLVM / Clang
- mehrere Cross-Compiler
- vorbereitete Kernel-Build-Umgebungen
- `Module.symvers`
- vorkompilierte Rust Kernel-Objekte

Der Linux Kernel wird automatisch aus dem **Rust-for-Linux Repository** geklont und vorbereitet.

---

## Unterstützte Architekturen

Der Container bereitet Kernel-Builds für folgende Architekturen vor:

- ARM64
- ARM
- RISC-V
- LoongArch
- s390
- x86_64

Für jede Architektur existiert ein eigenes Build-Verzeichnis:

```
/build/<architektur>
```

Beispiele:

```
/build/arm64
/build/x86_64
/build/riscv
```

Diese Verzeichnisse können zum Kompilieren externer Kernelmodule verwendet werden.

---

## Toolchain

Der Container installiert:

- Rust **1.82.0**
- `rust-src`
- `bindgen-cli 0.69.5`
- LLVM / Clang
- Kernel Build Tools
- Cross Compiler

Die Rust Installation erfolgt automatisch über **rustup**.

---

## Kernel Quelle

Der Kernel wird automatisch aus folgendem Repository geklont:

https://github.com/Rust-for-Linux/linux

Es wird nur der aktuelle Commit geladen, um die Imagegröße klein zu halten.

---

## Vorkompilierte Kernel Artefakte

Während des Docker-Builds werden bereits folgende Artefakte erzeugt:

- `vmlinux`
- Kernel Module
- `rust/core.o`
- `rust/kernel.o`

Zusätzlich wird erzeugt:

```
Module.symvers
```

Diese Datei ist notwendig, um externe Kernelmodule zu kompilieren.

---

## Image erstellen

```bash
docker build -t k7-rust-build .
```

---

## Container starten

Lokalen Modul-Code nach `/src` mounten:

```bash
docker run -it -v $(pwd):/src k7-rust-build
```

Danach können Rust Kernelmodule direkt im Container gebaut werden.

---

## Author & Copyright

Author: **Fabian Szukat**  
Company: **Polygon Data UG**  
Copyright: **© 2026 Polygon Data UG**