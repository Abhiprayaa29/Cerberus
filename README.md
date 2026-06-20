> [!TIP]
> Be with us!
>
> | [<img alt="Discord link" src="https://img.shields.io/discord/1452487457085063218?color=5865F2&label=discord&labelColor=black&logo=discord&logoColor=white&style=flat-square" width="156px" />](https://discord.gg/PUwSMR9XNk) | Join our [Discord community](https://discord.gg/PUwSMR9XNk) to connect with contributors. |
> | :-----| :----- |
> | [<img alt="X link" src="https://img.shields.io/badge/Follow-%40justsisyphus-00CED1?style=flat-square&logo=x&labelColor=black" width="156px" />](https://x.com/justsisyphus) | Updates posted by [@justsisyphus](https://x.com/justsisyphus). |

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
[![License](https://img.shields.io/badge/license-SUL--1.0-white?labelColor=black&style=flat-square)](https://github.com/zakirkun/oh-my-open-pentest/blob/dev/LICENSE.md)

</div>

---

# Oh My Open Pentest

**An AI agent that runs penetration tests. End to end. No babysitting.**

Define the scope. Say `fullscan`. The agent runs recon, enumerates the attack surface, exploits findings, verifies them, and delivers a submission-ready report. You review results, not progress.

> Human intervention during an engagement is a failure signal. If the system is designed correctly, the agent completes the cycle — recon through report — without requiring babysitting.
>
> — [Manifesto](docs/manifesto.md)

---

## What it does

```
You:     fullscan https://target.example.com
Agent:   [RECON]   subfinder, httpx, nmap, theHarvester...
         [ENUM]    nuclei, ffuf, nikto, arjun, katana...
         [EXPLOIT] sqlmap, dalfox, netexec, certipy...
         [VERIFY]  every finding confirmed before report
         [REPORT]  CVSS scores, PoCs, reproduction steps
You:     read the report
```

109 tools. 250 skill playbooks. 10 engagement modes. The agent picks the right tools for the target — you don't configure anything.

---

## v2.2 Changelog

- **250 skill playbooks** — full coverage: vuln classes, protocols, frameworks, post-exploitation, payloads
- **109 security tools** — netexec, certipy, sliver, ligolo-ng, chisel, dalfox, xsstrike, wifite, pacu, prowler and more
- **Intelligence data layer** — attack chains, WAF signatures, CVE correlations, tech correlations loaded at runtime
- **Client-side pentest** — Playwright browser automation for DOM XSS, auth flows, CSRF PoC, SPA endpoint discovery
- **Live catalog** — tools-catalog.json fetched from GitHub at startup, always current

---

## Quickstart

```bash
# Install
bunx oh-my-open-pentest install

# Run a full engagement
fullscan https://target.example.com

# Run against a network range (auto-selects red-team mode)
fullscan 10.0.0.1/24

# CTF target
fullscan hackthebox.eu/machines/SomeMachine
```

The agent detects the engagement type, selects the matching mode and skill chain, and runs the full cycle autonomously.

---

## Installation

Requires [OpenCode](https://github.com/opencode-ai/opencode) and [Bun](https://bun.sh).

### Install

```bash
bunx oh-my-open-pentest install
```

The wizard sets your engagement mode, AI provider, and model assignments, then verifies the installation.

### Register the plugin

```bash
# Verify plugin is registered
cat ~/.config/opencode/opencode.json | grep plugin
# Expected: "plugin": ["file:///path/to/oh-my-open-pentest/dist/index.js"]
```

If missing, add it manually:

```bash
jq --arg p "file:///path/to/oh-my-open-pentest/dist/index.js" '.plugin = [$p]' \
  ~/.config/opencode/opencode.json > /tmp/oc.json && mv /tmp/oc.json ~/.config/opencode/opencode.json
```

### Verify

```bash
bunx oh-my-open-pentest doctor
```

---

## Engagement Modes

Ten modes. Each optimized for a different context. Auto-detected from the target, or set explicitly with `/mode`.

| Mode | Use case | Tool priority | Output |
| :--- | :--- | :--- | :--- |
| **auto** | Unknown target | Adaptive | Standard |
| **bug-bounty** | HackerOne, Bugcrowd, Intigriti | Recon → Enum → Exploit | HackerOne format |
| **red-team** | Stealth ops, persistence, AD | Recon → Exploit → Enum | Executive summary |
| **ctf** | HackTheBox, TryHackMe, picoCTF | Exploit → Enum → Recon | Flag submission |
| **blue-team** | Detection, IR, defensive audit | Enum → Recon → Report | IR report |
| **offensive** | Aggressive exploitation, PoC chains | Exploit → Enum → Recon | Technical |
| **grey-hat** | Balanced | Balanced | Technical |
| **forensic** | Evidence preservation, disk/memory | Forensics → Report | Chain-of-custody |
| **reverse-engineering** | Binaries, firmware, malware | RE → Exploit → Utility | Technical RE |
| **mobile-pentest** | Android/iOS app assessment | Mobile → Enum → Exploit | OWASP Mobile Top 10 |

```
/mode red-team
/mode bug-bounty
/mode ctf
```

---

## Skill Library

250 skill playbooks — executable by the agent, readable by you.

**Vulnerability Classes**

```
/vuln-sqli          /vuln-xss           /vuln-ssrf          /vuln-cors
/vuln-idor          /vuln-rce           /vuln-xxe           /vuln-ssti
/vuln-deserialization                   /vuln-file-upload   /vuln-http-smuggling
/vuln-race-conditions                   /vuln-business-logic /vuln-csrf
/vuln-jwt           /vuln-oauth         /vuln-2fa-bypass    /vuln-account-takeover
/vuln-bfla          /vuln-websocket     /vuln-grpc          /vuln-waf-bypass
/vuln-subdomain-takeover                /vuln-prototype-pollution
```

**Reconnaissance**

```
/recon-full         /recon-subdomain    /recon-internal     /recon-dorking
/recon-js-analysis  /recon-secrets      /recon-shodan       /recon-asn-whois
```

**Post-Exploitation**

```
/post-linux-privesc         /post-windows-privesc       /post-pivoting
/post-lateral-movement      /post-credential-dumping    /post-bloodhound
/post-container-escape
```

**Payload Collections**

```
/payload-xss    /payload-sqli   /payload-ssrf   /payload-ssti
/payload-xxe    /payload-lfi    /payload-command-injection
```

**Technology-Specific**

```
/tech-spring    /tech-wordpress     /tech-docker        /tech-redis
/tech-jenkins   /tech-mongodb       /tech-kubernetes    /tech-firebase
```

**Frameworks**

```
/framework-django   /framework-laravel  /framework-rails    /framework-spring
/framework-express  /framework-nextjs   /framework-fastapi  /framework-dotnet
```

**Protocols**

```
/proto-smb      /proto-kerberos     /proto-graphql      /proto-ssh
/proto-ldap     /proto-rdp          /proto-smtp         /proto-dns
```

**Client-Side**

```
/pentest-browser    — DOM XSS, auth flows, CSRF PoC, SPA endpoints, clickjacking
```

All skills live in [`.agents/skills/`](.agents/skills/).

---

## Tool Coverage

109 security tools. Missing tools install automatically before first use.

| Phase | Tools |
| :--- | :--- |
| **Recon / OSINT** | subfinder · amass · assetfinder · httpx · naabu · massdns · nmap · masscan · rustscan · theHarvester · sublist3r · spiderfoot · sherlock · holehe · maigret · dnstwist |
| **Secrets** | trufflehog · gitleaks · secretfinder |
| **Enumeration** | nuclei · ffuf · gobuster · feroxbuster · dirsearch · whatweb · wafw00f · nikto · katana · arjun · testssl · trivy · gospider |
| **Web Exploitation** | sqlmap · commix · dalfox · xsstrike · nosqlmap · burpsuite · owasp-zap · mitmproxy |
| **Credential / Auth** | hydra · hashcat · john · certipy · kerbrute |
| **Active Directory** | netexec · evil-winrm · bloodhound · crackmapexec · impacket · responder · mimikatz |
| **C2 / Pivoting** | metasploit · sliver · havoc · mythic · pwncat-cs · chisel · ligolo-ng |
| **Post-Exploitation** | peass-ng · pwntools |
| **Wireless** | wifite · airgeddon · wifiphisher · bettercap · hcxdumptool |
| **Cloud** | pacu · routersploit · prowler · scoutsuite |
| **Phishing** | evilginx3 · setoolkit |
| **Forensics / IR** | volatility3 · autopsy · binwalk · foremost · bulk_extractor · exiftool · tcpdump · tshark · wireshark · yara · steghide · stegcracker · pspy |
| **Reverse Engineering** | ghidra · radare2 · cutter · gdb · pwndbg · ltrace · strace · angr |
| **Mobile** | apktool · jadx · frida · objection · mobsf · adb · androguard |
| **Utility** | curl · jq · anew · notify · haiti |

Full catalog: [`tools-catalog.json`](tools-catalog.json) — fetched live from GitHub at startup.

---

## Intelligence Data Layer

Structured reference data loaded at runtime for smarter decisions. Sourced from [airecon](https://github.com/pikpikcu/airecon).

| File | Contents |
| :--- | :--- |
| `attack_chains.json` | 40+ multi-stage exploitation pathways |
| `vuln_ontology.json` | 12 vuln categories, CWE mapping, regex signals |
| `waf_signatures.json` | WAF fingerprinting signatures |
| `waff_bypass.json` | WAF bypass technique library |
| `fuzzer_data.json` | Fuzzing payload collections |
| `tech_correlations.json` | Technology → known vulnerability correlations |
| `port_correlations.json` | Port → service → attack vector mapping |
| `cve_correlations.json` | CVE to technology and attack pattern mapping |
| `patterns.json` | Detection patterns for vulnerability identification |
| `endpoint_patterns.json` | API endpoint pattern library |

---

## Scope Enforcement

Talos parses the program scope before any active testing. Every target is validated. Out-of-scope assets are refused — even when they appear in the attack path.

| Control | Bug Bounty | Red Team | CTF | Offensive |
| :--- | :---: | :---: | :---: | :---: |
| Scope enforcement | Strict | Moderate | Off | Off |
| DoS protection | On | On | Off | Off |
| Stealth mode | Off | On | Off | Off |
| Exfiltration guard | On | On | Off | Off |
| Auto-stop on violation | On | On | Off | Off |

---

## Team Mode

Parallel specialist agents for large engagements.

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
- **`hyperplan`** — 5 adversarial critics review the engagement plan before a tool fires
- **`security-research`** — 3 hunters + 2 PoC engineers audit in parallel

---

## Uninstallation

```bash
jq '.plugin = [.plugin[] | select(. != "oh-my-open-pentest")]' \
    ~/.config/opencode/opencode.json > /tmp/oc.json && \
    mv /tmp/oc.json ~/.config/opencode/opencode.json

rm -f ~/.config/opencode/oh-my-open-pentest.jsonc \
      .opencode/oh-my-open-pentest.jsonc
```

---

## Further Reading

- [Manifesto](docs/manifesto.md) — the philosophy
- [Engagement Workflow](docs/guide/pentest-workflow.md) — full lifecycle
- [Engagement Modes](docs/guide/modes.md) — 10 modes in detail
- [Tool Reference](docs/guide/tools.md) — 109 tools by phase
- [Installation Guide](docs/guide/installation.md) — step-by-step setup
- [Team Mode](docs/guide/team-mode.md) — parallel agent coordination

---

Contributions welcome. PRs to `dev`.
