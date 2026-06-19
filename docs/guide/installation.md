# Installation

oh-my-open-pentest is an **OpenCode plugin**. Install OpenCode first, then install the plugin.

---

## Prerequisites

### 1. OpenCode

```bash
# Install OpenCode (latest)
npm install -g opencode-ai

# Verify
opencode --version
```

### 2. Bun (required for the plugin installer)

```bash
# Linux / macOS
curl -fsSL https://bun.sh/install | bash

# Windows
powershell -c "irm bun.sh/install.ps1|iex"

# Verify
bun --version   # requires 1.x
```

### 3. Provider API key

At least one LLM provider is required. Anthropic Claude is strongly recommended — Cerberus (orchestrator) is optimized for Claude.

| Provider | Where to get key | Set in environment |
| :--- | :--- | :--- |
| Anthropic (recommended) | [console.anthropic.com](https://console.anthropic.com) | `ANTHROPIC_API_KEY` |
| OpenAI | [platform.openai.com](https://platform.openai.com) | `OPENAI_API_KEY` |
| Google Gemini | [aistudio.google.com](https://aistudio.google.com) | `GEMINI_API_KEY` |

```bash
export ANTHROPIC_API_KEY="sk-ant-..."
```

---

## Install

```bash
bunx oh-my-open-pentest install
```

The interactive installer handles:

1. **Mode selection** — default engagement mode (auto, bug-bounty, ctf, etc.)
2. **Provider auth** — validates your API key(s) and detects available models
3. **Agent configuration** — assigns models to each agent (Cerberus, Hydra, Scylla, etc.)
4. **Tool verification** — checks which security tools are installed
5. **Health check** — runs `doctor` to confirm everything works

### Non-interactive install

```bash
bunx oh-my-open-pentest install --non-interactive
```

Applies defaults: auto mode, Anthropic provider, standard agent config.

---

## Verify

```bash
bunx oh-my-open-pentest doctor
```

Doctor checks:

| Check | What it verifies |
| :--- | :--- |
| System | OpenCode version, Bun version, Node version |
| Config | Plugin registered, config schema valid |
| Provider | API key valid, models accessible |
| Agents | All 6 agents have valid model assignments |
| Tools | Security tools installed (40+ catalog entries checked) |
| Skills | 28 skill files present and parseable |

Fix a failed check:

```bash
bunx oh-my-open-pentest doctor --json   # machine-readable output for scripting
```

---

## Security Tools

oh-my-open-pentest checks for required tools before each phase and installs missing ones automatically. To pre-install all catalog tools:

### Recon tools

```bash
# Go-based tools (requires Go 1.22+)
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install -v github.com/owasp-amass/amass/v4/...@master
go install -v github.com/tomnomnom/assetfinder@latest
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
go install -v github.com/projectdiscovery/naabu/v2/cmd/naabu@latest
go install -v github.com/tomnomnom/anew@latest
go install -v github.com/projectdiscovery/notify/cmd/notify@latest

# Package manager
sudo apt install nmap massdns   # Linux
brew install nmap massdns        # macOS
winget install nmap              # Windows
```

### Enumeration tools

```bash
go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
go install github.com/ffuf/ffuf/v2@latest
go install github.com/OJ/gobuster/v3@latest
cargo install feroxbuster

sudo apt install nikto whatweb wafw00f   # Linux
pip install dirsearch
```

### Exploitation tools

```bash
pip install sqlmap commix
sudo apt install hydra hashcat john metasploit-framework   # Linux
pip install pwntools
```

### Active Directory tools

```bash
pip install bloodhound crackmapexec impacket
sudo apt install responder   # Linux
```

### Forensics tools

```bash
sudo apt install volatility3 autopsy binwalk foremost bulk-extractor exiftool tcpdump tshark   # Linux
brew install exiftool tshark binwalk   # macOS
pip install volatility3
```

### Reverse engineering tools

```bash
sudo apt install gdb ltrace strace   # Linux
brew install radare2 gdb             # macOS
pip install angr ROPgadget

# pwndbg (GDB plugin)
git clone https://github.com/pwndbg/pwndbg && cd pwndbg && ./setup.sh

# Ghidra
brew install --cask ghidra      # macOS
winget install NSA.Ghidra        # Windows
# Linux: download from https://ghidra-sre.org

# Cutter (Radare2 GUI)
brew install --cask cutter      # macOS
```

### Mobile tools

```bash
# Android
sudo apt install adb apktool   # Linux
brew install android-platform-tools apktool jadx   # macOS
pip install frida-tools objection

# MobSF
git clone https://github.com/MobSF/Mobile-Security-Framework-MobSF.git
cd Mobile-Security-Framework-MobSF && ./setup.sh
```

---

## Configuration

### Project config

Create `.opencode/oh-my-open-pentest.jsonc` in your working directory:

```jsonc
{
  // Default engagement mode for this project
  "default_mode": "bug-bounty",

  // Team Mode (parallel agents)
  "team_mode": {
    "enabled": false,
    "max_parallel_members": 4,
    "tmux_visualization": false
  },

  // Pentest loop settings
  "pentest_loop": {
    "enabled": true,
    "default_max_iterations": 100,
    "default_strategy": "continue"
  }
}
```

### User config

User-level config at `~/.config/opencode/oh-my-open-pentest.jsonc`:

```jsonc
{
  // Agent model assignments
  "agents": {
    "cerberus": { "model": "claude-opus-4-8" },
    "hydra":    { "model": "claude-haiku-4-5-20251001" },
    "scylla":   { "model": "claude-sonnet-4-6" },
    "argus":    { "model": "claude-haiku-4-5-20251001" },
    "talos":    { "model": "claude-haiku-4-5-20251001" },
    "hermes":   { "model": "claude-sonnet-4-6" }
  },

  // Allowlist for MCP environment variable passthrough
  "mcp_env_allowlist": ["ANTHROPIC_API_KEY", "OPENAI_API_KEY"]
}
```

### Config precedence

```
Project .opencode/oh-my-open-pentest.jsonc  (closest wins)
  ↓
User ~/.config/opencode/oh-my-open-pentest.jsonc
  ↓
Built-in defaults (Zod schema)
```

---

## Upgrade

```bash
bunx oh-my-open-pentest@latest install
```

The installer detects existing config and migrates automatically.

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

# Remove engagement artifacts (optional)
rm -rf .omop/
```

---

## Troubleshooting

### Plugin not loading

```bash
# Check plugin is registered
cat ~/.config/opencode/opencode.json | jq '.plugin'
# Should contain "oh-my-open-pentest"

# Re-register manually
bunx oh-my-open-pentest install --force
```

### API key not found

```bash
# Check environment
echo $ANTHROPIC_API_KEY

# Set for current session
export ANTHROPIC_API_KEY="sk-ant-..."

# Set permanently (add to ~/.bashrc or ~/.zshrc)
echo 'export ANTHROPIC_API_KEY="sk-ant-..."' >> ~/.bashrc
```

### Security tool missing

```bash
# Check specific tool
which subfinder

# Doctor shows all missing tools
bunx oh-my-open-pentest doctor

# Missing tools are auto-installed on first use
# Or install manually (see Security Tools section above)
```

### OpenCode version incompatibility

```bash
# Check version
opencode --version

# Update OpenCode
npm install -g opencode-ai@latest
```

### Windows: shell tools not found

Install Git Bash for POSIX tool compatibility:

```powershell
winget install --id Git.Git -e --source winget
```

Then use Git Bash for running engagements.

---

## For LLM Agents

To install oh-my-open-pentest via a Claude Code or other LLM agent session:

```
Install and configure oh-my-open-pentest by following the instructions here:
https://raw.githubusercontent.com/code-yeongyu/oh-my-open-pentest/refs/heads/dev/docs/guide/installation.md

Use curl to fetch this file — do NOT use WebFetch which may summarize content.
```

Installation flow for agents:

1. Check prerequisites (OpenCode, Bun, API key)
2. Run `bunx oh-my-open-pentest install`
3. Answer: mode selection, provider auth, model assignments
4. Verify with `bunx oh-my-open-pentest doctor`
5. Report any failed checks back to user

---

## Further Reading

- [Usage Guide](./usage.md) — how to run engagements
- [Engagement Modes](./modes.md) — 10 modes explained
- [Tool Reference](./tools.md) — 60+ tools by phase
