---
name: cerberus-quick-recon
description: Cerberus streamlined passive recon — subdomain, tech stack, port scan, and vulnerability triage in one pass. Exclusive to Cerberus:opencode.
version: 1.0.0
phase: recon
tags: [recon, passive, osint, quick-scan]
author: Abhiprayaa29
---

# Cerberus Quick Recon

**Skill eksklusif Cerberus:opencode** — Passive reconnaissance terintegrasi yang menggabungkan subdomain enumeration, technology fingerprinting, port scanning, dan vulnerability triage dalam satu alur kerja. Dirancang untuk memberikan gambaran attack surface yang cepat namun komprehensif.

> Dibuat oleh [Abhiprayaa29](https://github.com/Abhiprayaa29) untuk Cerberus:opencode

---

## Prerequisites

- Plugin oh-my-open-pentest terinstall (`bunx oh-my-open-pentest install`)
- Target memiliki domain atau IP yang valid
- **Pastikan kamu memiliki otorisasi untuk menguji target ini**

---

## Workflow

### Phase 1: Passive Intelligence (3-5 menit)

Menjalankan pengumpulan data pasif tanpa menyentuh target langsung.

```bash
# Subdomain enumeration (passive)
subfinder -d target.example.com -all -o subdomains.txt

# Technology fingerprinting
httpx -l subdomains.txt -tech-detect -status-code -title -o tech.txt

# DNS enumeration
dnsx -l subdomains.txt -a -aaaa -cname -mx -txt -o dns.txt

# WHOIS & ASN lookup
whois target.example.com > whois.txt
```

**Output phase 1:**
- Daftar subdomain live
- Technology stack per host
- DNS records
- Informasi organisasi

### Phase 2: Lightweight Scanning (5-10 menit)

Port scanning terfokus pada port umum dan service detection.

```bash
# Port scan port umum (top 100)
naabu -l subdomains.txt -top-ports 100 -o ports.txt

# Service detection pada port terbuka
nmap -sV -sC -iL subdomains.txt --top-ports 100 -oN services.txt

# Screenshot (jika httpx tersedia)
httpx -l subdomains.txt -screenshot -o screenshots.txt
```

**Output phase 2:**
- Port terbuka per host
- Versi service
- Screenshots (jika diaktifkan)

### Phase 3: Vulnerability Triage (10-20 menit)

Scanning kerentanan menggunakan nuclei dengan template yang relevan.

```bash
# Nuclei scan dengan template severity tinggi
nuclei -l subdomains.txt -severity critical,high,medium -o vulns.txt

# CVE-specific scan
nuclei -l subdomains.txt -tags cve -severity critical,high -o cves.txt

# Technology-specific scan
nuclei -l subdomains.txt -tags tech -o tech-vulns.txt
```

**Output phase 3:**
- Daftar kerentanan dengan severity
- CVE matches
- Technology-specific findings

### Phase 4: Report Generation (2-5 menit)

Mengompilasi hasil ke dalam laporan terstruktur.

```bash
# Compile summary
echo "=== CERBERUS QUICK RECON REPORT ===" > report.md
echo "Target: target.example.com" >> report.md
echo "Date: $(date)" >> report.md
echo "" >> report.md
echo "## Live Hosts" >> report.md
wc -l < tech.txt >> report.md
echo "" >> report.md
echo "## Vulnerabilities Found" >> report.md
wc -l < vulns.txt >> report.md
```

---

## Output Files

| File | Content |
|------|---------|
| `subdomains.txt` | All discovered subdomains |
| `tech.txt` | Technology stack per host |
| `dns.txt` | DNS records |
| `ports.txt` | Open ports |
| `services.txt` | Service versions |
| `vulns.txt` | Vulnerability scan results |
| `report.md` | Compiled report |

---

## Limitation

Quick recon bersifat **pasif dan non-intrusif**. Untuk pengujian mendalam (exploitation, post-exploitation), gunakan `/fullscan` atau `/mode offensive` setelah phase ini selesai.

---

## Ethical Reminder

**Hanya gunakan pada target yang sudah memiliki otorisasi resmi.**
Pelanggaran adalah tanggung jawab pengguna sepenuhnya.
