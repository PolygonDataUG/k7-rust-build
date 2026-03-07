# Project Governance – k7-rust-build

## Current Status: Single-Maintainer
This project is currently managed by a single **Lead Maintainer (Fabian)**. All technical decisions, architectural guidelines, and code merges are his responsibility.

## Roles and Task Distribution
As the project grows, the following roles and their specific duties are established:

### Lead Maintainer (currently: Fabian)
* **Architecture:** Decisions on the technical structure of the Rust-for-Linux build system.
* **Releases:** Final approval, tagging, and signing of stable versions.
* **Security:** Primary point of contact for vulnerability reports and coordinating fixes.
* **Compliance:** Ensuring the project adheres to Kernel 7 standards and DCO requirements.

### Maintainer (Future Role)
* **Code Review:** Technical vetting of Pull Requests against `reports/HADOLINT_AUDIT.md`.
* **CI/CD Oversight:** Monitoring automated tests and ensuring build stability.
* **Mentorship:** Assisting contributors with technical integration.

### Contributor
* **Development:** Submitting code fixes or features via Pull Requests.
* **Documentation:** Keeping the technical documentation up to date.
* **Self-Audit:** Running `./src/scripts/audit-k7-rust-build` before submission.

## Promotion to Maintainer
Contributors may be promoted to Maintainers if they:
1. Demonstrate a consistent track record of high-quality contributions over at least 6 months.
2. Master the strict audit requirements (Hadolint, Rust standards).
3. Show deep understanding of Kernel 7 and Rust-for-Linux integration.

## Conflict Resolution
If disagreements arise, a consensus-based solution is sought. If no consensus can be reached, the Lead Maintainer makes the final decision.

## Project Continuity and Emergency Access

To ensure the project's survival in the event that the Lead Maintainer is no longer able to manage it, the following measures have been taken:

- **Access Recovery:** Instructions and necessary credentials (including repository access and deployment keys) are stored in a secure offline location (physical lockbox/digital vault).
- **Authorized Person:** A trusted individual has been briefed on how to access these credentials to hand them over to a successor or a trusted community member within one week of confirmation of incapacity.
- **Legal Rights:** All necessary rights (DNS, Repository ownership) are intended to be transferred to the successor to ensure uninterrupted development and releases.
### Bus Factor
Currently, the project has a bus factor of 1. To mitigate the associated risks, a comprehensive emergency access plan has been established (see "Project Continuity and Emergency Access"). The project is open to appointing additional maintainers in the future to increase the bus factor as the community grows.
---

# Projekt-Governance – k7-rust-build

## Aktueller Status: Einzel-Maintainer
Dieses Projekt wird derzeit von einem einzelnen **Lead-Maintainer (Fabian)** verwaltet. Alle technischen Entscheidungen, Architekturvorgaben und Code-Merges liegen in seiner Verantwortung.

## Rollen und Aufgabenverteilung
Sobald das Projekt wächst, sieht das Modell folgende Rollen und Tätigkeiten vor:

### Lead Maintainer (aktuell: Fabian)
* **Architektur:** Entscheidung über die technische Struktur des Rust-Build-Systems.
* **Releases:** Finale Freigabe, Tagging und Signierung von stabilen Versionen.
* **Sicherheit:** Hauptansprechpartner für Sicherheitsberichte und Koordination von Fixes.
* **Compliance:** Sicherstellung der Kernel-7-Standards und DCO-Vorgaben.

### Maintainer (Zukünftige Rolle)
* **Code Review:** Technische Prüfung von Pull Requests gegen `reports/HADOLINT_AUDIT.md`.
* **CI/CD-Überwachung:** Kontrolle der automatisierten Tests und Sicherstellung der Build-Stabilität.
* **Mentoring:** Unterstützung von Contributors bei der technischen Integration.

### Contributor
* **Entwicklung:** Einreichung von Fixes oder Features via Pull Request.
* **Dokumentation:** Aktuellhaltung der technischen Dokumentation.
* **Eigen-Audit:** Ausführung von `./src/scripts/audit-k7-rust-build` vor der Einreichung.

## Aufstieg zum Maintainer
Mitwirkende können zu Maintainern ernannt werden, wenn sie:
1. Über einen Zeitraum von mindestens 6 Monaten kontinuierlich hochwertige Beiträge geliefert haben.
2. Die strengen Audit-Vorgaben (Hadolint, Rust-Standards) sicher beherrschen.
3. Ein tiefes Verständnis für die Integration in Kernel 7 und Rust-for-Linux zeigen.

## Konfliktlösung
Sollten Unstimmigkeiten auftreten, wird eine Lösung durch Konsens angestrebt. Kommt kein Konsens zustande, trifft der Lead Maintainer die finale Entscheidung.

## Projektkontinuität und Notfallzugriff

Um das Fortbestehen des Projekts zu gewährleisten, falls der Lead Maintainer nicht mehr in der Lage ist, es zu verwalten, wurden folgende Maßnahmen getroffen:

- **Zugriffssicherung:** Anweisungen und notwendige Zugangsdaten (einschließlich Repository-Zugriff und Deployment-Keys) sind an einem sicheren Offline-Ort (physischer Tresor/digitaler Safe) hinterlegt.
- **Autorisierte Person:** Eine Vertrauensperson wurde angewiesen, wie im Notfall auf diese Daten zuzugreifen ist, um sie innerhalb einer Woche nach Feststellung der Arbeitsunfähigkeit an einen Nachfolger oder ein vertrauenswürdiges Community-Mitglied zu übergeben.
- **Rechtliche Nachfolge:** Alle notwendigen Rechte (DNS, Repository-Besitz) sollen auf den Nachfolger übertragen werden, um eine unterbrechungsfreie Entwicklung und Veröffentlichung zu garantieren.

### Bus-Faktor
Aktuell weist das Projekt einen Bus-Faktor von 1 auf. Um die damit verbundenen Risiken zu minimieren, wurde ein umfassender Notfallplan erstellt (siehe „Projektkontinuität und Notfallzugriff“). Das Projekt ist offen dafür, in Zukunft weitere Maintainer zu ernennen, um den Bus-Faktor bei wachsender Community zu erhöhen.