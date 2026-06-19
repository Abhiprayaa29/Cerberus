# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

> **ACTIVE REFACTOR:** Rewriting from agentic code platform to agentic pentest automation. Pentest infrastructure (`pentest-core`, `pentest-skills`, `tools-catalog.json`, `.agents/skills/`) is production-ready. OpenCode plugin agent prompts are still dev-focused — rewrite in progress. Read [ROADMAP.md](./ROADMAP.md) before touching anything.

## DEVELOPMENT ENVIRONMENT

Single source of truth: `script/agent/setup.sh` (verifies toolchain, runs `bun install`, builds only if `dist/index.js` missing). `script/agent/cleanup.sh` removes transients; `--deep` also drops `dist/` + `node_modules/`. For QA isolation: `source script/agent/qa-sandbox.sh` exports throwaway XDG dirs so QA never touches real `~/.config/opencode`. See [AGENTS.md — Development Environment](./AGENTS.md#development-environment) for harness wiring (Codespaces, Docker, Cursor, Claude Code, Codex). See [AGENTS.md — Credentials & Isolation](./AGENTS.md#development-environment) for `.env.example` credential injection pattern.

**MAINTENANCE:** Update `script/agent/setup.sh`, `script/agent/cleanup.sh`, [AGENTS.md](./AGENTS.md), [CONTRIBUTING.md](./CONTRIBUTING.md), and the matching skill (`opencode-qa` or `codex-qa`) in the SAME change whenever a setup dependency or credential changes. Keep `script/agent-env.test.ts`, `script/agent-harness-wiring.test.ts`, and `script/agents-md-dev-env.test.ts` green. See AGENTS.md for the "and the matching skill" cross-reference requirement.

## Commands

```bash
# Development
bun test                         # Root Bun test suite
bun run build                    # Build plugin (ESM + .d.ts + CLI + schema)
bun run build:all                # Build + platform binaries
bun run build:schema             # Regenerate assets/oh-my-open-pentest.schema.json
bun run build:model-capabilities # Refresh model-capabilities cache from models.dev
bun run typecheck                # tsgo --noEmit (NOT tsc — uses @typescript/native-preview)
bun run typecheck:packages       # Per-workspace-package typecheck
bun run clean                    # rm -rf dist

# CLI (after build)
bunx oh-my-open-pentest install  # Interactive setup wizard
bunx oh-my-open-pentest doctor   # Health diagnostics (System / Config / Tools / Models)
bunx oh-my-open-pentest run <message>  # Non-interactive session

# Dev setup (single source of truth)
bash script/agent/setup.sh       # Install deps + build if dist/index.js missing
bash script/agent/cleanup.sh     # Remove transients; --deep also drops dist/ + node_modules/
source script/agent/qa-sandbox.sh  # Isolated XDG env for QA (never touches real ~/.config/opencode)
```

Run a single test file: `bun test path/to/file.test.ts`

## QA — MANDATORY, NO EXCEPTIONS

**Any change touching `packages/omop-opencode/`** must run the `opencode-qa` skill and write evidence to `.omop/evidence/<YYYYMMDD>-<short-slug>/`. No evidence file = no commit.

- Spawn opencode ONLY inside the XDG sandbox (`source script/agent/qa-sandbox.sh`) — never pollute real `~/.local/share/opencode/opencode.db`.
- Prove hook fired via `scripts/sse-hook-probe.sh --event <name>` for lifecycle hook changes.
- "It typechecks" and "`bun test` is green" are NOT QA. Drive the real harness.

## Default Workflow

Use the **`work-with-pr`** skill for all non-hotfix work: isolated git worktree → implement → QA evidence → PR → merge commit. Never hand-commit straight to `dev`.

- Merge = merge commit only. `gh pr merge <number> --merge --delete-branch`. **Never `--squash` or `--rebase`**.
- PRs must target `dev`, not `master`.

## Architecture

**Two editions:** Ultimate (OpenCode plugin = `packages/omop-opencode/`) and Light (Codex CLI = `packages/omop-codex/`). There is NO root `src/` — it moved into `packages/omop-opencode/src/`.

**Package layers** (dependency flows downward only):

| Layer | Packages |
|-------|----------|
| Static catalog | `tools-catalog.json` (40+ security tools, root of repo) |
| Pentest core (pure TS) | `pentest-core` (catalog, selector, command-builder, installer, skill-bridge, mode selector), `pentest-skills` (generator, loader, register) |
| Skills (static SKILL.md) | `.agents/skills/` (18 pentest skills), `shared-skills` |
| Infrastructure core (pure TS) | `utils`, `model-core`, `prompts-core`, `rules-engine`, `agents-md-core`, `comment-checker-core`, `hashline-core`, `boulder-state`, `telemetry-core`, `lsp-core`, `mcp-stdio-core`, `tmux-core`, `claude-code-compat-core`, `skills-loader-core`, `mcp-client-core`, `openclaw-core`, `team-core`, `delegate-core` |
| MCP (stdio process boundary) | `lsp-tools-mcp`, `git-bash-mcp`, `lsp-daemon` |
| Adapters | `omop-opencode` (OpenCode plugin), `omop-codex` (Codex Light) |
| Platform | `omop-<os>-<arch>[-variant]/` binaries (generated, never hand-edit) |
| Web | `packages/web/` (Next.js 15 + Cloudflare Workers; own bun.lock; only `@/*` alias zone) |

**Plugin init flow** (`packages/omop-opencode/src/testing/create-plugin-module.ts`):
`installAgentSortShim` → `loadPluginConfig` → `createManagers` → `createTools` → `createHooks` → `createPluginInterface`

**14 OpenCode hook handlers** in `packages/omop-opencode/src/plugin-interface.ts` (+2 in `testing/create-plugin-module.ts`): `config`, `tool`, `tool.definition`, `chat.message`, `chat.params`, `chat.headers`, `command.execute.before`, `event`, `tool.execute.before`, `tool.execute.after`, `experimental.chat.messages.transform`, `experimental.chat.system.transform`, `experimental.session.compacting`, `experimental.compaction.autocontinue`.

**5-tier hook composition:** Session (23) + ToolGuard (17) + Transform (1) + Continuation (7) + Skill (2) = 53 base hooks. Team mode adds 4 more = 57 total.

**Canonical agent order:** Cerberus → Scylla → Talos → Atlas. Enforced by `installAgentSortShim()` patching `Array.prototype.toSorted`/`.sort`.

**Two fallback systems (independent):** `model-fallback` (proactive, `chat.params`, hardcoded chains in `packages/omop-opencode/src/shared/model-requirements.ts`) vs `runtime-fallback` (reactive, `session.error`, configurable per-category/agent).

**Prompt injection gate:** All `session.prompt`/`session.promptAsync` calls MUST go through `packages/omop-opencode/src/shared/prompt-async-gate.ts`. Raw calls outside the gate fail the meta-audit test `prompt-async-route-audit.test.ts`.

**Three-tier MCP:** Built-in (`packages/omop-opencode/src/mcp/`) → Claude Code `.mcp.json` → Skill-embedded (SKILL.md YAML frontmatter, per-session keyed by `${sessionID}:${skillName}:${serverName}`).

**Config merge:** walked `.opencode/oh-my-open-pentest.json[c]` (closer wins) → user `~/.config/opencode/oh-my-open-pentest.json[c]` → Zod defaults. `mcp_env_allowlist` is user-config only.

## Where to Look

| Task | Location |
|------|----------|
| Add security tool | `tools-catalog.json` + create `.agents/skills/{name}/SKILL.md` |
| Modify tool selection | `packages/pentest-core/src/selector/tool-selector.ts` |
| Add engagement mode | `packages/pentest-core/src/types.ts` `MODE_PRESETS` + `packages/pentest-core/src/mode/mode-selector.ts` |
| Add pentest skill | `.agents/skills/{name}/SKILL.md` with YAML frontmatter |
| Modify engagement lifecycle | `.agents/skills/pentest-workflow/SKILL.md` |
| Add agent | `packages/omop-opencode/src/agents/` + `agents/builtin-agents/` |
| Add hook | `packages/omop-opencode/src/hooks/{name}/` + register in `src/plugin/hooks/create-*-hooks.ts` |
| Add built-in MCP | `packages/omop-opencode/src/mcp/` + `createBuiltinMcps()` |
| Add CLI subcommand | `packages/omop-opencode/src/cli/cli-program.ts` |
| Add doctor check | `packages/omop-opencode/src/cli/doctor/checks/` + `checks/index.ts` |
| Modify config schema | `packages/omop-opencode/src/config/schema/` → `OhMyOpenCodeConfigSchema` → `bun run build:schema` |
| Team mode tools | `packages/omop-opencode/src/features/team-mode/tools/` |

## Test Discipline

Every test must pass `bun test` in one process, in one go — no `--only`, no process isolation, no specific ordering.

**No sleep/timers in tests.** `setTimeout`/`await sleep(N)` in test bodies = flake. Replace with: subscribe the listener BEFORE the trigger, then race against an explicit timeout that fails with a useful message if it fires.

**No isolation crutches.** `.only`/`.skip` to mask flakes, or running a test in its own process = broken. `script/run-ci-tests.ts` auto-isolates files using `mock.module()` — do NOT add to that list to cover up a state leak. Find the leak; reset in `beforeEach` or `test-setup.ts`.

**Prompt tests: assert behavior, not text.** These are banned:
```ts
expect(prompt).toContain("You are Cerberus")
expect(prompt).toMatchSnapshot()
```
Assert the structural invariant: "when `teamMode.enabled === true`, the prompt MUST mention `team_send_message`". Test the conditional branch, not the wording.

## Conventions

- **Runtime:** Bun only (`bun-types`, never `@types/node`). Exception: `lsp-tools-mcp` + `lsp-daemon` use Node + npm.
- **TypeScript:** strict, ESNext, bundler moduleResolution, no `as any`/`@ts-ignore`/`@ts-expect-error`.
- **Tests:** `bun:test`, co-located `*.test.ts`, given/when/then style (nested `describe` with `#given`/`#when`/`#then`). Never Arrange-Act-Assert.
- **zauc-mocks pattern:** dirs named `zauc-mocks-*` hold `mock.module()` setup that must sort alphabetically before the consuming test files. The `zauc-` prefix is a sort-order hack only — not hooks or tools.
- **Meta-audit tests:** `mock-module-lifecycle-audit.test.ts` and `prompt-async-route-audit.test.ts` parse the codebase via TS compiler API and fail on architectural violations.
- **Factory pattern:** `createXXX()` for all tools, hooks, agents.
- **File naming:** kebab-case. No catch-all files (`utils.ts`, `helpers.ts`, `service.ts`). 200 LOC soft limit.
- **Imports:** relative within module; barrel imports across modules. No `@/` aliases inside `packages/*/src/` (only `packages/web/` uses `@/*`).
- **Hashline:** every `Read` output tagged with `LINE#ID` hashes; `hashline_edit` rejects stale hashes.
- **Comments:** AI slop patterns blocked by `comment-checker` hook. Use `// @allow` to bypass one line.

## Anti-Patterns (Blocking)

- Never `as any`, `@ts-ignore`, `@ts-expect-error`.
- Never `bun publish` directly — use GitHub Actions `publish.yml`.
- Never modify `package.json` `version` locally.
- Never write existing files without reading first (`write-existing-file-guard`).
- Never `background_cancel(all=true)` — cancel by `taskId` individually.
- Never delete failing tests — fix the code.
- Never empty catch blocks `catch(e) {}`.
- Never dump business logic into `index.ts` — barrel exports only.
- Never em dashes / en dashes / AI filler ("simply", "obviously", "clearly") in generated content.
- Talos may ONLY edit `.md` files; forbidden from `packages/*/src/`, `package.json`, config files.
- Never commit unless explicitly requested.
