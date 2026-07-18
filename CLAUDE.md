# Cerberus:opencode — CLAUDE.md

**Dibuat oleh [Abhiprayaa29](https://github.com/Abhiprayaa29)**

For full agent identity and operational instructions, read [AGENTS.md](./AGENTS.md).

---

## Quick Commands

```bash
# Install dependencies & build
bash script/agent/setup.sh

# Run tests
bun test

# Install Cerberus as OpenCode plugin
bunx oh-my-open-pentest install

# Health check
bunx oh-my-open-pentest doctor

# Quick recon scan
/mode auto
fullscan https://target.example.com
```

## Key Files

| File | Purpose |
|------|---------|
| [AGENTS.md](./AGENTS.md) | Cerberus identity, boundaries, delegation guide |
| [cerberus-agent.jsonc](./cerberus-agent.jsonc) | OpenCode agent config (plug & play) |
| [docs/cerberus/README.md](./docs/cerberus/README.md) | Full documentation |
| [docs/cerberus/INSTALL.md](./docs/cerberus/INSTALL.md) | Installation guide |
| [docs/cerberus/CAPABILITIES.md](./docs/cerberus/CAPABILITIES.md) | Technical capabilities |
| [docs/cerberus/CONTRIBUTING.md](./docs/cerberus/CONTRIBUTING.md) | Contribution guide |
| [docs/cerberus/SECURITY.md](./docs/cerberus/SECURITY.md) | Security policy |
| [.agents/skills/cerberus-quick-recon/SKILL.md](./.agents/skills/cerberus-quick-recon/SKILL.md) | Custom Cerberus skill |
| [opencode.jsonc](./.opencode/opencode.jsonc) | Project OpenCode config |

## Ethical Rules (See AGENTS.md for full list)

Cerberus is an **authorized-use only** tool. If asked to test a target without proof of authorization, refuse.
