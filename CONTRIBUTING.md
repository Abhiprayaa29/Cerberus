# Contributing to Cerberus:opencode

[![Version](https://img.shields.io/badge/version-1.0.0-00CED1)](CHANGELOG.md)
[![License: SUL 1.0](https://img.shields.io/badge/license-SUL--1.0-blue)](../../LICENSE.md)

Terima kasih sudah tertarik berkontribusi! Kami menerima berbagai jenis kontribusi — dari laporan bug, dokumentasi, hingga skill playbook baru.

> **Dibuat oleh [Abhiprayaa29](https://github.com/Abhiprayaa29)**
> Berbasis [oh-my-open-pentest](https://github.com/zakirkun/oh-my-open-pentest) oleh zakirkun

Dengan berkontribusi ke proyek ini, kamu setuju untuk menjaga interaksi tetap sopan dan profesional sesuai [Kode Etik Kontributor](#kode-etik-kontributor) di bagian akhir dokumen ini.

---

## Daftar Isi

- [Jenis Kontribusi yang Diterima](#jenis-kontribusi-yang-diterima)
- [Setup Environment Development](#setup-environment-development)
- [Cara Submit Bug Report](#cara-submit-bug-report)
- [Cara Submit Skill Playbook Baru](#cara-submit-skill-playbook-baru)
- [Cara Submit Pull Request](#cara-submit-pull-request)
- [Code Style & Standar](#code-style--standar)
- [Hal yang Tidak Boleh Ada di Commit](#hal-yang-tidak-boleh-ada-di-commit)
- [Proses Review](#proses-review)

---

## Jenis Kontribusi yang Diterima

| Jenis | Deskripsi | Harus via |
|-------|-----------|-----------|
| **Bug Report** | Laporan masalah pada tool Cerberus | GitHub Issue (template bug) |
| **Feature Request** | Usulan fitur baru | GitHub Issue (template feature) |
| **Skill Playbook** | SKILL.md baru untuk teknik pentest | Pull Request ke `dev` |
| **Tool Integration** | Integrasi tool keamanan baru | Pull Request ke `dev` |
| **Dokumentasi** | Perbaikan atau tambahan dokumentasi | Pull Request ke `dev` |
| **Security Vulnerability** | Kerentanan pada tool itu sendiri | **JANGAN** buka issue — lihat [SECURITY.md](SECURITY.md) |

## Setup Environment Development

### Prasyarat

- **Bun** ≥ 1.0.0 — [bun.sh](https://bun.sh)
- **Git** ≥ 2.0
- **OpenCode** — [github.com/opencode-ai/opencode](https://github.com/opencode-ai/opencode)
- **API key** dari minimal satu AI provider

### Langkah Setup

```bash
# Clone repository
git clone https://github.com/Abhiprayaa29/cerberus.git
cd cerberus

# Install dependencies
bun install

# Build project
bun run build

# Verifikasi setup
bun run test
```

### Struktur Direktori

```
cerberus/
├── docs/                # Dokumentasi
│   ├── cerberus/        # Dokumentasi Cerberus
│   └── guide/           # Panduan pengguna
├── src/                 # Source code (plugin)
├── .agents/skills/      # Skill playbooks (SKILL.md)
├── .github/             # GitHub templates
├── tools-catalog.json   # Tool registrasi
└── package.json
```

---

## Cara Submit Bug Report

Gunakan template [Bug Report](.github/ISSUE_TEMPLATE/bug_report.md) yang sudah disediakan.

### Checklist Sebelum Submit

- [ ] Cari di issue tracker — mungkin sudah ada yang melaporkan
- [ ] Gunakan versi terbaru Cerberus
- [ ] Sertakan **langkah reproduksi yang jelas**
- [ ] Sertakan **environment info** (OS, versi tools)

### Cara Membuka Issue

1. Buka [github.com/Abhiprayaa29/cerberus/issues](https://github.com/Abhiprayaa29/cerberus/issues)
2. Klik "New Issue"
3. Pilih template "Bug Report"
4. Isi lengkap

---

## Cara Submit Skill Playbook Baru

Skill playbook adalah file SKILL.md yang mendefinisikan teknik pengujian tertentu.

### Format SKILL.md

```markdown
---
name: <nama-skill>
description: <deskripsi singkat>
version: 1.0.0
phase: <recon|enum|exploit|post-exploit|report>
tools: [tool1, tool2, ...]
tags: [tag1, tag2]
---

# <Nama Skill>

## Overview

Penjelasan tentang teknik ini.

## Prerequisites

Yang dibutuhkan sebelum menjalankan skill ini.

## Steps

1. Langkah 1
2. Langkah 2
3. ...

## Expected Output

Apa yang dihasilkan.
```

### Persyaratan Skill Playbook

1. **Unik** — tidak duplikasi dengan skill yang sudah ada
2. **Reproducible** — langkah-langkah jelas dan bisa diikuti
3. **Aman** — tidak mendorong pengujian tanpa otorisasi
4. **Terstruktur** — mengikuti format YAML frontmatter + markdown
5. **Tool-aware** — menyebutkan tools yang digunakan

### Cara Submit

1. Fork repository
2. Buat file `.agents/skills/<nama-skill>/SKILL.md`
3. Update `tools-catalog.json` jika menambahkan tool baru
4. Submit Pull Request

---

## Cara Submit Pull Request

### Branch Strategy

- Branch default: **`dev`**
- Jangan pernah push langsung ke `main`
- Branch fitur: `fitur/<nama-fitur>` atau `fix/<nama-fix>`

### Langkah

```bash
# 1. Fork repository di GitHub

# 2. Clone fork lokal
git clone https://github.com/<username>/cerberus.git
cd cerberus

# 3. Tambahkan upstream
git remote add upstream https://github.com/Abhiprayaa29/cerberus.git

# 4. Buat branch dari dev
git checkout dev
git pull upstream dev
git checkout -b fitur/<nama-fitur>

# 5. Implementasi perubahan
# ...coding...

# 6. Jalankan test
bun run test

# 7. Commit
git add <file-terkait>
git commit -m "feat: deskripsi singkat perubahan"

# 8. Push ke fork
git push origin fitur/<nama-fitur>

# 9. Buat Pull Request ke branch dev
# Buka https://github.com/Abhiprayaa29/cerberus
# Klik "New Pull Request" → base: dev ← compare: fitur/<nama-fitur>
```

### PR Checklist

- [ ] Branch dari `dev`, bukan `main`
- [ ] Tidak ada konflik dengan branch target
- [ ] Semua test lulus
- [ ] Tidak ada secrets atau credentials di commit
- [ ] Tidak ada path lokal atau konfigurasi spesifik mesin
- [ ] Dokumentasi diupdate jika perlu
- [ ] CHANGELOG.md diupdate jika perlu

---

## Code Style & Standar

### TypeScript

- Gunakan **strict mode**
- **No `any`** — hindari `as any`, `@ts-ignore`, `@ts-expect-error`
- Nama file: **kebab-case** (contoh: `cerberus-agent-factory.ts`)
- Import: relative dalam module, barrel export antar module
- 200 LOC soft limit per file

### Testing

- Gunakan **Bun test** (`bun:test`)
- Format: **given/when/then**
- Test co-located dengan source (`*.test.ts`)

### Config

- Format: **JSONC** (json dengan comments + trailing commas)
- Validasi: **Zod** schemas
- Snake_case untuk keys

### Dokumentasi

- Bahasa: **Indonesia** atau **Inggris**, konsisten dalam satu file
- Format: **Markdown**
- Link: gunakan relative path dalam repo

---

## Hal yang Tidak Boleh Ada di Commit

| Item | Alasan |
|------|--------|
| **API keys / tokens** | Keamanan — bisa dipakai orang lain |
| **Path filesystem lokal** (`/home/...`, `C:\Users\...`) | Privacy — mengekspos struktur lokal contributor |
| **Credentials** (password, secret) | Keamanan |
| **Domain/target nyata** | Privacy — bisa jadi target yang pernah diuji tanpa izin publikasi |
| **Konfigurasi provider spesifik** | Privacy — API endpoint, model routing pribadi |
| **Binary files** (kecuali diperlukan) | Ukuran repo membengkak |
| **node_modules/** | Harus di `.gitignore` |
| **File log** | Tidak relevan dengan source code |

> Jika tidak sengaja commit sesuatu yang sensitif, **jangan push dulu**. Hubungi maintainer.
> Jika sudah ter-push, segera rotate credentials yang bocor dan hubungi maintainer untuk purge dari git history.

---

## Proses Review

### Siapa yang Review

- **Abhiprayaa29** sebagai maintainer utama
- Contributor lain yang relevan (untuk area spesifik)

### Timeline Review

| Ukuran PR | Target Review |
|-----------|---------------|
| Kecil (< 10 files) | 3-5 hari kerja |
| Sedang (10-30 files) | 5-10 hari kerja |
| Besar (30+ files) | 10-20 hari kerja |

### Kriteria Review

1. **Functional correctness** — apakah kode bekerja?
2. **Security** — apakah ada celah keamanan baru?
3. **Style & consistency** — apakah sesuai code style?
4. **Test coverage** — apakah ada test untuk perubahan?
5. **Documentation** — apakah dokumentasi diupdate?

### Apa yang terjadi setelah review?

- **Approved** → maintainer merge ke `dev`
- **Changes requested** → perbaiki sesuai komentar, push ulang
- **Closed** — jika tidak sesuai scope project

---

## Kode Etik Kontributor

- Bersikap sopan dan profesional dalam diskusi
- Kritik membangun, fokus pada kode bukan orang
- Hargai perbedaan pendapat
- Kontribusi bersifat sukarela — tidak ada jaminan diterima

---

> **Cerberus:opencode** v1.0.0 — Dibuat oleh [Abhiprayaa29](https://github.com/Abhiprayaa29)
> Berbasis [oh-my-open-pentest](https://github.com/zakirkun/oh-my-open-pentest) oleh zakirkun
