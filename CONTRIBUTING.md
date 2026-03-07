# Contributing to k7-rust-build
Thank you for your interest in contributing to this project. As an experienced IT specialist, I place high value on clean code, automated testing, and transparent documentation.

## Submission Process
Create an Issue
Before making significant changes, please open an issue to discuss your proposal.

## Branching Convention
Create a new branch for your feature or bugfix (e.g., feature/new-function or fix/bug-description).

## Code Quality & Linting
Run the audit script ./generate_audit.sh before committing. Submissions will only be accepted if HADOLINT_AUDIT.md contains no new warnings for the Dockerfile.

## Pull Request (PR)
Describe exactly what was changed and why in the PR. Please reference the corresponding issue.

## Technical Standards
Since this project targets Rust-for-Linux and Kernel 7, the following requirements apply:

Reproducibility: All changes to the Dockerfile must ensure build stability.

Security: Avoid adding unnecessary packages. Always use --no-install-recommends.

Kernel Compliance: Changes to the kernel configuration must be documented via scripts/config.

## Code of Conduct
I expect professional and respectful interaction, consistent with the standards maintained throughout my long-standing career as an administrator and developer.

## Legal Requirements (DCO)

To ensure the legal integrity of the project, we use the **Developer Certificate of Origin (DCO)**. By contributing, you certify that you have the right to submit your code under the project's license.

Every commit must include a sign-off. This is done automatically by using the `-s` flag:
`git commit -s -m "Your message"`

By adding this line, you agree to the [Developer Certificate of Origin 1.1](https://developercertificate.org/).


# Contributing to k7-rust-build

Vielen Dank für dein Interesse, an diesem Projekt mitzuwirken.  
Als erfahrener IT-Spezialist lege ich großen Wert auf sauberen Code, automatisierte Tests und eine nachvollziehbare Dokumentation.

## Prozess für Einreichungen

1. **Issue erstellen**  
   Bevor du größere Änderungen vornimmst, öffne bitte ein Issue, um das Vorhaben zu besprechen.

2. **Branch-Konvention**  
   Erstelle einen neuen Branch für dein Feature oder deinen Bugfix  
   (z. B. `feature/neue-funktion` oder `fix/bug-beschreibung`).

3. **Code-Qualität & Linting**

   - Führe vor dem Commit das Audit-Skript `./generate_audit.sh` aus.
   - Einreichungen werden nur akzeptiert, wenn `HADOLINT_AUDIT.md`
     keine neuen Warnungen für das Dockerfile enthält.

4. **Pull Request (PR)**

   - Beschreibe im PR genau, was geändert wurde und warum.
   - Verweise auf das entsprechende Issue.

## Technische Standards

Da dieses Projekt auf **Rust-for-Linux** und **Kernel 7** ausgerichtet ist, gelten folgende Anforderungen:

- **Reproduzierbarkeit**  
  Alle Änderungen am Dockerfile müssen die Build-Stabilität gewährleisten.

- **Sicherheit**  
  Vermeide das Hinzufügen unnötiger Pakete. Nutze immer `--no-install-recommends`.

- **Kernel-Konformität**  
  Änderungen an der Kernel-Konfiguration müssen über `scripts/config` dokumentiert werden.

## Verhaltenskodex

Ich erwarte einen professionellen und respektvollen Umgang, wie er auch in meiner langjährigen Tätigkeit als Administrator und Entwickler Standard ist.
## Rechtliche Anforderungen (DCO)

Um die rechtliche Integrität des Projekts sicherzustellen, wird das **Developer Certificate of Origin (DCO)** verwendet. Mit deinem Beitrag bestätigst du, dass du das Recht hast, diesen Code unter der Projektlizenz zu veröffentlichen.

Jeder Commit muss eine Signatur enthalten. Diese wird automatisch erstellt, wenn du das Flag `-s` verwendest:
`git commit -s -m "Deine Nachricht"`

Durch das Hinzufügen dieser Zeile bestätigst du das [Developer Certificate of Origin 1.1](https://developercertificate.org/).
