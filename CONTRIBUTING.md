# Contributing to k7-rust-build
​Vielen Dank für dein Interesse, an diesem Projekt mitzuwirken. Als erfahrener IT-Spezialist lege ich großen Wert auf sauberen Code, automatisierte Tests und eine nachvollziehbare Dokumentation.  
​Prozess für Einreichungen
​Issue erstellen: Bevor du größere Änderungen vornimmst, öffne bitte ein Issue, um das Vorhaben zu besprechen.
​Branch-Konvention: Erstelle einen neuen Branch für dein Feature oder deinen Bugfix (z. B. feature/neue-funktion oder fix/bug-beschreibung).
​Code-Qualität & Linting: * Führe vor dem Commit das Audit-Skript ./generate_audit.sh aus.
​Einreichungen werden nur akzeptiert, wenn das HADOLINT_AUDIT.md keine neuen Warnungen für das Dockerfile aufweist.
​Pull Request (PR):
​Beschreibe im PR genau, was geändert wurde und warum.
​Verweise auf das entsprechende Issue.
​Technische Standards
​Da dieses Projekt auf Rust-for-Linux und den Kernel 7 ausgerichtet ist, gelten folgende Anforderungen:  
​Reproduzierbarkeit: Alle Änderungen am Dockerfile müssen die Build-Stabilität gewährleisten.  
​Sicherheit: Vermeide das Hinzufügen unnötiger Pakete. Nutze immer --no-install-recommends.  
​Kernel-Konformität: Änderungen an der Kernel-Konfiguration müssen über scripts/config dokumentiert werden.
​Verhaltenskodex
​Ich erwarte einen professionellen und respektvollen Umgang, wie er auch in meiner langjährigen Tätigkeit als Administrator und Entwickler Standard ist.  
