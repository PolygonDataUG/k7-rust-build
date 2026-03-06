# Automatisiertes Hadolint Audit Protokoll

**Projekt:** k7-rust-build
**Datum der Prüfung:** 06.03.2026 10:38:05
**Status:** Statischer Snapshot für OpenSSF Best Practices

## 1. Analyse-Ergebnis (Hadolint Output)
Dieses Protokoll wurde automatisch generiert. Es dokumentiert den Zustand des Dockerfiles zum Zeitpunkt des Releases.

```text
-:17 DL3008 ^[[1m^[[93mwarning^[[0m: Pin versions in apt get install. Instead of `apt-get install <package>` use `apt-get install <package>=<version>`
-:17 DL3009 ^[[92minfo^[[0m: Delete the apt lists (/var/lib/apt/lists) after installing something
-:17 DL3015 ^[[92minfo^[[0m: Avoid additional packages by specifying `--no-install-recommends`
-:23 DL4006 ^[[1m^[[93mwarning^[[0m: Set the SHELL option -o pipefail before RUN with a pipe in it. If you are using /bin/sh in an alpine image or if you$
-:48 SC2046 ^[[1m^[[93mwarning^[[0m: Quote this to prevent word splitting.
-:58 SC2046 ^[[1m^[[93mwarning^[[0m: Quote this to prevent word splitting.
```

## 2. Konformitäts-Nachweis
Dieses Dokument dient als unveränderlicher Nachweis für die Einhaltung der Best Practices im Bereich "Statische Analyse". Falls die obige Sektion keine F$

---
*Generiert durch das Polygon Data UG Audit-Tool.*

