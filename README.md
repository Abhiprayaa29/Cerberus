# Cerberus — AI Orchestrator for Penetration Testing Workflow

**Plan. Delegate. Verify. Ship.**

[![Version](https://img.shields.io/badge/version-1.0.0-00CED1)](CHANGELOG.md)
[![License: SUL 1.0](https://img.shields.io/badge/license-SUL--1.0-blue)](../../LICENSE.md)
[![Runtime](https://img.shields.io/badge/runtime-Bun%20%E2%89%A5%201.0.0-black)](https://bun.sh)
[![Platform](https://img.shields.io/badge/platform-OpenCode-00CED1)](https://github.com/opencode-ai/opencode)

Cerberus is the main orchestration agent inside [oh-my-open-pentest](https://github.com/zakirkun/oh-my-open-pentest) — an AI-powered penetration testing framework that turns a single AI agent into a coordinated security testing team. Cerberus plans the engagement, delegates tasks to specialized sub-agents, verifies every finding, and drives the full pentest lifecycle from recon to report.

> No babysitting. Define the scope. Cerberus does the rest.

> ⚠️ **Authorized use only.** Cerberus is a security testing tool. Use it only on systems you own or have explicit written authorization to test. See [Disclaimer & Etika Penggunaan](#disclaimer--etika-penggunaan).

---

## Daftar Isi

- [Apa Itu Cerberus](#apa-itu-cerberus)
- [Fitur Utama](#fitur-utama)
- [Arsitektur](#arsitektur)
- [Instalasi & Setup](#instalasi--setup)
- [Contoh Penggunaan](#contoh-penggunaan)
- [Keterbatasan](#keterbatasan)
- [Disclaimer & Etika Penggunaan](#disclaimer--etika-penggunaan)
- [Lisensi](#lisensi)
- [Kredit & Atribusi](#kredit--atribusi)

**Dokumentasi terkait:** [CAPABILITIES.md](CAPABILITIES.md) · [INSTALL.md](INSTALL.md) · [CONTRIBUTING.md](CONTRIBUTING.md) · [SECURITY.md](SECURITY.md) · [CHANGELOG.md](CHANGELOG.md)

---

## Apa Itu Cerberus

Cerberus adalah **multi-agent orchestrator** yang dirancang untuk menjalankan penetration testing secara otonom. Berbeda dengan pendekatan single-agent konvensional yang mencoba melakukan semuanya sendiri, Cerberus mendelegasikan tugas ke sub-agent spesialis:

| Sub-Agent | Peran |
|-----------|-------|
| **Cipher** | High-IQ consultant untuk arsitektur, keputusan teknis kompleks, dan analisis kerentanan |
| **Scout** | Fast contextual grep untuk pencarian di codebase internal |
| **Intel** | Pencarian dokumentasi eksternal, OSS code, dan referensi library |
| **Vanguard** | Pre-planning consultant — analisis gap dan identifikasi ambiguitas |
| **Sentinel** | Reviewer — validasi rencana terhadap kriteria clarity, verifiability, completeness |
| **Talos** | Strategic planner — interview-based planning untuk engagement kompleks |
| **Cerberus-Junior** | Category-based task executor untuk delegasi tugas spesifik domain |

Cerberus berjalan di atas **OpenCode** sebagai plugin AI agent harness, dengan dukungan juga untuk **Codex CLI** melalui Light Edition (`omo-codex`).

Filosofi utama: **human intervention during an engagement is a failure signal.** Jika sistem dirancang dengan benar, agen harus menyelesaikan siklus engagement — dari recon sampai report — tanpa perlu diawasi.

---

## Fitur Utama

### Orchestrasi Multi-Agent

Cerberus tidak mengerjakan semuanya sendiri. Ia membaca task, menilai kompleksitasnya, lalu mendelegasikan ke sub-agent yang tepat — mirip tech lead yang membagi pekerjaan ke anggota tim spesialis.

- **Routing berbasis intent**: Sebelum bertindak, Cerberus mengklasifikasikan apa yang sebenarnya diminta user — research, implementation, investigation, atau fix.
- **Parallel background agents**: Beberapa sub-agent bisa berjalan paralel. Research pattern dilakukan bersamaan dengan implementasi dan verifikasi.
- **Category-based task routing**: Task dirutekan ke category (contoh: `visual-engineering`, `ultrabrain`, `deep`, `quick`) yang secara otomatis memetakan ke model AI optimal — tanpa perlu user mengkonfigurasi model satu per satu.

### Coverage Fase Pentest

Cerberus mencakup seluruh siklus penetration testing melalui skill playbooks dan tool integrations:

| Fase | Contoh Aktivitas |
|------|------------------|
| **Reconnaissance** | Subdomain enumeration, port scanning, technology fingerprinting, OSINT pasif |
| **Enumeration** | Vulnerability scanning (nuclei), directory brute-forcing, CMS/tech detection |
| **Web Exploitation** | SQL injection, XSS, SSRF, SSTI, command injection, file upload bypass |
| **Credential Attacks** | Password spraying, hash cracking, kerberoasting, AS-REP roasting |
| **Active Directory** | NetExec enumeration, BloodHound analysis, Impacket-based pivoting |
| **Post-Exploitation** | Linux/Windows privilege escalation, lateral movement, credential dumping |
| **Pivoting** | SSH tunneling, SOCKS proxy, chisel, ligolo-ng |
| **Reporting** | CVSS-scored findings dengan PoC, reproduction steps, remediation guidance |

### 109+ Security Tools

Cerberus mengakses lebih dari 109 tools keamanan yang terintegrasi melalui `tools-catalog.json`. Tools yang belum terinstall akan diunduh otomatis sebelum digunakan pertama kali. Beberapa di antaranya:

- **Recon**: subfinder, amass, httpx, naabu, nmap, theHarvester, massdns
- **Enumeration**: nuclei, ffuf, gobuster, feroxbuster, nikto, whatweb, katana
- **Exploitation**: sqlmap, commix, dalfox, xsstrike, metasploit, netexec
- **Credential**: hydra, hashcat, john, certipy, kerbrute
- **AD**: impacket, bloodhound, responder, evil-winrm
- **Post-Exploit**: peass-ng, chisel, ligolo-ng, pwntools
- **Forensics**: volatility3, autopsy, binwalk, wireshark, tcpdump
- **Reverse Engineering**: ghidra, radare2, cutter, gdb, pwndbg, angr
- **Mobile**: apktool, jadx, frida, objection, mobsf

### 250+ Skill Playbooks

Setiap teknik pengujian memiliki SKILL.md — dokumen terstruktur yang bisa dieksekusi agen dan dibaca manusia. Mulai dari vulnerability classes (SQLi, XSS, SSRF, dll), protocol-specific testing (SMB, Kerberos, LDAP), framework-specific (Spring, Laravel, Django), hingga payload collections.

### Intelligence Data Layer

Cerberus memuat data referensi terstruktur saat runtime untuk pengambilan keputusan yang lebih cerdas:
- Attack chains — 40+ jalur eksploitasi multi-tahap
- WAF signatures — fingerprinting dan bypass techniques
- Tech correlations — teknologi → kerentanan yang diketahui
- CVE correlations — mapping CVE ke pola serangan
- Port correlations — port → service → attack vector

### Engagement Modes

10 mode engagement yang bisa dipilih, masing-masing dengan optimasi tool priority, skill chain, dan output format berbeda:

| Mode | Use Case |
|------|----------|
| **auto** | Target tidak dikenal, adaptive routing |
| **bug-bounty** | HackerOne/Bugcrowd/Intigriti — prioritaskan valid findings |
| **red-team** | Stealth ops, persistence, AD attack chains |
| **ctf** | HackTheBox, TryHackMe — flag hunting |
| **blue-team** | Detection, incident response, defensive audit |
| **offensive** | Aggressive exploitation dengan full PoC chains |
| **forensic** | Evidence preservation, disk/memory analysis |
| **reverse-engineering** | Binary, firmware, malware analysis |
| **mobile-pentest** | Android/iOS app assessment |

### Team Mode (Opt-In)

Untuk engagement skala besar, Cerberus bisa mengaktifkan Team Mode — koordinasi paralel multi-agent dengan mailbox system, shared task list, dan tmux visualization. Ideal untuk audit codebase besar atau target kompleks yang butuh coverage luas.

---

## Arsitektur

```
User Request
    │
    ▼
┌─────────────────────────────────────────┐
│            IntentGate                    │
│  Klasifikasi intent: research /          │
│  implement / investigate / fix / team    │
└─────────────────┬───────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────┐
│              Cerberus                    │
│   Orchestrator — plan + delegate +       │
│   verify + enforce discipline            │
└──┬───────┬───────┬───────┬──────┬───────┘
   │       │       │       │      │
   ▼       ▼       ▼       ▼      ▼
┌─────┐ ┌─────┐ ┌─────┐ ┌────┐ ┌────────┐
│Scout│ │Cipher│ │Intel│ │Talos│ │Vanguard│
│grep │ │arsitek│ │dokum│ │plan│ │analisis│
│kode │ │konsul │ │cari  │ │stratej│ │gap    │
└─────┘ └─────┘ └─────┘ └────┘ └────────┘
   │       │       │       │      │
   ▼       ▼       ▼       ▼      ▼
┌─────────────────────────────────────────┐
│          Tool Execution Layer            │
│  nmap │ nuclei │ sqlmap │ netexec │ ...  │
└─────────────────────────────────────────┘
```

### Alur Kerja Umum

1. **User memberikan target/scope** — URL, domain, IP range, atau deskripsi task
2. **IntentGate mengklasifikasikan** — apa yang sebenarnya diminta
3. **Cerberus menyusun rencana** — todo list dengan langkah-langkah konkret
4. **Delegasi ke sub-agent** — sub-agent spesifik untuk tugas spesifik, berjalan paralel bila memungkinkan
5. **Tool execution** — sub-agent menjalankan tools yang relevan
6. **Verifikasi** — setiap finding dikonfirmasi sebelum masuk report
7. **Report** — hasil dikompilasi dengan CVSS scoring, PoC, dan remediation

### Multi-Model Routing

Cerberus tidak terikat pada satu model AI atau satu provider. Sistem ini menggunakan routing berdasarkan task type:

- **Task berat (arsitektur, logic complex)** → dirutekan ke model dengan reasoning capability tinggi
- **Task cepat (grep, search sederhana)** → dirutekan ke model cepat dan murah
- **Task visual/frontend** → dirutekan ke model dengan kemampuan visual unggul
- **Task penulisan/dokumentasi** → dirutekan ke model dengan capability prosa baik

Setiap agent memiliki fallback chain — jika provider utama down, sistem otomatis beralih ke provider berikutnya tanpa intervensi manual.

---

## Instalasi & Setup

### Prasyarat

- **Bun** (runtime) — [bun.sh](https://bun.sh)
- **OpenCode** (AI agent harness) — [github.com/opencode-ai/opencode](https://github.com/opencode-ai/opencode)
- **API key** dari minimal satu AI provider (Anthropic, OpenAI, Google, atau lainnya)

> **Catatan**: Beberapa tools keamanan mungkin memerlukan instalasi tambahan (nmap, sqlmap, dll). Cerberus akan menginstall tools yang diperlukan secara otomatis saat pertama kali digunakan.

### Instalasi Cepat

```bash
# Install oh-my-open-pentest via Bun
bunx oh-my-open-pentest install
```

Wizard instalasi akan memandu pemilihan engagement mode, AI provider, dan assignment model, lalu memverifikasi instalasi.

### Verifikasi

```bash
bunx oh-my-open-pentest doctor
```

Perintah `doctor` akan mengecek kesehatan sistem di 4 kategori: System, Config, Tools, Models.

### Aktivasi Team Mode (Opsional)

Untuk engagement paralel dengan banyak agent, aktifkan Team Mode di konfigurasi:

```jsonc
// .opencode/oh-my-open-pentest.jsonc
{
  "team_mode": {
    "enabled": true,
    "max_parallel_members": 4,
    "tmux_visualization": true
  }
}
```

Restart OpenCode setelah mengubah konfigurasi.

---

## Contoh Penggunaan

### 1. Full Engagement pada Target Web

```
fullscan https://target.example.com
```

Cerberus akan:
1. Menentukan engagement mode (auto-detect dari target)
2. Menjalankan passive reconnaissance (subdomain, WHOIS, technology detection)
3. Melakukan active enumeration (port scanning, directory brute-forcing)
4. Menjalankan vulnerability scanning (nuclei, nikto)
5. Melakukan exploitation pada temuan yang terverifikasi
6. Menghasilkan report dengan CVSS scores dan remediation

### 2. Mode Bug Bounty

```
/mode bug-bounty
fullscan https://target.example.com
```

Berbeda dengan mode default, mode bug bounty mengoptimalkan:
- Prioritas finding yang valid dan reproducible (minim false positive)
- Format report sesuai standar HackerOne/Bugcrowd
- Scope enforcement ketat — out-of-scope assets otomatis ditolak
- DoS protection aktif — tidak ada pengujian yang berpotensi merusak

### 3. CTF Challenge

```
/mode ctf
fullscan https://ctf-platform.example.com/challenges/123
```

Mode CTF mengoptimalkan:
- Prioritaskan exploitation langsung (tanpa recon panjang)
- Flag hunting dan submission
- Tool priority: exploitation → enumeration → recon

### 4. Red Team Operation

```
/mode red-team
fullscan internal.target.example.com/24
```

Mode Red Team mengaktifkan:
- Stealth scanning (lambat, hindari deteksi)
- Active Directory attack chains
- Persistence mechanisms
- Lateral movement via SMB/WinRM/SSH

---

## Keterbatasan

Cerberus adalah alat yang powerful, tetapi bukan magic bullet. Berikut batasan yang perlu dipahami:

### Bukan 0-Day Discovery Engine

Cerberus bekerja berdasarkan tools dan teknik yang sudah dikenal. Ia tidak bisa menemukan kerentangan 0-day atau melakukan vulnerability research yang membutuhkan kreativitas tingkat manusia. Ia sangat baik untuk **known vulnerability patterns** dan **common misconfigurations**.

### False Positive

Meskipun setiap finding melalui proses verifikasi, **false positive masih mungkin terjadi**. Setiap temuan harus ditinjau ulang oleh security professional sebelum dimasukkan ke laporan final — terutama untuk program bug bounty yang serius.

### Ketergantungan pada Tools Eksternal

Cerberus mengandalkan tools keamanan eksternal yang diinstall di sistem. Jika tools tersebut:

- Tidak kompatibel dengan OS yang digunakan
- Versi usang dengan bug
- Tidak memiliki akses ke resource yang diperlukan (wordlists, database)

...maka hasil pengujian bisa terpengaruh.

### Lingkungan Jaringan

Untuk pengujian internal/Active Directory, Cerberus membutuhkan akses jaringan yang sesuai. Jika target berada di network terisolasi, diperlukan VPN atau proxy yang dikonfigurasi terpisah.

### Report Quality

Meskipun Cerberus menghasilkan report terstruktur, kualitas tulisan dan konteks bisnis dari temuan mungkin masih perlu penyesuaian manual — terutama untuk program dengan requirement reporting yang sangat spesifik.

### Bukan Pengganti Security Professional

Cerberus adalah **force multiplier**, bukan pengganti security engineer. Pemahaman tentang keamanan siber, attack vectors, dan mitigasi tetap diperlukan untuk menginterpretasi hasil dan mengambil keputusan.

---

## Disclaimer & Etika Penggunaan

**⚠️ PENTING: BACA INI SEBELUM MENGGUNAKAN**

Cerberus dan oh-my-open-pentest adalah **alat pengujian keamanan siber** yang dirancang untuk digunakan **HANYA** pada sistem yang sudah memiliki otorisasi resmi.

### Penggunaan yang Diizinkan

- **Penetration Testing Resmi** — Dilakukan berdasarkan kontrak atau scope of work yang sah
- **Bug Bounty Program** — Dalam scope program yang sudah ditentukan (HackerOne, Bugcrowd, Intigriti, dll)
- **Lab Pribadi** — Lingkungan testing milik sendiri (HackTheBox, TryHackMe, VulnHub, lab internal)
- **Security Assessment** — Atas izin tertulis dari pemilik sistem

### Penggunaan yang DILARANG

- Menguji sistem tanpa izin tertulis dari pemilik
- Mengeksploitasi kerentangan untuk tujuan merusak, mencuri data, atau extortion
- Menggunakan di luar scope yang sudah ditentukan
- Melakukan denial of service (DoS) tanpa otorisasi eksplisit
- Mengeksfiltrasi, memodifikasi, atau menghancurkan data target

### Tanggung Jawab

**PENYALAHGUNAAN ALAT INI ADALAH TANGGUNG JAWAB PENGGUNA SEPENUHNYA.** Pengembang dan kontributor proyek ini TIDAK bertanggung jawab atas:

- Kerusakan yang disebabkan oleh penggunaan tanpa otorisasi
- Pelanggaran hukum yang dilakukan menggunakan alat ini
- Konsekuensi hukum dari pengujian pada sistem tanpa izin

**Always get proper authorization before testing.**

---

## Lisensi

Proyek ini didistribusikan di bawah **Sustainable Use License (SUL 1.0)** — lihat file [LICENSE.md](../../LICENSE.md) untuk detail lengkap.

Secara singkat:
- Anda boleh menggunakan, memodifikasi, dan mendistribusikan untuk penggunaan non-komersial atau internal bisnis
- Distribusi harus gratis untuk tujuan non-komersial
- Tidak boleh ada perubahan atau penghapusan lisensi, copyright, atau notice dari licensor
- Setiap modifikasi pada software harus menyertakan pemberitahuan bahwa software telah dimodifikasi

### Kontribusi

Kontribusi sangat diterima! Cara berkontribusi:

1. Fork repository ini
2. Buat branch dari `dev`: `git checkout -b fitur-anda`
3. Commit perubahan
4. Push ke branch: `git push origin fitur-anda`
5. Buat Pull Request ke branch `dev`

Mohon pastikan:
- Semua test lulus sebelum submit PR
- Tidak ada secrets atau credentials di commit
- Perubahan sesuai dengan code style yang ada

---

## Kredit & Atribusi

### Pengembang

Cerberus dikustomisasi dan diadaptasi oleh:

**Abhiprayaa29** — [github.com/Abhiprayaa29](https://github.com/Abhiprayaa29)

### Proyek Induk

Cerberus adalah komponen inti dari **oh-my-open-pentest**, dibuat oleh:

**zakirkun** — [github.com/zakirkun/oh-my-open-pentest](https://github.com/zakirkun/oh-my-open-pentest)

Proyek ini merupakan fork dari [code-yeongyu/oh-my-openagent](https://github.com/code-yeongyu/oh-my-openagent).

### Lisensi Proyek Induk

Proyek oh-my-open-pentest didistribusikan di bawah **Sustainable Use License (SUL 1.0)**. Atribusi yang tertulis di atas sesuai dengan ketentuan lisensi tersebut, yang mewajibkan:

- Pemberitahuan tentang licensor (zakirkun) tidak boleh dihapus atau diubah
- Setiap modifikasi harus menyertakan pemberitahuan bahwa software telah dimodifikasi
- Lisensi dan copyright notices harus dipertahankan

### Teknologi Pihak Ketiga

- **OpenCode** — [github.com/opencode-ai/opencode](https://github.com/opencode-ai/opencode) — AI agent harness
- **Intelligence data** — Bersumber dari [airecon](https://github.com/pikpikcu/airecon)
- Seluruh third-party components yang terintegrasi (tools keamanan, library) dilisensikan di bawah lisensi asli masing-masing pemilik komponen

---

> **Cerberus** — Named after the Greek mythological hound who guards the underworld. The name fits: this agent guards the quality of your security testing, ensures nothing slips through, and persists until the job is done.
