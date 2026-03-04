# k7-rust-build

**EN:** Docker-based build environment for developing Rust Kernel Modules for Linux Kernel 7 (ARM64).  
**DE:** Docker-basierte Build-Umgebung für die Entwicklung von Rust-Kernel-Modulen für den Linux-Kernel 7 (ARM64).

---

## Description / Beschreibung

**EN:** This repository provides a pre-configured Dockerfile to set up a complete toolchain for "Rust-for-Linux". It includes all necessary dependencies like LLVM, Clang, and a specific Rust version (1.78.0) to compile and prepare the Linux Kernel 7 source tree for ARM64 architectures.

**DE:** Dieses Repository bietet ein vorkonfiguriertes Dockerfile, um eine vollständige Toolchain für "Rust-for-Linux" aufzusetzen. Es enthält alle notwendigen Abhängigkeiten wie LLVM, Clang und eine spezifische Rust-Version (1.78.0), um den Linux-Kernel 7 Quellcode für ARM64-Architekturen zu kompilieren und vorzubereiten.

---

## Features / Funktionen

* **Architecture:** Optimized for ARM64 (cross-compilation).
* **Kernel:** Automatically clones and prepares the latest Rust-enabled Linux Kernel 7.
* **Toolchain:** Includes `rust-src`, `bindgen`, and LLVM/Clang integration.
* **Ready-to-use:** Pre-builds `rust/core.o` and `rust/kernel.o` to save time.

---

## How to use / Verwendung

### 1. Build the Image / Image erstellen
```bash
docker build -t k7-rust-build .
2. Run the Container / Container starten
EN: Mount your local module source code into the /src directory:

DE: Mounte deinen lokalen Modul-Quellcode in das Verzeichnis /src:

Bash
docker run -it -v $(pwd):/src k7-rust-build

```
License / Lizenz
EN:

Dockerfile: Licensed under the GPLv2 License.


Copyright: (c) 2026 Polygon Data UG


Dockerfile: Lizenziert unter der GPLv2-Lizenz.

Copyright: (c) 2026 Polygon Data UG

Author
Fabian Szukat Polygon Data UG
