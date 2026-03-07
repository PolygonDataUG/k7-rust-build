# Contributing to k7-rust-build

Thank you for your interest in contributing. As an experienced IT specialist, I place high value on clean code, automated testing, and transparent documentation.

## Submission Process
1. **Create an Issue:** Before making significant changes, please open a GitLab issue to discuss your proposal.
2. **Branching:** Create a new branch for your feature or bugfix (e.g., `feature/new-function` or `fix/bug-description`).
3. **Pull Request (PR):** Describe exactly what was changed and why. Reference the corresponding issue.

## Policy for New Functionality and Testing [test_policy_mandated]
All new features or changes to the build environment must follow this formal process:
- **Automated Testing:** Every change to the Dockerfile or scripts must be verified by running `./generate_audit.sh`.
- **Functional Validation:** A successful `docker build` and a test kernel compilation must be performed.
- **Mandatory Test Addition:** If a new tool is added, a check must be integrated into the audit suite to ensure long-term stability.

## Documentation Maintenance
Keeping documentation synchronized with the software is mandatory:
- **Consistency:** All documentation must reflect the current state of the build environment.
- **Bug Tracking:** Documentation errors or outdated information are treated as technical bugs, tracked via issues, and resolved promptly.

## Technical Standards
- **Reproducibility:** All Dockerfile changes must ensure build stability.
- **Security:** Avoid unnecessary packages. Always use `--no-install-recommends`.
- **Audit:** Submissions are only accepted if `HADOLINT_AUDIT.md` contains no new warnings.

## Code of Conduct
I expect professional and respectful interaction. Detailed procedures are found in the [Code of Conduct](CODE_OF_CONDUCT.md).

## Legal Requirements (DCO)
We use the **Developer Certificate of Origin (DCO)**. Every commit must include a sign-off using the `-s` flag:
`git commit -s -m "Your message"`

---

# Mitwirken an k7-rust-build

Vielen Dank für dein Interesse. Als erfahrener IT-Spezialist lege ich großen Wert auf sauberen Code, automatisierte Tests und eine nachvollziehbare Dokumentation.

## Prozess für Einreichungen
1. **Issue erstellen:** Bevor du größere Änderungen vornimmst, öffne bitte ein GitLab Issue, um das Vorhaben zu besprechen.
2. **Branching:** Erstelle einen neuen Branch für dein Feature oder deinen Bugfix (z. B. `feature/neue-funktion`).
3. **Pull Request (PR):** Beschreibe genau, was geändert wurde und verweise auf das entsprechende Issue.

## Richtlinie für neue Funktionalitäten und Tests [test_policy_mandated]
Alle neuen Funktionen oder Änderungen an der Build-Umgebung unterliegen diesem Prozess:
- **Automatisiertes Testen:** Jede Änderung am Dockerfile oder an Skripten muss durch `./generate_audit.sh` verifiziert werden.
- **Funktionale Validierung:** Ein erfolgreicher `docker build` sowie eine Test-Kompilierung des Kernels sind zwingend erforderlich.
- **Test-Verpflichtung:** Bei Aufnahme neuer Tools muss eine entsprechende Prüfung in die Audit-Suite integriert werden.

## Pflege der Dokumentation
Die Aktualität der Dokumentation ist eine Kernanforderung:
- **Konsistenz:** Die Dokumentation muss stets den aktuellen Stand der Build-Umgebung widerspiegeln.
- **Fehlerbehebung:** Dokumentationsfehler oder veraltete Informationen werden als technische Bugs behandelt, über Issues nachverfolgt und zeitnah behoben.

## Technische Standards
- **Reproduzierbarkeit:** Änderungen am Dockerfile müssen die Build-Stabilität gewährleisten.
- **Sicherheit:** Vermeide unnötige Pakete. Nutze immer `--no-install-recommends`.
- **Audit:** Einreichungen werden nur akzeptiert, wenn `HADOLINT_AUDIT.md` keine neuen Warnungen enthält.

## Verhaltenskodex
Ich erwarte einen professionellen Umgang. Regeln findest du im [Code of Conduct](CODE_OF_CONDUCT.md).

## Rechtliche Anforderungen (DCO)
Wir nutzen das **Developer Certificate of Origin (DCO)**. Jeder Commit muss eine Signatur enthalten (Flag `-s`):
`git commit -s -m "Deine Nachricht"`