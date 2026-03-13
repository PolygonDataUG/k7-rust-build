# Security Policy / Sicherheitsrichtlinie

## English

### Security Requirements: What to Expect
- **Base Image Updates:** We aim to update the base image regularly to include the latest security patches.
- **Vulnerability Scanning:** We use automated tools (e.g., Hadolint) to ensure the Dockerfile follows security best practices.
- **Toolchain Integrity:** Rust-for-Linux toolchains are pulled from verified sources.


### Secure Design
We follow the principle of Least Privilege (e.g., running containers as non-root) and Attack Surface Reduction by removing unnecessary tools from the final image.

### What NOT to Expect (Security Boundaries)
- **Kernel Security:** This project provides the *build environment*. We do not guarantee the security of the kernel code you compile with it.
- **Third-Party Code:** We do not audit external Rust crates or drivers added by the user.
- **Hotfixes:** Security fixes are integrated during the next build cycle; we do not provide "live patching" for running containers.

### Reporting a Vulnerability
If you discover a security vulnerability, please report it via a **GitLab Issue**.

**Note:** If the "Confidential" checkbox is not available, please do not post sensitive details directly. Instead, create a brief issue titled "Security Inquiry" and we will contact you to provide a secure channel for communication.

### Supported Versions
We provide security updates for the latest version of this build environment.

---

## Deutsch

### Sicherheitsanforderungen: Was zu erwarten ist
- **Base-Image-Updates:** Wir streben an, das Basis-Image regelmäßig zu aktualisieren, um die neuesten Sicherheitspatches zu integrieren.
- **Schwachstellen-Scans:** Wir nutzen automatisierte Tools (z. B. Hadolint), um sicherzustellen, dass das Dockerfile Sicherheits-Best-Practices folgt.
- **Integrität der Toolchain:** Rust-for-Linux Toolchains werden aus verifizierten Quellen bezogen.

### Was NICHT zu erwarten ist (Sicherheitsgrenzen)
- **Kernel-Sicherheit:** Dieses Projekt stellt die *Build-Umgebung* bereit. Wir garantieren nicht die Sicherheit des Kernel-Codes, den du damit kompilierst.
- **Drittanbieter-Code:** Wir auditieren keine externen Rust-Crates oder Treiber, die durch den Nutzer hinzugefügt werden.
- **Hotfixes:** Sicherheitsfixes werden beim nächsten Build-Zyklus integriert; wir bieten kein "Live-Patching" für laufende Container an.


### Sicheres Design
Wir folgen dem Prinzip der minimalen Rechtevergabe (z. B. Ausführen von Containern als Non-Root) und der Reduzierung der Angriffsfläche, indem unnötige Werkzeuge aus dem finalen Image entfernt werden.


### Meldung einer Sicherheitslücke
Wenn du eine Sicherheitslücke entdeckst, melde diese bitte über ein **GitLab Issue**.

**Hinweis:**
Falls die Option "Vertraulich" (Confidential) nicht verfügbar ist, poste bitte keine sensiblen Details direkt im Ticket. Erstelle stattdessen ein kurzes Ticket mit dem Titel "Sicherheitsanfrage". Wir werden dich dann kontaktieren, um einen sicheren Kommunikationsweg bereitzustellen.

### Unterstützte Versionen
Wir unterstützen aktiv die jeweils neueste Version dieser Build-Umgebung und stellen dafür Sicherheitsupdates bereit.

