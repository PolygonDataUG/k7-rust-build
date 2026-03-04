# k7-rust-build

Docker-based build environment for developing Rust Kernel Modules for Linux Kernel 7 (ARM64).

---

## English Version

### Description
This repository provides a pre-configured Dockerfile to set up a complete toolchain for "Rust-for-Linux". It includes all necessary dependencies like LLVM, Clang, and a specific Rust version (1.78.0) to compile and prepare the Linux Kernel 7 source tree for ARM64 architectures.

### Features
* **Architecture:** Optimized for ARM64 (cross-compilation).
* **Kernel:** Automatically clones and prepares the latest Rust-enabled Linux Kernel 7.
* **Toolchain:** Includes `rust-src`, `bindgen`, and LLVM/Clang integration.
* **Ready-to-use:** Pre-builds `rust/core.o` and `rust/kernel.o` to save time.

### How to use
#### 1. Build the Image
```bash
docker build -t k7-rust-build .
2. Run the Container
Mount your local module source code into the /src directory:
```
``` Bash
docker run -it -v $(pwd):/src k7-rust-build
```
License & Compliance
Dockerfile: This build script is licensed under GPLv2.

Included Software: The resulting image downloads and contains the Linux Kernel, which is also licensed under GPLv2.

Third-Party: Other tools (Rust, LLVM) follow their respective open-source licenses.

Deutsche Version
Beschreibung
Dieses Repository bietet ein vorkonfiguriertes Dockerfile, um eine vollständige Toolchain für "Rust-for-Linux" aufzusetzen. Es enthält alle notwendigen Abhängigkeiten wie LLVM, Clang und eine spezifische Rust-Version (1.78.0), um den Linux-Kernel 7 Quellcode für ARM64-Architekturen zu kompilieren und vorzubereiten.

Funktionen
Architektur: Optimiert für ARM64 (Cross-Compilation).

Kernel: Klont und bereitet automatisch den neuesten Linux-Kernel 7 mit Rust-Unterstützung vor.

Toolchain: Enthält rust-src, bindgen und LLVM/Clang-Integration.

Einsatzbereit: Kompiliert rust/core.o und rust/kernel.o vorab, um Zeit zu sparen.

Verwendung
1. Image erstellen
Bash
docker build -t k7-rust-build .
2. Container starten
Mounte deinen lokalen Modul-Quellcode in das Verzeichnis /src:

Bash
docker run -it -v $(pwd):/src k7-rust-build
Lizenz & Konformität
Dockerfile: Dieses Build-Skript ist unter der GPLv2 lizenziert.

Enthaltene Software: Das resultierende Image lädt den Linux-Kernel herunter und enthält diesen, welcher ebenfalls unter der GPLv2 lizenziert ist.

Drittanbieter: Andere Tools (Rust, LLVM) unterliegen ihren jeweiligen Open-Source-Lizenzen.

Author & Copyright
Fabian Szukat Polygon Data UG Copyright: (c) 2026 Polygon Data UG
