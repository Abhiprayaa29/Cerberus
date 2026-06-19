> [!TIP]
> Be with us!
>
> | [<img alt="Discord link" src="https://img.shields.io/discord/1452487457085063218?color=5865F2&label=discord&labelColor=black&logo=discord&logoColor=white&style=flat-square" width="156px" />](https://discord.gg/PUwSMR9XNk) | Join our [Discord community](https://discord.gg/PUwSMR9XNk) to connect with contributors and fellow `oh-my-open-pentest` users. |
> | :-----| :----- |
> | [<img alt="X link" src="https://img.shields.io/badge/Follow-%40justsisyphus-00CED1?style=flat-square&logo=x&labelColor=black" width="156px" />](https://x.com/justsisyphus) | Updates posted by [@justsisyphus](https://x.com/justsisyphus). |
> | [<img alt="GitHub Follow" src="https://img.shields.io/github/followers/code-yeongyu?style=flat-square&logo=github&labelColor=black&color=24292f" width="156px" />](https://github.com/code-yeongyu) | Follow [@code-yeongyu](https://github.com/code-yeongyu) on GitHub for more projects. |

<!-- <CENTERED SECTION FOR GITHUB DISPLAY> -->

<div align="center">

<a href="https://github.com/code-yeongyu/oh-my-open-pentest#oh-my-open-pentest"><img src="./.github/assets/omop-logo.png" alt="OmOP" width="200" /></a>

[![Oh My Open Pentest](./.github/assets/hero.jpg)](https://github.com/code-yeongyu/oh-my-open-pentest#oh-my-open-pentest)

</div>

<!-- </CENTERED SECTION FOR GITHUB DISPLAY> -->

<div align="center">

[![GitHub Release](https://img.shields.io/github/v/release/code-yeongyu/oh-my-open-pentest?color=369eff&labelColor=black&logo=github&style=flat-square)](https://github.com/code-yeongyu/oh-my-open-pentest/releases)
[![GitHub Contributors](https://img.shields.io/github/contributors/code-yeongyu/oh-my-open-pentest?color=c4f042&labelColor=black&style=flat-square)](https://github.com/code-yeongyu/oh-my-open-pentest/graphs/contributors)
[![GitHub Stars](https://img.shields.io/github/stars/code-yeongyu/oh-my-open-pentest?color=ffcb47&labelColor=black&style=flat-square)](https://github.com/code-yeongyu/oh-my-open-pentest/stargazers)
[![GitHub Issues](https://img.shields.io/github/issues/code-yeongyu/oh-my-open-pentest?color=ff80eb&labelColor=black&style=flat-square)](https://github.com/code-yeongyu/oh-my-open-pentest/issues)
[![License](https://img.shields.io/badge/license-SUL--1.0-white?labelColor=black&style=flat-square)](https://github.com/code-yeongyu/oh-my-open-pentest/blob/dev/LICENSE.md)
[![Docs](https://img.shields.io/badge/docs-omo.vibetip.help-369eff?labelColor=black&logo=readthedocs&logoColor=white&style=flat-square)](https://omo.vibetip.help/docs)

[English](README.md) | [한국어](README.ko.md) | [日本語](README.ja.md) | [简体中文](README.zh-cn.md)

</div>

---

# Oh My Open Pentest

**Autonomous penetration testing. Define scope. Type `fullscan`. Walk away.**

oh-my-open-pentest is an agentic automation platform for offensive security. It runs a complete engagement — recon, enumeration, exploitation, and report — without human babysitting. You define the scope and rules of engagement. The agent finds what's inside them.

> Human intervention during an engagement is a failure signal. If the system is designed correctly, the agent completes the cycle — recon through report — without requiring babysitting.
>
> — [Manifesto](docs/manifesto.md)

---

## The Core Loop

```
Scope + RoE → RECON → ENUM → EXPLOIT → VERIFY → REPORT
      ↑                                              ↓
      └──────────── Scope enforced at every step ───┘
```

Every phase is autonomous. Scope boundaries are parsed, validated, and enforced by the agent — not by you. Every finding is verified before it hits the report. The output is submission-ready.

---

## Quickstart

```bash
bunx oh-my-open-pentest install
```

The installer walks through: mode selection, provider authentication, agent configuration.

Then:

```
fullscan
```

One word. Every agent activates. Doesn't stop until the engagement is done.

---

## Engagement Modes

Seven modes, each tuned for a different context. The agent auto-detects the right mode from target indicators, or you pick one explicitly.

| Mode | When to use | Tool priority | Report format |
| :--- | :--- | :--- | :--- |
| **Auto** | Unknown target, let the agent decide | Adaptive | Standard |
| **CTF** | Capture The Flag challenges | Exploit → Enum → Recon | Flag submission |
| **Bug Bounty** | HackerOne, Bugcrowd, Intigriti, YesWeHack | Recon → Enum → Exploit | HackerOne format |
| **Red Team** | Stealth operations, persistence, lateral movement | Recon → Exploit → Enum | Executive summary |
| **Blue Team** | Detection, incident response, forensics | Enum → Recon → Report | IR report |
| **Offensive** | Aggressive exploitation, PoC chains | Exploit → Enum → Recon | Technical |
| **Grey Hat** | Balanced offensive/defensive | Balanced | Technical |
| **Forensic** | Digital forensics, evidence preservation, IR | Forensics → Report | Forensic (chain-of-custody) |
| **Reverse Engineering** | Binary analysis, malware RE, CTF rev challenges | RE → Exploit → Utility | Technical RE |
| **Mobile Pentest** | Android/iOS app security assessment | Mobile → Enum → Exploit | Mobile (OWASP Top 10) |

Switch mode with a slash command:

```
/mode bug-bounty
/mode red-team
/mode ctf
```

Or let the agent auto-detect:

```
fullscan https://target.example.com
```

---

## Agents

A coordinated team. Each agent owns its phase.

| Agent | Role | What it does |
| :--- | :--- | :--- |
| **Cerberus** | Orchestrator | Plans the engagement, delegates phases, drives to completion |
| **Hydra** | Recon | Parallel subdomain discovery, port scanning, HTTP probing, tech detection |
| **Scylla** | Exploitation | Multi-vector exploitation, payload chaining, PoC construction |
| **Argus** | Monitor | Watches scope boundaries and engagement state across the entire run |
| **Talos** | Scope Guard | Parses RoE, validates every target before active testing, logs scope decisions |
| **Hermes** | Reporter | Generates submission-ready reports with CVSS scoring and working PoCs |

For large engagements, enable **Team Mode** and run all agents in parallel — Hydra recons while Scylla exploits earlier findings.

---

## Tool Coverage

60+ security tools, ready to use. Installed automatically if missing.

**Recon**
`subfinder` · `amass` · `assetfinder` · `httpx` · `naabu` · `massdns` · `nmap`

**Enumeration**
`nuclei` · `ffuf` · `gobuster` · `feroxbuster` · `dirsearch` · `whatweb` · `wafw00f` · `nikto` · `burpsuite` · `owasp-zap`

**Exploitation**
`sqlmap` · `commix` · `hydra` · `hashcat` · `john` · `pwntools` · `metasploit` · `bloodhound` · `crackmapexec` · `responder` · `impacket`

**Forensics / IR**
`volatility3` · `autopsy` · `binwalk` · `foremost` · `bulk_extractor` · `exiftool` · `tcpdump` · `tshark` · `wireshark` · `yara`

**Reverse Engineering**
`ghidra` · `radare2` · `cutter` · `gdb` · `pwndbg` · `ltrace` · `strace` · `angr`

**Mobile**
`apktool` · `jadx` · `frida` · `objection` · `mobsf` · `adb`

**Utility**
`curl` · `jq` · `anew` · `notify` · `grep`

Full catalog: [`tools-catalog.json`](tools-catalog.json) — each tool includes install commands (Linux, macOS, Windows), flag definitions, and availability checks. Tools are verified before use. Missing tools are installed automatically.

---

## Skill Chains

Skills are the execution playbooks. Each mode has a predetermined skill chain. The agent loads and follows them automatically.

| Phase | Skill | What runs |
| :--- | :--- | :--- |
| Mode selection | `pentest-mode` | Detects or applies mode config |
| Recon | `pentest-recon` / `red-recon` / `ctf-recon` | subfinder, amass, httpx, naabu |
| Enumeration | `pentest-enum` | nuclei, ffuf, gobuster, whatweb, wafw00f |
| Exploitation | `pentest-exploit` / `red-exploit` / `ctf-exploit` | sqlmap, commix, hydra, metasploit |
| Post-exploitation | `red-lateral` / `red-persistence` | bloodhound, crackmapexec, impacket |
| Detection / IR | `blue-detect` / `blue-ir` / `blue-forensics` | volatility, autopsy, yara |
| Memory forensics | `forensic-memory` | volatility3 (processes, network, malfind, hashdump) |
| Disk forensics | `forensic-disk` | autopsy, foremost, bulk_extractor, binwalk, exiftool |
| Network forensics | `forensic-network` | tshark, tcpdump (C2 detection, credential extraction) |
| Static RE | `re-static` | ghidra, radare2, strings, binwalk, objdump |
| Dynamic RE | `re-dynamic` | gdb, pwndbg, strace, ltrace, angr |
| Android | `mobile-android` | apktool, jadx, adb, frida, mobsf |
| iOS | `mobile-ios` | frida, objection, mobsf |
| Mobile API | `mobile-dynamic` | objection, frida, burpsuite, nuclei, ffuf |
| Reporting | `pentest-report` / `blue-report` / `forensic-report` / `mobile-report` | Mode-appropriate report with PoCs |

Skills live in [`.agents/skills/`](.agents/skills/) — readable, editable, and extensible.

---

## Team Mode

One agent is fast. A coordinated team is devastating.

Team Mode runs multiple specialist agents in parallel, each communicating through dedicated tools. Hydra recons while Scylla exploits. Argus watches scope while Hermes drafts the report.

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

Built-in team skills:

- **`hyperplan`** — 5 adversarial critics tear apart the engagement plan before a single tool fires
- **`security-research`** — 3 hunters + 2 PoC engineers audit the target in parallel

---

## Scope Enforcement

The agent polices itself.

Before any active testing, Talos parses the program scope, validates every target against it, and refuses to test out-of-scope assets — even if they appear in the attack path. Scope decisions are logged.

Per-mode safety controls:

| Control | Bug Bounty | Red Team | CTF | Offensive |
| :--- | :---: | :---: | :---: | :---: |
| Scope enforcement | Strict | Moderate | None | None |
| DoS protection | On | On | Off | Off |
| Stealth mode | Off | On | Off | Off |
| Exfiltration guard | On | On | Off | Off |
| Auto-stop on violation | On | On | Off | Off |

---

## Installation

```bash
bunx oh-my-open-pentest install
```

The wizard handles:

1. **Mode** — select your default engagement mode
2. **Provider auth** — Anthropic, OpenAI, Gemini, or others
3. **Agent configuration** — model assignments per agent
4. **Verification** — `bunx oh-my-open-pentest doctor` confirms everything

For non-interactive install:

```bash
bunx oh-my-open-pentest install --non-interactive
```

---

## Usage

```bash
# Start an engagement
fullscan

# With a target
fullscan https://target.example.com

# Pick a mode first
/mode bug-bounty
fullscan

# Run specific phases
/pentest-recon
/pentest-enum
/pentest-exploit

# Check engagement state
bunx oh-my-open-pentest doctor
```

Engagement state is preserved across sessions. Interrupted engagements resume from the last checkpoint. Already-tested vectors are tracked and skipped.

---

## Uninstallation

```bash
# Remove plugin from OpenCode config
jq '.plugin = [.plugin[] | select(. != "oh-my-open-pentest" and . != "oh-my-open-pentest")]' \
    ~/.config/opencode/opencode.json > /tmp/oc.json && \
    mv /tmp/oc.json ~/.config/opencode/opencode.json

# Remove config files
rm -f ~/.config/opencode/oh-my-open-pentest.jsonc \
      .opencode/oh-my-open-pentest.jsonc
```

---

## Further Reading

- [Manifesto](docs/manifesto.md) — the philosophy
- [Engagement Workflow](docs/guide/pentest-workflow.md) — full lifecycle guide
- [Engagement Modes](docs/guide/modes.md) — 7 modes in detail
- [Tool Reference](docs/guide/tools.md) — 40+ tools by phase
- [Team Mode](docs/guide/team-mode.md) — parallel agent coordination
- [Installation Guide](docs/guide/installation.md) — step-by-step setup

---

## Author's Note

I built this because the alternative is worse.

Manual recon is mechanical work. Copy-pasting PoCs is mechanical work. Formatting reports is mechanical work. The agent does it. You think about strategy.

The goal: **findings submitted by the agent should be indistinguishable from those submitted by a top-tier bug bounty hunter.** Not a scan result that needs triage. The final, validated, submission-ready report.

That's the bar. Every feature in this project exists to clear it.

Contributions welcome. PRs to `dev`.
