# Changelog — Cerberus:opencode

**Dibuat oleh [Abhiprayaa29](https://github.com/Abhiprayaa29)**
**Berbasis [oh-my-open-pentest](https://github.com/zakirkun/oh-my-open-pentest) oleh zakirkun**

Semua perubahan penting pada proyek ini didokumentasikan di file ini.

Format mengikuti [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), dan proyek ini menganut [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

Belum ada perubahan yang dijadwalkan untuk rilis berikutnya.

---

## [1.0.0] - 2026-07-18

### Added

#### Orchestration & Agent System
- Multi-agent orchestrator dengan sub-agent spesialis (Cipher, Scout, Intel, Vanguard, Sentinel, Talos, Cerberus-Junior)
- IntentGate — klasifikasi intent user sebelum eksekusi (research, implement, investigate, fix, team)
- Category-based task routing — task otomatis dirutekan ke model optimal per domain
- Parallel background agents — eksekusi simultan untuk research, implementasi, dan verifikasi
- Team Mode (opt-in) — koordinasi multi-agent paralel dengan mailbox, shared task list, tmux visualization

#### Pentest Coverage (10 Fase)
- **Reconnaissance & OSINT** — subdomain enumeration, port scanning, technology fingerprinting, passive recon
- **Enumeration** — nuclei scanning, directory brute-forcing, CMS/tech detection, parameter discovery
- **Web Exploitation** — SQL injection, XSS, SSRF, SSTI, XXE, command injection, deserialization, race condition, business logic, prototype pollution, JWT, OAuth, dan 20+ vulnerability classes lainnya
- **Credential Attacks** — password spraying, hash cracking (hashcat/john), credential stuffing
- **Active Directory** — Kerberoasting, AS-REP Roasting, DCSync, Pass-the-Hash, BloodHound analysis, NTLM relay
- **Post-Exploitation** — Linux/Windows privilege escalation, credential dumping, lateral movement
- **Pivoting** — SSH tunneling, SOCKS proxy, chisel, ligolo-ng
- **Mobile** — Android (APK decompile, Frida hooking), iOS (IPA analysis, SSL pinning bypass)
- **Reverse Engineering** — Ghidra/Radare2, GDB/pwndbg, angr, firmware analysis, malware analysis
- **Forensics & IR** — memory forensics (Volatility3), disk forensics, PCAP analysis, steganography

#### Framework & Technology Coverage
- Web frameworks: Django, Laravel, Rails, Spring Boot, Express.js, Next.js, WordPress, Flask, FastAPI, ASP.NET
- Protocols: SMB, Kerberos, LDAP, RDP, SSH, SMTP, DNS, GraphQL, gRPC, WebSocket
- Infrastructure: Docker, Kubernetes, AWS/GCP/Azure (cloud), Jenkins, Redis, MongoDB, Elasticsearch

#### Security Tools Integration
- 109+ security tools via `tools-catalog.json` dengan auto-install
- Tool coverage: recon, enumeration, exploitation, credential, AD, C2, pivoting, forensics, reverse engineering, mobile
- Intelligence data layer: attack chains, WAF signatures, CVE correlations, tech correlations

#### Identity & Security Boundaries
- Identitas "Cerberus:opencode" dengan kredit eksplisit ke Abhiprayaa29
- 7 absolute restrictions (authorized testing only, no DoS, no data exfiltration, identity integrity, dll)
- Integrity protection — prompt injection resistance terhadap perubahan identitas/restriksi
- Ethical use disclaimer dan scope enforcement bawaan

#### Documentation
- README.md — dokumentasi utama, fitur, arsitektur, penggunaan, kredit
- CAPABILITIES.md — breakdown detail per fase pentest + skill playbooks
- INSTALL.md — panduan instalasi (plugin & manual) dengan restriksi pengguna
- SECURITY.md — responsible disclosure policy
- CONTRIBUTING.md — panduan kontribusi
- cerberus-agent.jsonc — OpenCode agent config siap pakai
- GitHub issue templates (bug report, feature request)
- CHANGELOG.md — riwayat rilis

### Notes
- Initial public release
- Based on [oh-my-open-pentest](https://github.com/zakirkun/oh-my-open-pentest) by zakirkun
- Licensed under Sustainable Use License (SUL 1.0)
- Requires OpenCode dan AI provider API key untuk penggunaan
- Seluruh tools keamanan adalah third-party — lisensi masing-masing berlaku

---

[Unreleased]: https://github.com/Abhiprayaa29/cerberus/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/Abhiprayaa29/cerberus/releases/tag/v1.0.0
