# Cerberus — Capabilities Breakdown

[![Version](https://img.shields.io/badge/version-1.0.0-00CED1)](CHANGELOG.md)

**Detailed capability mapping per pentest phase.**

Dokumen ini memberikan gambaran teknis lebih dalam tentang kemampuan Cerberus di setiap fase penetration testing, tool yang digunakan, dan jenis output yang dihasilkan. Cocok untuk security researcher yang ingin memahami scope teknis sebelum menggunakan atau berkontribusi.

> ⚠️ Seluruh kapabilitas di dokumen ini tunduk pada restriksi otorisasi yang dijelaskan di [README.md § Disclaimer & Etika Penggunaan](README.md#disclaimer--etika-penggunaan). Cerberus menolak eksekusi terhadap target tanpa otorisasi tertulis.

← Kembali ke [README.md](README.md)

---

## Daftar Isi

- [Phase 1: Reconnaissance & OSINT](#phase-1-reconnaissance--osint)
- [Phase 2: Enumeration & Vulnerability Assessment](#phase-2-enumeration--vulnerability-assessment)
- [Phase 3: Web Application Testing](#phase-3-web-application-testing)
- [Phase 4: Credential & Authentication Attacks](#phase-4-credential--authentication-attacks)
- [Phase 5: Active Directory & Internal Network](#phase-5-active-directory--internal-network)
- [Phase 6: Post-Exploitation & Pivoting](#phase-6-post-exploitation--pivoting)
- [Phase 7: Mobile Application Testing](#phase-7-mobile-application-testing)
- [Phase 8: Reverse Engineering](#phase-8-reverse-engineering)
- [Phase 9: Forensics & IR](#phase-9-forensics--ir)
- [Phase 10: Reporting & Documentation](#phase-10-reporting--documentation)
- [Skill Playbook Coverage](#skill-playbook-coverage)

---

## Phase 1: Reconnaissance & OSINT

Cerberus mengotomatiskan pengumpulan informasi awal tentang target menggunakan kombinasi tools dan teknik OSINT.

### Passive Reconnaissance

| Teknik | Tools | Output |
|--------|-------|--------|
| Subdomain enumeration | subfinder, amass, assetfinder | Daftar subdomain dengan resolusi DNS |
| DNS enumeration | dnsx, massdns, dig | DNS records (A, AAAA, CNAME, MX, TXT, NS) |
| Technology fingerprint | httpx, whatweb, wafw00f | Stack teknologi, web server, WAF detection |
| Certificate transparency | crt.sh via intel agents | Domain history, subdomain discovery |
| ASN/WHOIS lookup | whois, asn-based tools | IP ranges, organisasi, contact info |
| Email/credential OSINT | theHarvester, holehe | Email discovery, credential leak check |
| Social media intel | sherlock, maigret | Username enumeration across platforms |
| Google dorking | Google/Bing/DDG search operators | Exposed files, admin panels, sensitive directories |
| JavaScript analysis | katana, custom extraction | API endpoints, hardcoded secrets, internal hostnames |
| Favicon hashing | mmh3 + Shodan/FOFA/Censys | Infrastruktur fingerprinting |

### Active Reconnaissance

| Teknik | Tools | Output |
|--------|-------|--------|
| Port scanning | naabu, nmap, masscan, rustscan | Open ports, service banners |
| Service detection | nmap -sV, httpx | Versi service, OS detection |
| Network range mapping | nmap, masscan | Live hosts, network topology |
| Cloud assets | custom S3/Azure/GCP enumeration | Exposed storage buckets |

### Phase 1 Output

- Daftar target valid (live hosts + subdomain)
- Technology stack per target
- Port dan service yang terbuka
- Potensi entry points
- Attack surface map

---

## Phase 2: Enumeration & Vulnerability Assessment

Setelah target teridentifikasi, Cerberus melakukan scanning mendalam untuk menemukan kerentangan potensial.

### Automated Vulnerability Scanning

| Teknik | Tools | Cakupan |
|--------|-------|---------|
| Template-based scanning | nuclei (4000+ templates) | CVE, misconfigurations, exposure |
| Directory brute-forcing | ffuf, gobuster, feroxbuster, dirsearch | Hidden endpoints, admin panels, backup files |
| Web crawling | katana, gospider | Endpoint discovery, parameter extraction |
| Parameter discovery | arjun, ffuf | Hidden parameters, API endpoints |
| SSL/TLS assessment | testssl.sh | Cipher weaknesses, protocol support, cert issues |
| WAF detection | wafw00f | WAF type, bypass potential |
| Software composition | trivy | Known vulnerabilities in dependencies |

### Intelligence-Driven Assessment

Cerberus memuat data referensi saat runtime untuk scanning yang lebih cerdas:

- **Attack chains**: 40+ exploitation pathways multi-tahap
- **Vuln ontology**: 12 kategori vulnerability dengan CWE mapping
- **WAF signatures**: Fingerprinting untuk 30+ WAF platforms
- **Tech correlations**: Mapping teknologi → kerentangan yang umum
- **CVE correlations**: CVE → attack pattern mapping
- **Port correlations**: Port → service → recommended attack vector

### Phase 2 Output

- Daftar kerentangan potensial (severity-sorted)
- CVE match dengan teknologi target
- Endpoint dan parameter yang ditemukan
- Rekomendasi teknik eksploitasi per temuan

---

## Phase 3: Web Application Testing

Cerberus mencakup pengujian keamanan web application yang komprehensif.

### Vulnerability Classes

| Kelas | Skill Playbook | Teknik |
|-------|---------------|--------|
| **SQL Injection** | `/vuln-sqli` | Error-based, boolean blind, time-based, UNION, OOB, second-order, WAF bypass |
| **Cross-Site Scripting** | `/vuln-xss` | Reflected, stored, DOM-based, blind XSS, CSP bypass, mXSS |
| **Server-Side Request Forgery** | `/vuln-ssrf` | Cloud metadata exfiltration, internal pivot, blind OOB, protocol abuse |
| **Cross-Site Request Forgery** | `/vuln-csrf` | Token bypass, SameSite bypass, JSON/multipart CSRF |
| **Server-Side Template Injection** | `/vuln-ssti` | Jinja2, Twig, Freemarker, Velocity, ERB, Mako detection & RCE |
| **XML External Entity** | `/vuln-xxe` | File read, SSRF via XXE, blind OOB, SVG/DOCX XXE |
| **Insecure Deserialization** | `/vuln-deserialization` | Java ysoserial, PHP object injection, Python pickle RCE |
| **File Upload** | `/vuln-file-upload` | Extension bypass, MIME bypass, polyglot, webshell upload |
| **IDOR/BOLA** | `/vuln-idor` | Horizontal/vertical access control, REST/GraphQL/WebSocket |
| **JWT** | `/vuln-jwt` | Algorithm confusion, weak secret, kid/jwk injection |
| **OAuth** | `/vuln-oauth` | Redirect URI bypass, state CSRF, PKCE bypass, scope escalation |
| **Race Condition** | `/vuln-race-conditions` | TOCTOU, double-spend, rate limit bypass via HTTP/2 |
| **HTTP Request Smuggling** | `/vuln-http-smuggling` | CL.TE, TE.CL, TE.TE, H2 desync |
| **GraphQL** | `/proto-graphql` | Introspection, batching abuse, auth bypass, IDOR via aliases |
| **gRPC** | `/vuln-grpc` | Reflection enumeration, proto analysis, method injection |
| **WebSocket** | `/vuln-websocket` | CSWSH, message injection, auth bypass |
| **Business Logic** | `/vuln-business-logic` | Workflow bypass, price manipulation, quota bypass |
| **Prototype Pollution** | `/vuln-prototype-pollution` | Client-side XSS gadgets, server-side Node.js RCE |
| **Host Header Injection** | `/vuln-host-header` | Password reset poisoning, cache poisoning, routing bypass |

### Framework-Specific Testing

| Framework | Skill | Coverage |
|-----------|-------|----------|
| Django | `/framework-django` | Admin exposure, DEBUG RCE, CSRF, SSTI, ORM injection |
| Laravel | `/framework-laravel` | .env exposure, debug mode, mass assignment, queue deserialization |
| Spring Boot | `/framework-spring` | Actuator exposure, SpEL injection, heapdump, Spring4Shell |
| Express.js | `/framework-express` | Prototype pollution, CORS, middleware bypass, JWT abuse |
| Next.js | `/framework-nextjs` | API route exposure, SSRF via getServerSideProps, middleware bypass |
| WordPress | `/framework-wordpress` | User enum, xmlrpc abuse, plugin CVEs, REST API exposure |
| Rails | `/framework-rails` | Mass assignment, YAML deserialization, ActiveRecord injection |
| Flask | `/framework-flask` | Werkzeug debug RCE, secret key brute, Jinja2 SSTI |
| FastAPI | `/framework-fastapi` | OpenAPI exposure, auth bypass, SSRF, debug endpoints |
| ASP.NET | `/framework-dotnet` | ViewState deserialization, Razor SSTI, IIS misconfig |

### Phase 3 Output

- Validated vulnerability findings dengan PoC
- Request/response evidence
- CVSS 4.0 vector string dan score
- Remediation recommendation
- False positive excluded

---

## Phase 4: Credential & Authentication Attacks

### Password Attacks

| Teknik | Tools | Deskripsi |
|--------|-------|-----------|
| Brute force form login | hydra, ffuf | Form-based, basic auth, digest auth |
| Hash cracking | hashcat, john | Wordlist, rule-based, mask, hybrid attacks |
| Password spraying | hydra, netexec | Low-and-slow spraying untuk menghindari lockout |
| Credential stuffing | hydra, custom scripts | Kombinasi credential dari breach database |

### Authentication Testing

| Skill Playbook | Coverage |
|----------------|----------|
| `/vuln-auth-workflow` | Login bypass, session management, remember-me, concurrent sessions |
| `/vuln-2fa-bypass` | OTP brute force, response manipulation, backup code abuse |
| `/vuln-account-takeover` | Password reset flaws, email change bypass, CSRF chain to ATO |
| `/vuln-password-reset-poisoning` | Host header injection pada reset flow |
| `/vuln-mass-assignment` | Extra parameter injection, role bypass, admin flag |

### Phase 4 Output

- Valid credentials (jika ditemukan)
- Authentication bypass PoC
- Hash yang berhasil di-crack
- Session management vulnerabilities

---

## Phase 5: Active Directory & Internal Network

### Active Directory Attacks

| Teknik | Tools | Deskripsi |
|--------|-------|-----------|
| LDAP enumeration | netexec, ldapsearch | Users, groups, computers, trust relationships |
| Kerberoasting | impacket GetUserSPNs | Extract SPN-linked account hashes |
| AS-REP Roasting | impacket GetNPUsers | Accounts tanpa pre-authentication |
| DCSync | impacket secretsdump | Replicate domain controller database |
| Pass-the-Hash | impacket, netexec | Lateral movement with NTLM hash |
| Pass-the-Ticket | impacket | Golden/silver ticket attacks |
| BloodHound analysis | bloodhound-python | Attack path mapping ke Domain Admin |
| SMB enumeration | netexec, smbclient | Share access, null session |
| WinRM abuse | netexec, evil-winrm | Remote execution via WinRM |
| NTLM relay | impacket ntlmrelayx | Relay NTLM authentication |

### Internal Network

| Skill | Coverage |
|-------|----------|
| `/recon-internal` | Internal service discovery, network segmentation testing |
| `/proto-smb` | Null session, relay, EternalBlue, share enumeration |
| `/proto-kerberos` | Delegation attacks, ticket manipulation |
| `/proto-ldap` | Anonymous bind, attribute extraction |
| `/proto-rdp` | BlueKeep, NLA bypass, session hijacking |
| `/proto-ssh` | Key-based auth bypass, weak cipher detection |
| `/proto-mssql` | xp_cmdshell RCE, linked server abuse |
| `/proto-snmp` | Community string brute, OID walk |

### Container & Cloud

| Skill | Coverage |
|-------|----------|
| `/tech-docker` | Container escape, docker socket abuse, image secrets |
| `/tech-kubernetes` | API server enum, etcd access, pod escape, RBAC |
| `/tech-cloud-security` | AWS/GCP/Azure IMDS abuse, IAM escalation |
| `/post-container-escape` | cgroup release_agent, nsenter, CVE-based escapes |

### Phase 5 Output

- AD user/computer/group listing
- Cracked hashes (kerberoast, AS-REP)
- Attack path to Domain Admin (BloodHound)
- Accessible SMB/LDAP/WinRM services
- Privilege escalation pathways

---

## Phase 6: Post-Exploitation & Pivoting

### Privilege Escalation

| Platform | Skill | Coverage |
|----------|-------|----------|
| Linux | `/post-linux-privesc` | SUID, sudo misconfig, capabilities, cron jobs, kernel exploits |
| Windows | `/post-windows-privesc` | Token impersonation, unquoted paths, AlwaysInstallElevated, potato exploits |

### Credential Dumping

| Teknik | Deskripsi |
|--------|-----------|
| LSASS dump | Procdump, comsvcs, nanodump |
| SAM hive extraction | Registry hives, hash extraction |
| NTDS.dit | Domain controller database via shadow copy |
| LSA secrets | Windows LSA secrets extraction |
| DPAPI | Master key and credential decryption |

### Lateral Movement

| Skill | Teknik |
|-------|--------|
| `/post-lateral-movement` | pass-the-hash, WMI/WinRM/SMB exec, SSH key pivoting |
| `/post-pivoting` | SSH tunnels, SOCKS proxy, chisel, ligolo-ng |
| `/post-bloodhound` | Cypher query analysis, Neo4j traversal |
| `/post-credential-dumping` | Hash extraction and pass-the-hash chains |

### Phase 6 Output

- Privilege escalation PoC
- Extracted credentials/hashes
- Established persistence
- Tunnels/pivots to internal networks

---

## Phase 7: Mobile Application Testing

| Platform | Skill | Teknik |
|----------|-------|--------|
| Android | `/mobile-android`, `/ctf-android` | APK decompile (jadx, apktool), static analysis, Frida hooking, ADB dynamic analysis, shared preferences/SQLite extraction |
| iOS | `/mobile-ios` | IPA analysis, jailbreak detection bypass, SSL pinning bypass, Keychain inspection, runtime class introspection |
| Both | `/mobile-dynamic` | API security, traffic analysis, session management, auth bypass |

### Phase 7 Output

- Static analysis findings (hardcoded secrets, misconfigurations)
- Dynamic analysis (runtime behavior, network traffic)
- Exploitation PoC untuk vulnerabilities terverifikasi

---

## Phase 8: Reverse Engineering

| Area | Skill | Teknik |
|------|-------|--------|
| Static Analysis | `/re-static` | Ghidra/Radare2 disassembly, string extraction, binary analysis |
| Dynamic Analysis | `/re-dynamic` | GDB/pwndbg debugging, strace/ltrace, angr symbolic execution |
| Firmware/IoT | `/iot-firmware` | Binwalk extraction, QEMU emulation, credential hunting |
| WebAssembly | `/ctf-wasm` | wasm2wat decompilation, wasmtime execution, memory dump |
| Malware | `/ctf-malware-analysis` | PE analysis, .NET decompilation, C2 extraction, YARA rules |
| Anti-Analysis | `/ctf-reverse-anti-analysis` | Anti-debug bypass, anti-VM detection, MBA simplification |

### Phase 8 Output

- Decompiled/disassembled code analysis
- Hidden strings, credentials, logic findings
- Algorithm/key extraction
- Vulnerabilities in custom implementations

---

## Phase 9: Forensics & IR

| Area | Skill | Tools |
|------|-------|-------|
| Memory Forensics | `/forensic-memory` | Volatility3 — process, network, injected code analysis |
| Disk Forensics | `/forensic-disk` | Sleuth Kit, foremost, binwalk — file carving, recovery |
| Network Forensics | `/forensic-network` | Wireshark/tshark — PCAP analysis, traffic reconstruction |
| Steganography | `/ctf-forensics-stego` | LSB extraction, zsteg, steghide, bitplane analysis |
| Windows Forensics | `/ctf-forensics-windows` | EVTX logs, registry, MFT, USN journal |
| Linux Forensics | `/ctf-forensics-linux` | Log analysis, Docker layers, browser credentials |
| Reporting | `/forensic-report` | Chain-of-custody timeline, IOC list, remediation roadmap |

### Phase 9 Output

- Forensic timeline reconstruction
- Extracted artifacts (files, registry keys, network connections)
- IOC (Indicators of Compromise) list
- Chain-of-custody documentation

---

## Phase 10: Reporting & Documentation

| Jenis Output | Deskripsi |
|--------------|-----------|
| **Technical Report** | Detailed findings dengan PoC, CVSS scores, reproduction steps |
| **Executive Summary** | Business-level overview untuk stakeholders non-teknis |
| **Engagement Log** | Full log aktivitas yang bisa diaudit |
| **HackerOne Format** | Report yang diformat untuk submission ke HackerOne/Bugcrowd |
| **IR Report** | Incident response report dengan timeline dan remediation |

---

## Skill Playbook Coverage

Berikut daftar lengkap skill playbooks yang dapat dieksekusi Cerberus, dikelompokkan berdasarkan kategori:

### Vulnerability Classes (33 skills)
`vuln-sqli`, `vuln-xss`, `vuln-ssrf`, `vuln-cors`, `vuln-idor`, `vuln-rce`, `vuln-xxe`, `vuln-ssti`, `vuln-deserialization`, `vuln-file-upload`, `vuln-http-smuggling`, `vuln-race-conditions`, `vuln-business-logic`, `vuln-csrf`, `vuln-csrf-advanced`, `vuln-jwt`, `vuln-oauth`, `vuln-2fa-bypass`, `vuln-account-takeover`, `vuln-bfla`, `vuln-websocket`, `vuln-grpc`, `vuln-waf-bypass`, `vuln-subdomain-takeover`, `vuln-prototype-pollution`, `vuln-info-disclosure`, `vuln-sensitive-exposure`, `vuln-interactsh-oob`, `vuln-blind-xss`, `vuln-dom-xss`, `vuln-open-redirect`, `vuln-host-header`, `vuln-cache-deception`

### Reconnaissance (11 skills)
`recon-full`, `recon-subdomain`, `recon-internal`, `recon-dorking`, `recon-js-analysis`, `recon-js-hostname`, `recon-secrets`, `recon-shodan`, `recon-asn-whois`, `recon-favicon`, `recon-devtools`

### Post-Exploitation (7 skills)
`post-linux-privesc`, `post-windows-privesc`, `post-pivoting`, `post-lateral-movement`, `post-credential-dumping`, `post-bloodhound`, `post-container-escape`

### Protocol-Specific (11 skills)
`proto-smb`, `proto-kerberos`, `proto-graphql`, `proto-ssh`, `proto-ldap`, `proto-rdp`, `proto-smtp`, `proto-dns`, `proto-ftp`, `proto-snmp`, `proto-mssql`, `proto-vnc`

### Framework-Specific (10 skills)
`framework-django`, `framework-laravel`, `framework-rails`, `framework-spring`, `framework-express`, `framework-nextjs`, `framework-fastapi`, `framework-dotnet`, `framework-flask`, `framework-wordpress`

### Technology-Specific (12 skills)
`tech-cloud-security`, `tech-docker`, `tech-kubernetes`, `tech-redis`, `tech-mongodb`, `tech-jenkins`, `tech-firebase`, `tech-elasticsearch`, `tech-observability`, `tech-git-platforms`, `tech-tomcat`, `tech-supabase`

### Payload Collections (10 skills)
`payload-xss`, `payload-sqli`, `payload-ssrf`, `payload-ssti`, `payload-xxe`, `payload-lfi`, `payload-command-injection`, `payload-csv-injection`, `payload-ldap-injection`, `payload-http-param-pollution`

### Mobile (3 skills)
`mobile-android`, `mobile-ios`, `mobile-dynamic`

### CTF Challenges (50+ skills)
`ctf-recon`, `ctf-crypto`, `ctf-crypto-rsa`, `ctf-exploit`, `ctf-forensics`, `ctf-web-server-side`, `ctf-pwn-basics`, `ctf-pwn-rop`, `ctf-pwn-heap`, `ctf-pwn-kernel`, `ctf-reverse-patterns`, `ctf-wasm`, `ctf-android`, dan 40+ sub-spesialisasi

### Tools & Utilities (12 skills)
`tool-nmap`, `tool-nuclei`, `tool-sqlmap`, `tool-hashcat-john`, `tool-impacket`, `tool-metasploit`, `tool-semgrep`, `tool-advanced-fuzzing`, `tool-scripting`, `tool-source-audit`, `tool-caido`, `tool-dalfox`

---
*Dokumen ini adalah gambaran teknis publik. Untuk detail implementasi terkini, lihat source code di repository.*
