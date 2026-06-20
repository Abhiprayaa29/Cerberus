> [!TIP]
> Be with us!
>
> | [<img alt="Discord link" src="https://img.shields.io/discord/1452487457085063218?color=5865F2&label=discord&labelColor=black&logo=discord&logoColor=white&style=flat-square" width="156px" />](https://discord.gg/PUwSMR9XNk) | Join our [Discord community](https://discord.gg/PUwSMR9XNk) to connect with contributors and fellow `oh-my-open-pentest` users. |
> | :-----| :----- |
> | [<img alt="X link" src="https://img.shields.io/badge/Follow-%40justsisyphus-00CED1?style=flat-square&logo=x&labelColor=black" width="156px" />](https://x.com/justsisyphus) | Updates posted by [@justsisyphus](https://x.com/justsisyphus). |
> | [<img alt="GitHub Follow" src="https://img.shields.io/github/followers/code-yeongyu?style=flat-square&logo=github&labelColor=black&color=24292f" width="156px" />](https://github.com/code-yeongyu) | Follow [@code-yeongyu](https://github.com/code-yeongyu) on GitHub for more projects. |

<!-- <CENTERED SECTION FOR GITHUB DISPLAY> -->

<div align="center">

<a href="https://github.com/zakirkun/oh-my-open-pentest#oh-my-open-pentest"><img src="./.github/assets/omop-logo.png" alt="OmOP" width="200" /></a>

[![Oh My Open Pentest](./.github/assets/hero.jpg)](https://github.com/zakirkun/oh-my-open-pentest#oh-my-open-pentest)

</div>

<!-- </CENTERED SECTION FOR GITHUB DISPLAY> -->

<div align="center">

[![GitHub Release](https://img.shields.io/github/v/release/zakirkun/oh-my-open-pentest?color=369eff&labelColor=black&logo=github&style=flat-square)](https://github.com/zakirkun/oh-my-open-pentest/releases)
[![GitHub Contributors](https://img.shields.io/github/contributors/zakirkun/oh-my-open-pentest?color=c4f042&labelColor=black&style=flat-square)](https://github.com/zakirkun/oh-my-open-pentest/graphs/contributors)
[![GitHub Stars](https://img.shields.io/github/stars/zakirkun/oh-my-open-pentest?color=ffcb47&labelColor=black&style=flat-square)](https://github.com/zakirkun/oh-my-open-pentest/stargazers)
[![GitHub Issues](https://img.shields.io/github/issues/zakirkun/oh-my-open-pentest?color=ff80eb&labelColor=black&style=flat-square)](https://github.com/zakirkun/oh-my-open-pentest/issues)
[![License](https://img.shields.io/badge/license-SUL--1.0-white?labelColor=black&style=flat-square)](https://github.com/zakirkun/oh-my-open-pentest/blob/dev/LICENSE.md)

</div>

---

# Oh My Open Pentest

**Autonomous penetration testing. Define scope. Type `fullscan`. Walk away.**

oh-my-open-pentest is an agentic automation platform for offensive security. It runs a complete engagement — recon, enumeration, exploitation, and report — without human babysitting. You define the scope and rules of engagement. The agent finds what's inside them.

> Human intervention during an engagement is a failure signal. If the system is designed correctly, the agent completes the cycle — recon through report — without requiring babysitting.
>
> — [Manifesto](docs/manifesto.md)

---

## What's New in v2.2

- **109 security tools** — expanded from 60, added netexec, certipy, sliver, ligolo-ng, chisel, dalfox, xsstrike, wifite, pacu, prowler and more
- **250 skill playbooks** — comprehensive coverage across vuln classes, protocols, frameworks, post-exploitation, and payloads
- **airecon data layer** — attack chains, vuln ontology, WAF signatures, CVE correlations, tech correlations, fuzzer data loaded from structured JSON
- **Client-side pentest** — Playwright browser automation for DOM XSS, auth flow testing, CSRF PoC, SPA endpoint discovery
- **Live catalog** — tools-catalog.json fetched from GitHub at startup, always current

---

## The Core Loop

```
Scope + RoE → RECON → ENUM → EXPLOIT → VERIFY → REPORT
      ↑                                              ↓
      └──────────── Scope enforced at every step ───┘
```

Every phase is autonomous. Scope boundaries are parsed, validated, and enforced by the agent — not by you. Every finding is verified before it hits the report. The output is submission-ready.

---

## Installation

### Prerequisites

- [OpenCode](https://github.com/opencode-ai/opencode) installed and configured
- [Bun](https://bun.sh) runtime (`curl -fsSL https://bun.sh/install | bash`)

### Step 1 — Install oh-my-open-pentest

```bash
bunx oh-my-open-pentest install
```

The wizard configures:
1. **Mode** — default engagement mode
2. **Provider** — Anthropic, OpenAI, Gemini, or custom OpenAI-compatible endpoint
3. **Models** — per-agent model assignments
4. **Verification** — `doctor` check at the end

### Step 2 — Register the plugin in OpenCode

After install, confirm the plugin is registered:

```bash
cat ~/.config/opencode/opencode.json | grep plugin
```

Expected output:
```json
"plugin": ["file:///path/to/oh-my-open-pentest/dist/index.js"]
```

If `plugin` is empty, add it manually:

```bash
# Get the dist path
bunx oh-my-open-pentest doctor

# Edit opencode.json — add the file:// path
# Linux/macOS:
jq '.plugin = ["file:///home/USER/.npm-global/lib/node_modules/oh-my-open-pentest/dist/index.js"]' \
  ~/.config/opencode/opencode.json > /tmp/oc.json && mv /tmp/oc.json ~/.config/opencode/opencode.json

# Or for a local dev clone:
jq --arg p "file:///path/to/oh-my-open-pentest/dist/index.js" '.plugin = [$p]' \
  ~/.config/opencode/opencode.json > /tmp/oc.json && mv /tmp/oc.json ~/.config/opencode/opencode.json
```

### Step 3 — Verify

```bash
bunx oh-my-open-pentest doctor
```

All checks green = ready.

### Non-interactive install

```bash
bunx oh-my-open-pentest install --non-interactive
```

---

## Quickstart

Open OpenCode in any directory and type:

```
fullscan
```

For a specific target:

```
fullscan https://target.example.com
```

The agent auto-detects the engagement mode from the target, loads the matching skill chain, and runs recon through report.

---

## Usage

### Starting an engagement

```bash
# Auto-detect mode from target
fullscan https://target.example.com

# IP/network target (red-team mode auto-detected)
fullscan 10.0.0.1/24

# Explicit mode
/mode bug-bounty
fullscan https://target.example.com
```

### Running specific phases

```bash
# Individual phases
/pentest-recon
/pentest-enum
/pentest-exploit
/pentest-report

# Red team phases
/red-recon
/red-exploit
/red-lateral
/red-persistence

# Vulnerability-specific
/vuln-sqli
/vuln-xss
/vuln-ssrf
/vuln-cors
/vuln-idor
/vuln-rce
/vuln-xxe
/vuln-ssti
/vuln-deserialization
/vuln-file-upload
/vuln-http-smuggling
/vuln-race-conditions
/vuln-business-logic

# Protocol-specific
/proto-smb
/proto-kerberos
/proto-graphql
/proto-ssh

# Technology-specific
/tech-spring
/tech-wordpress
/tech-docker
/tech-redis
/tech-jenkins

# Client-side pentest (browser automation)
/pentest-browser

# Payload collections
/payload-xss
/payload-sqli
/payload-ssrf
/payload-ssti
/payload-xxe
/payload-lfi
/payload-command-injection

# Post-exploitation
/post-linux-privesc
/post-windows-privesc
/post-pivoting
```

### Engagement state

```bash
# Health check
bunx oh-my-open-pentest doctor

# View doctor output
bunx oh-my-open-pentest doctor --verbose
```

Engagement state is preserved across sessions. Interrupted engagements resume from the last checkpoint.

---

## Engagement Modes

Ten modes, each tuned for a different context. Auto-detected from target indicators, or set explicitly.

| Mode | When to use | Tool priority | Report format |
| :--- | :--- | :--- | :--- |
| **Auto** | Unknown target, let the agent decide | Adaptive | Standard |
| **CTF** | Capture The Flag competitions | Exploit → Enum → Recon | Flag submission |
| **Bug Bounty** | HackerOne, Bugcrowd, Intigriti, YesWeHack | Recon → Enum → Exploit | HackerOne format |
| **Red Team** | Stealth operations, persistence, lateral movement | Recon → Exploit → Enum | Executive summary |
| **Blue Team** | Detection, incident response, forensics | Enum → Recon → Report | IR report |
| **Offensive** | Aggressive exploitation, PoC chains | Exploit → Enum → Recon | Technical |
| **Grey Hat** | Balanced offensive/defensive | Balanced | Technical |
| **Forensic** | Digital forensics, evidence preservation, IR | Forensics → Report | Forensic (chain-of-custody) |
| **Reverse Engineering** | Binary analysis, malware RE | RE → Exploit → Utility | Technical RE |
| **Mobile Pentest** | Android/iOS app security assessment | Mobile → Enum → Exploit | Mobile (OWASP Top 10) |

Switch mode:

```
/mode bug-bounty
/mode red-team
/mode mobile-pentest
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

---

## Tool Coverage

109 security tools, ready to use. Missing tools are installed automatically before first use.

**Recon / OSINT**
`subfinder` · `amass` · `assetfinder` · `httpx` · `naabu` · `massdns` · `nmap` · `masscan` · `rustscan` · `theHarvester` · `sublist3r` · `spiderfoot` · `sherlock` · `holehe` · `maigret` · `dnstwist`

**Secrets / Code**
`trufflehog` · `gitleaks` · `secretfinder`

**Enumeration**
`nuclei` · `ffuf` · `gobuster` · `feroxbuster` · `dirsearch` · `whatweb` · `wafw00f` · `nikto` · `katana` · `arjun` · `testssl` · `trivy` · `gospider`

**Web Exploitation**
`sqlmap` · `commix` · `dalfox` · `xsstrike` · `nosqlmap` · `burpsuite` · `owasp-zap` · `mitmproxy`

**Credential / Auth**
`hydra` · `hashcat` · `john` · `certipy` · `kerbrute`

**Active Directory / Windows**
`netexec` · `evil-winrm` · `bloodhound` · `crackmapexec` · `impacket` · `responder` · `mimikatz`

**C2 / Pivoting**
`metasploit` · `sliver` · `havoc` · `mythic` · `pwncat-cs` · `chisel` · `ligolo-ng`

**Post-Exploitation**
`peass-ng` · `pwntools`

**Wireless**
`wifite` · `airgeddon` · `wifiphisher` · `bettercap` · `hcxdumptool`

**Cloud**
`pacu` · `routersploit` · `prowler` · `scoutsuite`

**Phishing**
`evilginx3` · `setoolkit`

**Forensics / IR**
`volatility3` · `autopsy` · `binwalk` · `foremost` · `bulk_extractor` · `exiftool` · `tcpdump` · `tshark` · `wireshark` · `yara` · `steghide` · `stegcracker` · `pspy`

**Reverse Engineering**
`ghidra` · `radare2` · `cutter` · `gdb` · `pwndbg` · `ltrace` · `strace` · `angr`

**Mobile**
`apktool` · `jadx` · `frida` · `objection` · `mobsf` · `adb` · `androguard`

**Utility**
`curl` · `jq` · `anew` · `notify` · `grep` · `haiti`

Full catalog: [`tools-catalog.json`](tools-catalog.json) — each tool includes install commands, version check, flag definitions, and phase tags. The catalog is fetched live from GitHub at startup.

---

## Skill Library

250 skills covering every phase of a penetration test. Skills are markdown playbooks — readable, editable, and executable by the agent.

**Vulnerability Classes**
`vuln-sqli` · `vuln-xss` · `vuln-ssrf` · `vuln-cors` · `vuln-idor` · `vuln-rce` · `vuln-xxe` · `vuln-ssti` · `vuln-deserialization` · `vuln-file-upload` · `vuln-http-smuggling` · `vuln-race-conditions` · `vuln-business-logic` · `vuln-csrf` · `vuln-path-traversal` · `vuln-open-redirect` · `vuln-mass-assignment` · `vuln-nosql` · `vuln-host-header` · `vuln-crlf` · `vuln-prototype-pollution` · `vuln-jwt` · `vuln-oauth` · `vuln-2fa-bypass` · `vuln-account-takeover` · `vuln-bfla` · `vuln-cors` · `vuln-websocket` · `vuln-grpc` · `vuln-waf-bypass` · `vuln-subdomain-takeover` · `vuln-supply-chain` · and 20+ more

**Reconnaissance**
`recon-full` · `recon-subdomain` · `recon-internal` · `recon-dorking` · `recon-js-analysis` · `recon-secrets` · `recon-shodan` · `recon-asn-whois` · `recon-devtools`

**Post-Exploitation**
`post-linux-privesc` · `post-windows-privesc` · `post-pivoting` · `post-lateral-movement` · `post-credential-dumping` · `post-bloodhound` · `post-container-escape`

**Payload Collections**
`payload-xss` · `payload-sqli` · `payload-ssrf` · `payload-ssti` · `payload-xxe` · `payload-lfi` · `payload-command-injection` · `payload-ldap-injection` · `payload-xpath-injection`

**Technology-Specific**
`tech-spring` · `tech-wordpress` · `tech-docker` · `tech-redis` · `tech-jenkins` · `tech-mongodb` · `tech-elasticsearch` · `tech-tomcat` · `tech-firebase` · `tech-supabase` · `tech-cloud-security` · `tech-kubernetes` · `tech-nginx-apache`

**Frameworks**
`framework-django` · `framework-flask` · `framework-laravel` · `framework-rails` · `framework-spring` · `framework-express` · `framework-nextjs` · `framework-fastapi` · `framework-php` · `framework-wordpress` · `framework-dotnet`

**Protocols**
`proto-smb` · `proto-kerberos` · `proto-graphql` · `proto-ssh` · `proto-ldap` · `proto-rdp` · `proto-ftp` · `proto-smtp` · `proto-snmp` · `proto-dns`

**Tool Guides**
`tool-nmap` · `tool-sqlmap` · `tool-nuclei` · `tool-metasploit` · `tool-impacket` · `tool-dalfox` · `tool-hashcat-john` · `tool-advanced-fuzzing` · `tool-caido` · `tool-semgrep`

Skills live in [`.agents/skills/`](.agents/skills/) — readable, editable, extensible.

---

## Client-Side Pentest

Browser automation for testing JavaScript-heavy applications. The `pentest-browser` builtin skill drives a real headless browser via Playwright.

```
/pentest-browser
```

Covers:
- **DOM XSS** — hash/fragment/query sinks, postMessage, innerHTML injection
- **Auth flow testing** — session fixation, remember-me abuse, concurrent sessions
- **CSRF PoC** — `fetch()` intercept, state-changing request capture
- **SPA endpoint discovery** — XHR/fetch monkey-patch, network log analysis
- **Client-side storage** — localStorage, sessionStorage, IndexedDB, Service Worker cache
- **CSP analysis** — header inspection, JSONP bypass, angular template injection
- **Clickjacking** — iframe embedding test, screenshot evidence

Playwright provider options (configure in `oh-my-open-pentest.jsonc`):

```jsonc
{
  "browser_automation": {
    "provider": "playwright"        // MCP via @playwright/mcp (default)
    // "provider": "playwright-cli" // CLI binary, token-efficient
    // "provider": "agent-browser"  // Vercel agent-browser
  }
}
```

---

## Intelligence Data Layer

Structured reference data used at runtime for smarter analysis. Sourced from airecon and stored in `packages/pentest-core/src/data/`.

| File | What it contains |
| :--- | :--- |
| `attack_chains.json` | 40+ multi-stage exploitation pathways with step-by-step sequences |
| `vuln_ontology.json` | Unified vulnerability classification — 12 categories, CWE mapping, regex signals |
| `waf_signatures.json` | WAF fingerprinting signatures |
| `waff_bypass.json` | WAF bypass technique library |
| `fuzzer_data.json` | Fuzzing payload collections |
| `tech_correlations.json` | Technology → known vulnerability correlations |
| `port_correlations.json` | Port → service → attack vector mapping |
| `cve_correlations.json` | CVE to technology and attack pattern mapping |
| `patterns.json` | Detection patterns for vulnerability identification |
| `endpoint_patterns.json` | API endpoint pattern library |

---

## Team Mode

One agent is fast. A coordinated team is devastating.

Team Mode runs multiple specialist agents in parallel, each communicating through dedicated tools.

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

Before any active testing, Talos parses the program scope, validates every target against it, and refuses to test out-of-scope assets — even if they appear in the attack path.

Per-mode safety controls:

| Control | Bug Bounty | Red Team | CTF | Offensive |
| :--- | :---: | :---: | :---: | :---: |
| Scope enforcement | Strict | Moderate | None | None |
| DoS protection | On | On | Off | Off |
| Stealth mode | Off | On | Off | Off |
| Exfiltration guard | On | On | Off | Off |
| Auto-stop on violation | On | On | Off | Off |

---

## Uninstallation

```bash
# Remove plugin from OpenCode config
jq '.plugin = [.plugin[] | select(. != "oh-my-open-pentest")]' \
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
- [Engagement Modes](docs/guide/modes.md) — 10 modes in detail
- [Tool Reference](docs/guide/tools.md) — 109 tools by phase
- [Team Mode](docs/guide/team-mode.md) — parallel agent coordination
- [Installation Guide](docs/guide/installation.md) — step-by-step setup

---

## Author's Note

I built this because the alternative is worse.

Manual recon is mechanical work. Copy-pasting PoCs is mechanical work. Formatting reports is mechanical work. The agent does it. You think about strategy.

The goal: **findings submitted by the agent should be indistinguishable from those submitted by a top-tier bug bounty hunter.** Not a scan result that needs triage. The final, validated, submission-ready report.

That's the bar. Every feature in this project exists to clear it.

Contributions welcome. PRs to `dev`.
