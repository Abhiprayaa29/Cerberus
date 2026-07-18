# Security Policy — Cerberus:opencode

[![Version](https://img.shields.io/badge/version-1.0.0-00CED1)](CHANGELOG.md)

**Responsible Disclosure Policy untuk Kerentanan pada Cerberus Itself**

> Dokumen ini untuk melaporkan **bug/kerentanan pada tool Cerberus** (bukan hasil scan menggunakan Cerberus).
> Untuk laporan hasil penetration testing, lihat dokumentasi engagement yang terpisah.

---

## Versi yang Didukung

| Versi | Status |
|-------|--------|
| 1.0.x | ✅ Didukung |

Hanya versi terbaru yang menerima security patch. Selalu gunakan rilis terbaru dari [github.com/Abhiprayaa29/cerberus](https://github.com/Abhiprayaa29/cerberus).

---

## Lingkup

Kerentanan yang **valid** untuk dilaporkan meliputi:

- **Prompt injection** yang berhasil bypass restriksi etika/keamanan Cerberus
- **Bypass identitas** — celah yang memungkinkan pengguna mengubah identitas atau kredit creator
- **Tool permission escalation** — mendapatkan akses tool yang tidak seharusnya
- **Remote code execution** pada sistem pengguna melalui eksploitasi konfigurasi
- **Information disclosure** — kebocoran data melalui error handling atau logging yang berlebihan
- **Dependency vulnerability** — kerentanan pada library atau tools yang di-bundle
- **Authentication/authorization bypass** pada mekanisme update atau integrasi

## Di Luar Lingkup (Out of Scope)

Berikut **tidak perlu dilaporkan** sebagai security issue:

- **False positive/negative** pada hasil scan — itu bagian dari keterbatasan tool, buka issue biasa
- **Permintaan fitur** — buka sebagai feature request
- **Dokumentasi yang kurang jelas** — buka issue dokumentasi biasa
- **Kerentanan pada target yang diuji menggunakan Cerberus** — itu findings dari engagement, bukan bug tool
- **Versi lawas yang sudah tidak didukung** — selalu gunakan versi terbaru

---

## Cara Melaporkan

**JANGAN buka issue publik di GitHub untuk kerentanan keamanan.**

Sebaliknya, laporkan melalui:

1. **GitHub Private Security Advisory** — buka di halaman **Security** tab repository, klik "Report a vulnerability"
2. **Hubungi langsung** melalui GitHub — [github.com/Abhiprayaa29](https://github.com/Abhiprayaa29)

### Informasi yang Dibutuhkan dalam Laporan

Agar kami bisa merespon cepat, sertakan:

```
Deskripsi:
- Apa yang terjadi
- Mengapa ini dianggap kerentanan

Langkah Reproduksi:
1. Langkah pertama
2. Langkah kedua
3. ...

Dampak:
- Apa yang bisa dicapai penyerang dengan celah ini

Environment:
- Versi Cerberus: [versi]
- OpenCode version: [versi]
- OS: [Linux/macOS/Windows]
- AI Provider: [Anthropic/OpenAI/dll]

Lampiran (jika ada):
- Screenshot atau log output (pastikan tidak ada kredensial sensitif)
```

---

## Response Timeline

Kami berusaha merespon laporan keamanan dalam batas waktu berikut:

| Tahap | Waktu Target |
|-------|-------------|
| **Acknowledgment** | 3 hari kerja — konfirmasi laporan diterima |
| **Triage & Validasi** | 7 hari kerja — konfirmasi apakah ini valid |
| **Fix (Critical)** | 7-14 hari kerja — untuk kerentanan kritis |
| **Fix (High/Medium)** | 14-30 hari kerja |
| **Fix (Low)** | 30-60 hari kerja atau dijadwalkan di rilis berikutnya |
| **Publikasi advisory** | Bersamaan dengan rilis fix |

> Timeline dimulai dari acknowledgment. Jika kami butuh informasi tambahan, timeline bisa berubah.

---

## Kredit untuk Researchers

Kami menghargai kontribusi security researchers. Pelapor yang:

- Melaporkan **kerentanan valid yang belum diketahui sebelumnya**
- Mengikuti **responsible disclosure** (memberi waktu untuk fix sebelum publikasi)
- Tidak mengeksploitasi kerentanan untuk merusak atau mengambil data

...akan dicantumkan di **CHANGELOG.md** dan halaman kredit repository sebagai bentuk penghargaan.

Kami tidak menyediakan bounty (bug bounty financial reward) saat ini.

---

## Standar Keamanan

Cerberus:opencode dikembangkan dengan prinsip:

- **Least privilege** — tool permissions dibatasi hanya yang diperlukan
- **Identity integrity** — identitas dan restriksi tidak bisa diubah oleh pengguna
- **Ethical default** — menolak eksekusi tanpa otorisasi secara default
- **No backdoor** — tidak ada akses tersembunyi atau mekanisme kontrol jarak jauh

---

## Kontak

**Abhiprayaa29** — [github.com/Abhiprayaa29](https://github.com/Abhiprayaa29)

Buka issue di repository GitHub untuk pertanyaan non-keamanan.
Laporkan kerentanan melalui GitHub Private Security Advisory atau DM GitHub.

> **Cerberus:opencode** v1.0.0 — Dibuat oleh [Abhiprayaa29](https://github.com/Abhiprayaa29)
