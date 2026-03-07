# Security Assurance Case

Dieses Dokument dient als Nachweis für die systematische Umsetzung von Sicherheitsanforderungen innerhalb des Projekts. Es beschreibt die Architektur, die Bedrohungslandschaft und die angewandten Schutzmaßnahmen.

---

## 1. Bedrohungsmodell (Threat Model)
Wir setzen das **STRIDE-Modell** ein, um potenzielle Angriffsvektoren strukturiert zu adressieren:

* **Spoofing (Identitätsvortäuschung):** Authentifizierung erfolgt ausschließlich über starke Verfahren wie [z.B. Ed25519 SSH-Keys oder TLS-Zertifikate].
* **Tampering (Manipulation):** Alle Releases und Git-Tags sind kryptographisch signiert. Toolchains und Abhängigkeiten werden mittels SHA-256/512 Hashes auf Integrität geprüft.
* **Repudiation (Abstreitbarkeit):** Kritische Systemereignisse und administrative Zugriffe werden in manipulationsgeschützten Audit-Logs protokolliert.
* **Information Disclosure (Informationsenthüllung):** Datenübertragung erfolgt via TLS 1.2+; sensible Daten im Ruhezustand werden mit AES-256 verschlüsselt.
* **Denial of Service (Dienstverweigerung):** Implementierung von [z.B. Rate Limiting, Timeouts und Ressourcen-Quotas].
* **Elevation of Privilege (Rechteausweitung):** Strikte Trennung von Nutzerrollen und Anwendung des Least-Privilege-Prinzips auf Prozessebene.



---

## 2. Vertrauensgrenzen (Trust Boundaries)
Die Systemarchitektur definiert klare Grenzen zwischen verschiedenen Vertrauensebenen:

1.  **Zone 0 (Untrusted):** Das öffentliche Internet und alle ungeprüften Benutzereingaben.
2.  **Zone 1 (Semi-Trusted):** Die Build-Umgebung und CI/CD-Pipelines, in denen Code transformiert wird.
3.  **Zone 2 (Trusted):** Interne Backend-Systeme, Datenbanken und kryptographische Schlüsselspeicher (Secrets).

**Validierung:** Jede Kommunikation, die eine Grenze von einer niedrigeren in eine höhere Zone überschreitet, wird durch eine strikte Eingabevalidierung (Allowlist-Verfahren) und Authentifizierung gesichert.



---

## 3. Sichere Designprinzipien (Secure Design)
* **Least Privilege:** Jeder Dienst läuft mit der minimal notwendigen Berechtigungsstufe. Dateisystemzugriffe sind auf das absolute Minimum beschränkt.
* **Defense in Depth:** Mehrschichtige Sicherheit durch Kombination von Netzwerk-Firewalls, Applikations-Gateways und Verschlüsselung auf Host-Ebene.
* **Fail Securely:** Bei Systemfehlern oder Authentifizierungs-Timeouts schaltet das System in einen "Deny-All"-Zustand.
* **Agilität:** Durch Unterstützung mehrerer Algorithmen (AES, Twofish, Serpent) bleibt das System bei Schwachstellen in einzelnen Verfahren handlungsfähig.

---

## 4. Vermeidung von Implementierungsschwächen
Um gängige Sicherheitslücken proaktiv zu verhindern, werden folgende Maßnahmen angewendet:

* **Eingabevalidierung:** Alle externen Daten werden gegen ein definiertes Schema geprüft; ungültige Zeichenfolgen werden sofort verworfen.
* **Speichersicherheit:** Einsatz von Härtungsmechanismen wie Stack Canaries, ASLR (Address Space Layout Randomization) und NX-Bits.
* **Kryptographische Standards:** Verzicht auf veraltete Verfahren (SHA-1, MD5, SSH-CBC). Fokus auf moderne, kollisionsresistente Algorithmen.
* **Credential Agility:** Private Schlüssel und Token werden getrennt von Logik und Konfiguration gespeichert und können ohne Neukompilierung rotiert werden.

---

## 5. Wartung und Assurance
Die Wirksamkeit dieser Maßnahmen wird durch:
* Automatisierte statische Code-Analyse (SAST).
* Regelmäßige Scans von Abhängigkeiten auf bekannte Schwachstellen (CVEs).
* Manuelle Code-Reviews bei sicherheitskritischen Änderungen.

erhalten.
