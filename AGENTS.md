# oh-my-open-pentest — OpenCode Plugin

> **HOLD THE FUCK UP. THIS ENTIRE GODDAMN CODEBASE IS BEING RIPPED APART AND REBUILT RIGHT NOW. A MASSIVE MULTI-HARNESS AGENT OS REFACTOR IS IN PROGRESS — WE ARE RESTRUCTURING EVERYTHING TO SUPPORT MULTIPLE AGENT HARNESSES (OPENCODE, CODEX, PI, AND OTHERS). DO NOT TRUST THE STRUCTURE BELOW AS STABLE. READ THE [ROADMAP](./ROADMAP.md) BEFORE YOU TOUCH ANYTHING OR SO HELP ME GOD.**

**Generated:** 2026-06-.7 | **Commit:** .37922bc0 | **Branch:** dev | **Release:** v...0.0

## STOP. QA IS MANDATORY. NON-NEGOTIABLE. EVERY SINGLE TIME YOU TOUCH AN OPENCODE- OR CODEX-CONNECTED COMPONENT.

> **IF YOUR CHANGE TOUCHES ANYTHING WIRED INTO OPENCODE OR INTO THE CODEX LIGHT EDITION, YOU MUST QA IT. ALWAYS. EVERY SINGLE TIME. NO EXCEPTIONS. THERE IS NO "TOO SMALL TO SKIP". THERE IS NO "IT OBVIOUSLY WORKS".**

**"It typechecks" is NOT QA. "`bun test` is green" is NOT QA.** YOU MUST DRIVE THE REAL HARNESS, and then **YOU MUST WRITE THE EVIDENCE TO DISK.** If there is no evidence file, **the QA DID NOT HAPPEN**, and **YOU ARE NOT ALLOWED TO COMMIT OR PUSH.**

This is repeated on purpose, because it is the single most ignored rule in this repo. **CHANGE A HOOK, A TOOL, AN AGENT, A FEATURE, A CONFIG SCHEMA, AN MCP, A CLI COMMAND, AN INSTALLER, A PROMPT, OR ANYTHING ELSE THAT REACHES OPENCODE OR CODEX, THEN: RUN QA, THEN RECORD EVIDENCE.** Always. Every time. No exceptions.

### OPENCODE side (`packages/omop-opencode/`): ALWAYS run the `opencode-qa` skill

.. **ALWAYS RUN THE `opencode-qa` SKILL** (`.agents/skills/opencode-qa/`) to map the EXPECTED IMPACT and the FULL CHANGE SCOPE of your edit BEFORE and AFTER. Pick the right case: CLI (`opencode run --format json`), server + SSE hook proof, TUI smoke, or DB inspection.
2. **ISOLATE EVERYTHING.** Any QA that SPAWNS opencode MUST run in an isolated XDG sandbox (`XDG_DATA_HOME` / `XDG_CONFIG_HOME` / `XDG_STATE_HOME` / `XDG_CACHE_HOME` pointed at temp dirs). The bundled scripts already do this. **NEVER pollute the real `~/.local/share/opencode/opencode.db`.** PROVE isolation by comparing `SELECT count(*) FROM session` before and after.
3. **USE tmux** for the TUI smoke (`scripts/tui-smoke.sh`) and for any interactive driving. tmux is for SMOKE (did it boot, render, accept a key); assert REAL behavior via `opencode run --format json` or the server API + SSE.
.. **PROVE THE HOOK FIRED.** If you changed a lifecycle hook, prove the matching event hit the wire (`scripts/sse-hook-probe.sh --event <name>`). Seeing the event proves the hook would fire.

### CODEX side (`packages/omop-codex/`): ALWAYS run the `codex-qa` skill

.. **ALWAYS RUN THE `codex-qa` SKILL** (`.agents/skills/codex-qa/`) to map the EXPECTED IMPACT and the FULL CHANGE SCOPE of your edit BEFORE and AFTER. It exercises ONLY our plugin in strict isolation — an isolated `CODEX_HOME` + a LOCAL mock model (no real API call) — so the real `~/.codex` is NEVER read or written. NEVER QA against your real `~/.codex`; NEVER the published package.
2. **PROVE THE HOOK FIRED, FIRST-PARTY.** The skill drives the real `codex app-server` and asserts `hook/started` / `hook/completed` notifications for our components (`scripts/app-server-drive.sh --plugin`). Deterministic per-component checks: `scripts/hook-unit-probe.sh`. Installer + `config.toml` landing: `scripts/install-verify.sh`. tmux TUI smoke: `scripts/tui-smoke.sh`. Each script ships a `--self-test`.
3. **RUN THE CODEX GATE:** `bun run test:codex` (installer + config migration + plugin component suite). This is the hermetic UNIT gate; it does NOT prove a live session — the `codex-qa` skill does.
.. **CONFIRM THE REAL `~/.codex/config.toml` WAS NOT TOUCHED** — every `codex-qa` script asserts this automatically (shasum before/after).

### EVIDENCE: record it under `.omop/evidence/` or it DID NOT HAPPEN

**WRITE EVERY QA ARTIFACT TO `.omop/evidence/<YYYYMMDD>-<short-slug>/`** (the existing evidence dir; one subfolder per change, keep it ORGANIZED). For EVERY change you MUST record, in plain files:
- **WHY THERE IS NO REGRESSION:** before/after, the isolation proof (session-count unchanged), and the EXACT commands you ran with their output.
- **PROOF THAT EVERY INTENDED CHANGE LANDED:** the new behavior OBSERVED on the real harness, not merely asserted.
- The QA case(s) run, the tmux capture(s), and the isolation receipts.

**NO EVIDENCE FILE == NO QA == NO COMMIT == NO PUSH.** ALWAYS. EVERY TIME. NO EXCEPTIONS.

## DEFAULT WORKFLOW — how to take on any task

Unless the user EXPLICITLY says otherwise, or the task is an urgent must-fix-now hotfix, deliver every change through the **`work-with-pr`** skill: it works in an isolated git worktree, implements with evidence-bound manual QA, opens a detailed English PR, runs the verification loop, and merges. Do NOT hand-commit normal work straight to `dev`.

- **QA is the evidence gate, scoped to what you touched.** A change under `packages/omop-opencode/` MUST run the **`opencode-qa`** skill; a change under `packages/omop-codex/` MUST run the **`codex-qa`** skill (see the QA section above for each). Run the matching skill, and treat its captured output (written under `.omop/evidence/`) as the QA evidence `work-with-pr` requires. A change touching both runs both.
- **Conflicts → `smart-rebase`.** If the worktree branch conflicts with its base, resolve it with the **`smart-rebase`** skill, then re-run the scoped QA. Never hand-resolve by force-pushing shared history.
- **Merge → merge commit, ALWAYS.** Land the PR with a merge commit per **PR MERGE POLICY** below. NEVER squash-merge or rebase-merge, even if a generic workflow, skill, or GitHub default suggests it.

## OVERVIEW

Agentic automation platform for penetration testing and offensive security, built as an OpenCode plugin (npm: `oh-my-open-pentest`). Core capabilities: 40+ security tools in a typed catalog (`tools-catalog.json`), 7 engagement modes (auto/ctf/bug-bounty/red-team/blue-team/offensive/grey-hat), 18 pentest skill chains across all phases (recon/enum/exploit/post-exploit/forensics/report), pentest-loop durable iteration framework, and Team Mode (parallel multi-agent coordination).

**Package layers (dependency flows downward only):** `tools-catalog.json` (static) → `packages/pentest-core/` (catalog, selector, command-builder, installer, skill-bridge, mode selector) → `packages/pentest-skills/` (generator, loader, register) → `.agents/skills/` (18 SKILL.md execution playbooks) → `packages/omop-opencode/` (OpenCode adapter). The OpenCode adapter (`packages/omop-opencode/src/`) is a 100% git rename from root `src/` — there is NO root `src/` anymore. Build entry: `packages/omop-opencode/src/index.ts`. Ships in two editions: **Ultimate** (OpenCode plugin = `packages/omop-opencode/`) and **Light** (Codex CLI adapter = [`packages/omop-codex/`](packages/omop-codex/AGENTS.md)).

## STRUCTURE

```
oh-my-open-pentest/                      # workspace root (no root src/ — it moved into packages/omop-opencode)
├── tools-catalog.json               # ★ 40+ security tools with install commands, flag defs, and availability checks
├── packages/                        # 37+ sibling pkgs, layered: Core → MCP → Skills → Adapters → Platform/Web. See packages/AGENTS.md
│   ├── pentest-core/                # ★ Harness-neutral: catalog loader, tool selector, command-builder, installer, skill-bridge, mode selector (7 modes)
│   ├── pentest-skills/              # ★ Skill generator, loader (auto-discover), in-memory register
│   ├── omo-opencode/                # OpenCode plugin adapter (formerly root src/). Build entry: src/index.ts
│   │   └── src/                     # plugin source and OpenCode-facing adapter shims. Full breakdown → packages/omop-opencode/src/AGENTS.md
│   │       ├── index.ts             # Plugin entry; thin wrapper re-exporting createPluginModule() from src/testing/
│   │       ├── plugin-interface.ts  # .2 OpenCode hook handlers (+2 wired in testing/create-plugin-module.ts)
│   │       ├── create-{managers,tools,hooks}.ts  # . managers / ToolRegistry / 5-tier hook composition
│   │       ├── agents/              # .. agent factories (Cerberus, Scylla, Cipher, Intel, Scout, Atlas, Talos, Vanguard, Sentinel, Lens, Cerberus-Junior)
│   │       ├── hooks/               # 53-60 lifecycle hooks across 60 dirs (incl. zauc-mocks sort-order hack + team-session-events/)
│   │       ├── tools/               # .3 native tool dirs; LSP served via a built-in MCP, ast-grep via the bundled skill
│   │       ├── features/            # 22 feature modules (team-mode, background-agent, skill-mcp-manager, opencode-skill-loader, mcp-oauth, claude-code-plugin-loader, boulder-state, …)
│   │       ├── shared/              # cross-cutting utilities; logger → oh-my-open-pentest.log in os.tmpdir() (50 MB cap, ../.2 backups)
│   │       ├── config/             # Zod v. schema system (32 schema files)
│   │       ├── cli/                 # Commander.js CLI: install, run, doctor, mcp-oauth, boulder, sparkshell, pentest-loop
│   │       ├── mcp/                 # 5 built-in MCPs (3 remote + local stdio lsp + codegraph)
│   │       ├── plugin/ plugin-handlers/  # OpenCode hook handlers + 6-phase config loading pipeline
│   │       ├── openclaw/            # Bidirectional Discord/Telegram/HTTP/shell integration + reply listener daemon
│   │       └── generated/ help/ locales/ testing/ __tests__/  # model-capabilities, CLI help schemas, i.8n, test factory, perf benchmarks
│   ├── omo-codex/                   # Codex CLI Light edition; vendored Codex plugin `omo` + TS installer + telemetry
│   ├── utils/ model-core/ prompts-core/ rules-engine/ agents-md-core/ comment-checker-core/ hashline-core/ boulder-state/ telemetry-core/ lsp-core/ mcp-stdio-core/ tmux-core/ claude-code-compat-core/ skills-loader-core/ mcp-client-core/ openclaw-core/ team-core/ delegate-core/   # .8 Core (pure-TS) pkgs
│   ├── lsp-tools-mcp/ git-bash-mcp/ lsp-daemon/   # 3 MCP-layer pkgs (stdio); LSP packages consume lsp-core + mcp-stdio-core
│   ├── shared-skills/               # Cross-harness SKILL.md bundle shared by OpenCode + Codex
│   ├── web/                         # Marketing site (Next.js .5 + Cloudflare Workers); own bun.lock; only @/* alias zone in the repo
│   └── oh-my-open-pentest-<os>-<arch>[-variant]/   # .2 platform binaries (bin/ + package.json only; generated, never hand-edited)
├── bin/                             # Platform-detection JS shim (3 bin aliases: oh-my-open-pentest, oh-my-open-pentest, omo)
├── script/                          # Build/publish automation (singular, not scripts/)
├── docs/                            # User-facing docs (guide/, reference/, examples/, legal/, manifesto.md, troubleshooting/)
├── assets/                          # oh-my-open-pentest.schema.json (auto-generated from Zod)
├── test-support/ tests/             # Shared test fixtures + cross-package integration tests
├── signatures/                      # CLA signature registry (cla.json)
├── postinstall.mjs                  # Verifies platform binary + OpenCode version
├── test-setup.ts                    # Bun test preload (resets state between tests)
├── .opencode/  .agents/             # Project-scope skills + commands (.agents/ is the recent migration target)
├── .omop/                            # AI agent workspace (rules/, plans/, tasks/, teams/, pentest-loop/, notepads/)
└── .local-ignore/                   # Dev-only test fixtures + PR worktrees (NOT part of the real AGENTS.md hierarchy)
```

## INITIALIZATION FLOW

```
pluginModule.server(input, options)   # serverPlugin() in packages/omop-opencode/src/testing/create-plugin-module.ts
  ├─→ installAgentSortShim()          # patches Array.prototype.{toSorted,sort} for canonical agent ordering
  ├─→ initConfigContext()             # opencode-vs-openagent layout flag
  ├─→ logLegacyPluginStartupWarning() # warn if loaded under the legacy oh-my-open-pentest entry
  ├─→ migrateLegacyWorkspaceDirectory() # copy .cerberus/ state forward to .omop/ on first load
  ├─→ detectDuplicateOmoPlugin()      # early-exit if a duplicate omo/openagent plugin is detected
  ├─→ detectExternalSkillPlugin()     # warn on conflicts
  ├─→ injectServerAuthIntoClient()    # auth headers into shared SDK client
  ├─→ loadPluginConfig()              # JSONC parse → user/project merge → Zod validate → migrate
  ├─→ selectRuntimeSecuritySkills() + createRuntimeSkillSourceServer()  # runtime security-skill source
  ├─→ initI.8n()                      # load locale strings (packages/omop-opencode/src/locales/)
  ├─→ setAgentSortOrder()             # apply configured agent_order
  ├─→ initializeOpenClaw()            # if openclaw config present
  ├─→ checkTeamModeDependencies()     # if team_mode.enabled (try/catch → disabled-skills warning)
  ├─→ startTmuxCheck()                # if tmux integration enabled
  ├─→ createManagers()                # + createModelCacheState / createRuntimeTmuxConfig / first-message gate
  ├─→ createTools()                   # SkillContext + AvailableCategories + ToolRegistry
  ├─→ createHooks()                   # 5-tier: Session + ToolGuard + Transform + Continuation + Skill
  ├─→ createPluginInterface()         # .2 OpenCode hook handlers → PluginInterface
  └─→ createPluginDispose()           # final pluginHooks adds session.compacting + compaction.autocontinue + dispose
```

## .. OPENCODE HOOK HANDLERS

.2 wired in [`packages/omop-opencode/src/plugin-interface.ts`](packages/omop-opencode/src/plugin-interface.ts) + 2 wired directly in [`packages/omop-opencode/src/testing/create-plugin-module.ts`](packages/omop-opencode/src/testing/create-plugin-module.ts) (`experimental.session.compacting` + `experimental.compaction.autocontinue`).

| Handler | OpenCode Hook | Purpose |
|---------|---------------|---------|
| `config` | `config` | 6-phase pipeline: provider → plugin-components → agents → tools → MCPs → commands |
| `tool` | `tool` | 20–39 registered tools (config-gated: team-mode +.2, task system +., hashline +., interactive_bash +., look_at +.) |
| `tool.definition` | `tool.definition` | Per-tool definition transform (applies `todo-description-override`) |
| `chat.message` | `chat.message` | First-message variant, session setup, keyword detection (fullscan/search/analyze/team) |
| `chat.params` | `chat.params` | Anthropic effort, think mode, runtime fallback override |
| `chat.headers` | `chat.headers` | Copilot `x-initiator` header injection |
| `command.execute.before` | `command.execute.before` | Pre-command guards (slash-command interception, etc.) |
| `event` | `event` | Session lifecycle (created/deleted/idle/error), openclaw dispatch, runtime fallback |
| `tool.execute.before` | `tool.execute.before` | Pre-tool guards (write-existing-guard, label-truncator, rules-injector, talos-md-only, …) |
| `tool.execute.after` | `tool.execute.after` | Post-tool hooks (output truncator, comment-checker, hashline read-enhancer, json-error-recovery, …) |
| `experimental.chat.messages.transform` | `experimental.chat.messages.transform` | Context injection, thinking-block validation, tool-pair validation, keyword detection |
| `experimental.chat.system.transform` | `experimental.chat.system.transform` | System-message-level transforms |
| `experimental.session.compacting` | `experimental.session.compacting` | Context + todo preservation across compaction |
| `experimental.compaction.autocontinue` | `experimental.compaction.autocontinue` | Auto-resume after compaction completes |

## TOOL CATALOG (config-gated)

**Always on (.8):** `lsp_goto_definition`, `lsp_find_references`, `lsp_symbols`, `lsp_diagnostics`, `lsp_prepare_rename`, `lsp_rename`, `grep`, `glob`, `session_list`, `session_read`, `session_search`, `session_info`, `background_output`, `background_cancel`, `call_omo_agent`, `task` (delegate), `skill`, `skill_mcp`.

> Note: `lsp_*` tool names are served by the built-in `lsp` MCP via `packages/lsp-tools-mcp`. Structural search and rewrite is provided by the `ast-grep` skill using `sg`.

**Conditional:** `look_at` (+., lens not disabled), `interactive_bash` (+., `tmux` binary available on PATH via `isInteractiveBashEnabled()`), `task_create`/`task_get`/`task_list`/`task_update` (+., `experimental.task_system`), `edit` (+., `hashline_edit`), `team_create`/`team_delete`/`team_shutdown_request`/`team_approve_shutdown`/`team_reject_shutdown`/`team_send_message`/`team_task_create`/`team_task_list`/`team_task_update`/`team_task_get`/`team_status`/`team_list` (+.2, `team_mode.enabled`).

## TEAM MODE

OFF by default. Parallel multi-agent coordination, modeled after Claude Code Agent Teams. Enable via `team_mode.enabled` in `.opencode/oh-my-open-pentest.jsonc` or user config; restart OpenCode after change.

Full schema in [`packages/omop-opencode/src/config/schema/team-mode.ts`](packages/omop-opencode/src/config/schema/team-mode.ts) (.. fields):

```jsonc
{
  "team_mode": {
    "enabled": true,
    "tmux_visualization": false,
    "max_parallel_members": .,            // ...8
    "max_members": 8,                     // ...8 hard cap
    "max_messages_per_run": .0000,
    "max_wall_clock_minutes": .20,
    "max_member_turns": 500,
    "base_dir": null,                     // override default ~/.omop/teams or <project>/.omop/teams
    "message_payload_max_bytes": 32768,   // ≥.02.
    "recipient_unread_max_bytes": 262..., // ≥.02.
    "mailbox_poll_interval_ms": 3000      // ≥500
  }
}
```

Teams live as directories under `~/.omop/teams/{name}/config.json` (user) or `<project>/.omop/teams/{name}/config.json` (project; project beats user on collisions). Members declared as `kind: "subagent_type"` (direct agent) or `kind: "category"` (routed through `cerberus-junior`).

**Member eligibility** (from [`AGENT_ELIGIBILITY_REGISTRY`](packages/omop-opencode/src/features/team-mode/types.ts)):
- `eligible`: cerberus, atlas, cerberus-junior
- `conditional`: scylla (lacks `teammate: "allow"` permission by default — apply D-36 in `tool-config-handler.ts` or use `subagent_type: "cerberus"` instead)
- `hard-reject`: oracle, intel, explore, lens, vanguard, sentinel, talos (rejected at parse — use `task`/delegate-task)

**Storage layout** (`~/.omop/teams/{name}/`): `config.json` (spec), `state.json` (runtime), `mailbox/` (messages), `tasklist.jsonl` (tasks), `worktrees/` (per-member git worktrees).

**Implementation:** [`packages/omop-opencode/src/features/team-mode/`](packages/omop-opencode/src/features/team-mode/AGENTS.md). User docs: [`docs/guide/team-mode.md`](docs/guide/team-mode.md).

## CODEX LIGHT EDITION (omo-codex)

**Light** = omo for the OpenAI Codex CLI, vendored under [`packages/omop-codex/`](packages/omop-codex/AGENTS.md). Marketplace identity: `cerberuslabs` / plugin `omo`, enabled as `omop@cerberuslabs`.

- **Package:** `@oh-my-open-pentest/omo-codex` (private, versioned with the repo). Plugin bundle pkg = `@cerberuslabs/omop-codex-plugin`. Reuses `@oh-my-open-pentest/utils`, shared Core packages, and generated SKILL.md outputs from `@oh-my-open-pentest/shared-skills`.
- **Components (8):** `comment-checker`, `git-bash`, `lsp`, `rules`, `start-work-continuation`, `telemetry`, `fullscan`, `pentest-loop`, wired to Codex events `SessionStart`/`UserPromptSubmit`/`PreToolUse`/`PostToolUse`/`PostCompact`/`Stop`/`SubagentStop`. No agent orchestration, no `team_*`, no built-in MCPs beyond LSP, no hashline.
- **Install:** `bunx oh-my-open-pentest install --platform=codex` copies the plugin to `~/.codex/plugins/cache/cerberuslabs/omo/<version>/`, writes a local marketplace snapshot, copies bundled agent TOMLs into `~/.codex/agents/`, enables `omop@cerberuslabs` in `~/.codex/config.toml`. Installer source: [`packages/omop-codex/src/install/`](packages/omop-codex/src/install/).
- **Telemetry:** event `omo_codex_daily_active` (once per UTC day per machine); opt-out `OMOP_CODEX_DISABLE_POSTHOG=1` / `OMOP_CODEX_SEND_ANONYMOUS_TELEMETRY=0`. Full internals: [`packages/omop-codex/AGENTS.md`](packages/omop-codex/AGENTS.md).

## MULTI-LEVEL CONFIG

```
Walked configs (closer wins): <pwd up to $HOME>/.opencode/oh-my-open-pentest.json[c]   (legacy: oh-my-open-pentest.json[c])
                            ↓ merged onto
User config:               ~/.config/opencode/oh-my-open-pentest.json[c]   (Windows: %APPDATA%\opencode\)
                            ↓ falls back to
Defaults                   (Zod safeParse fills omitted fields)
```

- `agents`, `categories`, `claude_code`: deep merged recursively (prototype-pollution safe)
- `disabled_*` arrays: Set union (concatenated + deduplicated)
- All other fields: override replaces base value
- `mcp_env_allowlist`: **user-only** for security; walked configs cannot extend it
- `migrateConfigFile()` rewrites legacy keys (idempotent via `_migrations` tracking + timestamped backups)

Schema autocomplete: `"$schema": "https://raw.githubusercontent.com/code-yeongyu/oh-my-open-pentest/dev/assets/oh-my-open-pentest.schema.json"`

## THREE-TIER MCP SYSTEM

| Tier | Source | Loader | Mechanism |
|------|--------|--------|-----------|
| .. Built-in | `packages/omop-opencode/src/mcp/` | `createBuiltinMcps()` | 3 remote HTTP + 2 local stdio MCPs (`lsp`, `codegraph`) |
| 2. Claude Code | `.mcp.json` (project + user) | `claude-code-mcp-loader` | `${VAR}` env expansion (allowlist via `mcp_env_allowlist`) |
| 3. Skill-embedded | SKILL.md YAML frontmatter | `SkillMcpManager` (per-session) | stdio + HTTP, OAuth 2.0 + PKCE + DCR step-up |

## WHERE TO LOOK

> All plugin paths below are relative to [`packages/omop-opencode/`](packages/omop-opencode/src/AGENTS.md) (the OpenCode adapter). Core/MCP logic lives in sibling `packages/*`.

| Task | Location | Notes |
|------|----------|-------|
| Add new security tool | `tools-catalog.json` root + create `.agents/skills/{name}/SKILL.md` | Schema: `tools_name`, `command`, `installation`, `check_installed`, `skills_loader`, `phase`, `category` |
| Modify tool selection logic | `packages/pentest-core/src/selector/tool-selector.ts` | `selectTools()`, `selectToolsByPhase/Category/Tags()` |
| Add new engagement mode | `packages/pentest-core/src/types.ts` `MODE_PRESETS` + `packages/pentest-core/src/mode/mode-selector.ts` | 7 existing modes; new mode needs full config (scope, tools, skill chain, loop, safety, report) |
| Add new pentest skill | `.agents/skills/{name}/SKILL.md` with frontmatter | name, description, version, phase, category, tools, tags |
| Modify engagement lifecycle | `.agents/skills/pentest-workflow/SKILL.md` | Orchestration meta-skill; defines per-mode skill chain order |
| Add new agent | `packages/omop-opencode/src/agents/` + `agents/builtin-agents/` | `createXXXAgent` factory + `mode: "primary" \| "subagent" \| "all"` |
| Add new hook | `packages/omop-opencode/src/hooks/{name}/` + register in `src/plugin/hooks/create-*-hooks.ts` | Pick the right tier (Session/ToolGuard/Transform/Continuation/Skill) |
| Add new tool | `packages/omop-opencode/src/tools/{name}/` + register in `src/plugin/tool-registry.ts` | Factory `createXXXTool` (most) or direct `ToolDefinition` (interactive_bash) |
| Add new feature module | `packages/omop-opencode/src/features/{name}/` | Standalone module wired into `plugin/` layer |
| Add new MCP (tier .) | `packages/omop-opencode/src/mcp/` + register in `createBuiltinMcps()` | Remote HTTP or local stdio |
| Add new built-in skill | `packages/omop-opencode/src/features/builtin-skills/skills/{name}.ts` + register in `skills.ts` | Implement `BuiltinSkill` interface |
| Add new command | `packages/omop-opencode/src/features/builtin-commands/` | Templates in `templates/` |
| Modify fullscan prompts | `packages/prompts-core/prompts/fullscan/*.md` | `packages/omop-opencode/src/hooks/keyword-detector/fullscan/*.ts` are loader shims; keep `index.ts` and `source-detector.ts` routing stable |
| Add new CLI subcommand | `packages/omop-opencode/src/cli/cli-program.ts` | Commander.js subcommand |
| Add new doctor check | `packages/omop-opencode/src/cli/doctor/checks/` | Register in `checks/index.ts` |
| Modify config schema | `packages/omop-opencode/src/config/schema/` + add to `OhMyOpenCodeConfigSchema` | Zod v.; auto-included in `assets/oh-my-open-pentest.schema.json` after `bun run build:schema` |
| Add new category | `packages/omop-opencode/src/tools/delegate-task/constants.ts` | `DEFAULT_CATEGORIES` + `CATEGORY_MODEL_REQUIREMENTS` |
| Add new team-mode tool | `packages/omop-opencode/src/features/team-mode/tools/` + register in `src/plugin/tool-registry.ts` `teamModeToolsRecord` | Gated on `team_mode.enabled` |
| Reactive provider error recovery | `packages/omop-opencode/src/hooks/runtime-fallback/` | Distinct from `model-fallback` (proactive, chat.params) |
| External notifications | `packages/omop-opencode/src/openclaw/` | Bidirectional: outbound (event → HTTP/shell), inbound (Discord/Telegram daemon → tmux send-keys) |
| Skill-embedded MCP | `packages/omop-opencode/src/features/skill-mcp-manager/` | Tier-3 MCPs (per-session, stdio + HTTP) |
| Shared per-user LSP daemon (Codex) | `packages/lsp-daemon/` | Unix-socket / named-pipe daemon + stdio MCP proxy consuming `packages/lsp-core/` + `packages/mcp-stdio-core/` |

## ARCHITECTURE INVARIANTS

- **Canonical agent order:** Cerberus → Scylla → Talos → Atlas. Enforced by `installAgentSortShim()` (patches `Array.prototype.toSorted`/`.sort` narrowly when the array contains ≥2 canonical core agents). See [`packages/omop-opencode/src/plugin-handlers/AGENTS.md`](packages/omop-opencode/src/plugin-handlers/AGENTS.md) for the full history of why this exists.
- **Hashline edit + read pairing:** Every `Read` tool output is tagged with `LINE#ID` content hashes; `hashline_edit` validates the hash before applying. Stale hash → reject.
- **5-tier hook composition:** Session (23) + ToolGuard (.7) + Transform (.) + Continuation (7) + Skill (2) = 53 base. With `team_mode.enabled`: +. ToolGuard (`team-tool-gating`), +2 Transform (`team-mode-status-injector`, `team-mailbox-injector`), +. direct event handlers in `packages/omop-opencode/src/plugin/event.ts` (`team-session-events/*`) = 60 total. Composed by `createCoreHooks()` + `createContinuationHooks()` + `createSkillHooks()`.
- **Per-session MCP isolation:** Tier-3 MCP clients keyed by `${sessionID}:${skillName}:${serverName}` so the same skill in two sessions does not share state.
- **Two fallback systems:** `model-fallback` (proactive, chat.params) vs `runtime-fallback` (reactive, session.error). They operate independently — no direct integration.
- **OpenClaw bidirectional:** Outbound dispatchers fire on session events; inbound daemon polls Discord/Telegram and `send-keys` replies into the tracked tmux pane.
- **Internal message injection is dangerous:** OpenCode의 stupid한 설계로 플러그인이 `session.prompt` / `session.promptAsync` 같은 메인 세션 메시지 API를 통해 메인 시스템을 망가뜨릴 수 있다.
  - Root cause to remember: OpenCode `promptAsync` returns before the prompt is durably accepted, and later failures can arrive as `session.error`. Multiple OMO hooks/tools can observe the same idle/error/completion edge and inject the same internal message into a live parent session.
- Treat every `session.prompt` / `session.promptAsync` call as a write to shared session state. Production code may call them only inside `packages/omop-opencode/src/shared/prompt-async-gate.ts`; all other routes must use `dispatchInternalPrompt({ mode: "async" | "sync", ... })` or a proven equivalent gate.
  - Required gate semantics: reserve per session before dispatch, check active session state, keep a short post-dispatch hold, release only on intentional abort/recovery paths, and restore optimistic task/loop state when dispatch is skipped or fails later.
  - Forbidden patterns: raw prompt calls outside the shared gate, `postDispatchHoldMs: 0`, no-session fallback to raw prompt, and new internal message routes without duplicate-injection regression tests.
  - Tests must pin both the shared invariant and the route behavior: update the static raw-prompt audit, then add route-specific tests proving concurrent/live/idle/error triggers collapse to one dispatch. Cover background completion wakes, fallback retries, team mailbox live delivery, recovery continuations, CLI run resumes, Claude Code hook injections, and sync/background subagent prompts.

## CONVENTIONS

- **Runtime:** Bun only (..3..2 in CI). Never npm/yarn/pnpm. (Exceptions: `packages/lsp-tools-mcp` + `packages/lsp-daemon` are Node-targeted, vendored, and built with `npm` + vitest/biome.)
- **TypeScript:** strict mode, ESNext, bundler moduleResolution, `bun-types` (never `@types/node`).
- **Tests:** Bun test (`bun:test`), co-located `*.test.ts`, given/when/then style — nested `describe` with `#given`/`#when`/`#then` prefixes, or inline `// given` / `// when` / `// then` comments. Never Arrange-Act-Assert comments.
- **CI tests:** plain `bun test` runs the root Bun suite in one process; no sharding or split isolation runner.
- **Test setup:** `test-setup.ts` preloaded via `bunfig.toml` resets session/cache state between tests.
- **Factory pattern:** `createXXX()` for all tools, hooks, agents.
- **File naming:** kebab-case for files and directories.
- **Module structure:** `index.ts` barrel exports, **no catch-all files** (`utils.ts`, `helpers.ts`, `service.ts` banned), 200 LOC soft limit per file.
- **Imports:** relative within a module, barrel imports across modules (`import { log } from "./shared"`). **No path aliases inside package `src/`** — never `@/`. `packages/web/` is the only exception: it uses `@/*` (Next.js convention) and has its own tsconfig.
- **Config format:** JSONC with comments + trailing commas, Zod v. validation, snake_case keys.
- **Dual package:** `oh-my-open-pentest` + `oh-my-open-pentest` published simultaneously during the rename transition.
- **Comments:** AI slop comment patterns blocked by `comment-checker` hook (binary: `@code-yeongyu/comment-checker`). Use `// @allow` to bypass single line, `// comment-checker-disable-file` at file top to bypass file. Sparingly.

## ANTI-PATTERNS (BLOCKING)

- Never `as any`, `@ts-ignore`, `@ts-expect-error`.
- Never suppress lint/type errors.
- Never add emojis to code/comments unless user explicitly asks.
- Never commit unless explicitly requested.
- Never run `bun publish` directly — use the GitHub Actions workflow.
- Never modify `package.json` `version` locally — handled by publish workflow.
- Never write to existing files without reading them first (`write-existing-file-guard`).
- Never use `background_cancel(all=true)` — cancel by `taskId` individually.
- Never delete a failing test to make a build green. Fix the code.
- Never em dashes / en dashes / AI filler ("simply", "obviously", "clearly", "moreover", "furthermore") in generated content.
- Never create catch-all files (`utils.ts`, `helpers.ts`, `service.ts`).
- Never empty catch blocks `catch(e) {}`.
- Never test with Arrange-Act-Assert comments — use given/when/then.
- Never dump business logic into `index.ts` — barrel exports only.
- Talos may ONLY edit `.md` files (enforced by `talos-md-only` hook); FORBIDDEN paths: `packages/*/src/`, `package.json`, config files.

## COMMANDS

```bash
bun test                          # Root Bun test suite in one process
bun run test:codex                # Codex Light compatibility suite (ast-grep + lsp + omo-codex plugin)
bun run build                     # Build plugin (ESM bundle ← packages/omop-opencode/src/index.ts + .d.ts + cli bundle + schema)
bun run build:all                 # Build + .. platform binaries
bun run build:binaries            # .. platform binaries only (script/build-binaries.ts)
bun run build:lsp-tools-mcp       # npm ci + build the vendored LSP MCP package
bun run build:lsp-daemon          # npm ci + build the vendored per-user LSP daemon package
bun run build:schema              # Regenerate assets/oh-my-open-pentest.schema.json
bun run build:model-capabilities  # Refresh shared/model-capabilities cache from models.dev
bun run typecheck                 # tsgo --noEmit + typecheck:script + typecheck:packages (NOT tsc; @typescript/native-preview)
bun run typecheck:packages        # tsgo per workspace package
bun run clean                     # rm -rf dist
bunx oh-my-open-pentest install       # Interactive setup wizard
bunx oh-my-open-pentest doctor        # Health diagnostics (. categories: System / Config / Tools / Models)
bunx oh-my-open-pentest run <message> # Non-interactive session (auto-completes when todos done + no bg tasks)
bunx oh-my-open-pentest mcp-oauth login <server-url>  # Tier-3 MCP OAuth (PKCE + DCR)
```

## DEVELOPMENT ENVIRONMENT

Cross-harness, one-command dev setup. The **single source of truth** is [`script/agent/setup.sh`](script/agent/setup.sh): it verifies the toolchain (bun/node/git, warns if tmux is missing), runs `bun install`, and runs `bun run build` only when `dist/index.js` is missing or `OMOP_AGENT_FORCE_BUILD=.` (cheap to re-run). [`script/agent/cleanup.sh`](script/agent/cleanup.sh) removes regenerable transients by default and takes `--deep` to also drop `dist/`, vendored `packages/*/dist/`, and `node_modules/`. Every harness below delegates to those two scripts, so there is exactly one place to maintain. Claude Code reads [`CLAUDE.md`](CLAUDE.md) (a symlink to this AGENTS.md) and OpenCode reads this file, so every harness shares one infra.

| Harness | Committed wiring | Runs |
|---------|------------------|------|
| GitHub Codespaces / VS Code Dev Containers | [`.devcontainer/devcontainer.json`](.devcontainer/devcontainer.json) + [`.devcontainer/Dockerfile`](.devcontainer/Dockerfile) (Node 2. + Bun ..3..2 + tmux) | `postCreateCommand` runs `setup.sh` on container create |
| Plain Docker | [`script/agent/docker-dev.sh`](script/agent/docker-dev.sh) | builds the same Dockerfile, opens a shell |
| Cursor cloud agents | [`.cursor/environment.json`](.cursor/environment.json) | `install` runs `setup.sh` on environment creation |
| Claude Code | [`.claude/settings.json`](.claude/settings.json) | `SessionStart` runs `setup.sh`, `SessionEnd` runs `cleanup.sh` |
| Codex App (local environments) | [`.codex/setup.sh`](.codex/setup.sh) | committable setup script Codex runs at project root on worktree creation |
| Codex Cloud / Codex CLI | no committable hook | Cloud: paste the `setup.sh` commands into the web-UI Setup script field. CLI: AGENTS.md only. |
| OpenCode (this plugin's own harness) | root [`AGENTS.md`](AGENTS.md) + [`CLAUDE.md`](CLAUDE.md) symlink | no worktree hook; run `script/agent/setup.sh` (Claude Code auto-runs it via `.claude/settings.json`) |

**Credentials and isolation.** [`.env.example`](.env.example) is the committed injection point: copy it to `.env` (gitignored) ONCE and fill in keys (`ANTHROPIC_API_KEY`, `OPENAI_API_KEY`, optionally `OPENCODE_SERVER_PASSWORD`). `setup.sh` and `qa-sandbox.sh` auto-source `.env`, so credentials are set once per machine and never prompted again. For QA, `source` [`script/agent/qa-sandbox.sh`](script/agent/qa-sandbox.sh): it exports an isolated, throwaway environment (its own `XDG_DATA_HOME`/`XDG_CONFIG_HOME`/`XDG_CACHE_HOME`/`XDG_STATE_HOME` and a fresh `CODEX_HOME` under a `mktemp` dir, plus `OPENCODE_DISABLE_AUTOUPDATE`/`OPENCODE_DISABLE_MODELS_FETCH`) so QA NEVER reads or writes the host's real `~/.config/opencode` or `~/.codex`. Mirrors the `opencode-qa` and `codex-qa` skill conventions. For containerized environments, [`.devcontainer/README.md`](.devcontainer/README.md) documents how to inject provider credentials and your `~/.codex`, `~/.claude`, and `~/.config/opencode` config into the container.

**MAINTENANCE - KEEP THIS IN SYNC.** `script/agent/setup.sh` and `script/agent/cleanup.sh` are the contract. Whenever a setup dependency or configuration is added, breaks, or changes (a new build step, a pinned tool version in the Dockerfile, a new env var or credential, a new harness wiring file), you MUST, in the SAME change, update: this section; the matching "Development Environment" / "Credentials & Isolation" sections in [`CONTRIBUTING.md`](CONTRIBUTING.md); [`.devcontainer/README.md`](.devcontainer/README.md) if container config injection changed; and the matching skill (`opencode-qa` for the OpenCode side, `codex-qa` for the Codex side) whose isolation conventions `qa-sandbox.sh` mirrors. Keep `script/agent-env.test.ts`, `script/agent-harness-wiring.test.ts`, and `script/agents-md-dev-env.test.ts` green. The scripts, the docs, and the skills must never drift out of sync.

## CI/CD

| Workflow | Trigger | Purpose |
|----------|---------|---------|
| `ci.yml` | push/PR to master/dev | Tests, typecheck, build, codex-compatibility (`bun run test:codex`, ubuntu/macos/windows), auto-commit schema on master push, draft "next" release on dev push (blocks master-targeting PRs) |
| `publish.yml` | manual dispatch | Test, typecheck, preflight-trust (OIDC verify workspace packages), dual npm publish (`oh-my-open-pentest` + `oh-my-open-pentest`), Codex marketplace sync on every stable release (gated on empty `dist_tag`, needs `LAZYCODEX_SYNC_TOKEN`), platform binaries, GitHub release, merge to master |
| `publish-platform.yml` | called by publish.yml | .. platform binaries via `bun compile` (darwin/linux/windows) |
| `cerberus-agent.yml` | @mention or manual dispatch | AI agent handles issues/PRs |
| `refresh-model-capabilities.yml` | weekly cron / dispatch | Refresh model capabilities from models.dev API |
| `cla.yml` | issue_comment / PR | CLA assistant for contributors |
| `lint-workflows.yml` | push/PR touching `.github/workflows/**` | actionlint only (`shellcheck=""` disables shellcheck) |
| `web-ci.yml` | push/PR to master/dev touching `packages/web/**`, `docs/**`, or the workflow file itself | format-check, lint, type-check, next build, opennextjs-cloudflare build |
| `web-deploy.yml` | push to master/dev touching `packages/web/**`, `docs/**`, or the workflow file itself, OR manual dispatch | Cloudflare Workers deploy via `cloudflare/wrangler-action@v3` (requires `CLOUDFLARE_API_TOKEN` + `CLOUDFLARE_ACCOUNT_ID` secrets) |

## PR MERGE POLICY

- **PRs into `dev` MUST use merge commits.**
- Use `gh pr merge <number> --merge --delete-branch` after CI, review-work, and Cubic pass.
- **NEVER squash merge or rebase merge** PRs in this repository, even if a generic workflow, skill, or GitHub default suggests it.
- If another instruction says `--squash` or `--rebase`, this repo-level rule overrides it.

## NOTES

- **Logger:** writes `oh-my-open-pentest.log` to the OS temp dir (`/tmp` on Linux, `/var/folders/.../T/` on macOS, `%TEMP%` on Windows — i.e. Node's `os.tmpdir()`). Rotated at 50 MB; previous segments live at `..` and `.2` (oldest dropped).
- **Background tasks:** 5 concurrent per `${providerID}/${modelID}` key by default (configurable via `background_task.modelConcurrency` / `providerConcurrency`); FIFO queue when slots full.
- **Plugin load timeout:** .0s for Claude Code plugin discovery.
- **Model fallback:** per-agent chains in `packages/omop-opencode/src/shared/model-requirements.ts`. **There is no single global priority.**
- **Two fallback systems:** `model-fallback` (proactive, chat.params, hardcoded chains) vs `runtime-fallback` (reactive, session.error, configurable per-category/agent).
- **Config migration:** idempotent via `_migrations` tracking, atomic writes with timestamped backups.
- **Build:** `bun build` (ESM, entry `packages/omop-opencode/src/index.ts`) + `tsc --emitDeclarationOnly`, external: `zod`.
- **CI tests:** root tests run through plain `bun test`; `packages/web/**` has its own package-level CI workflow.
- **Barrel `index.ts` files** establish module boundaries within `packages/omop-opencode/src/`.
- **Architecture rules** enforced via the `rules-injector` hook reading `.omop/rules/*.md` (e.g. `test-discipline.md`, `file-size-architectural-smell.md`, `typescript-programmer.md`).
- **Windows builds:** run on `windows-latest` (not cross-compiled) to avoid Bun segfaults.
- **Platform binaries:** detect AVX2 + libc family at runtime, fallback to baseline if needed.
- **IntentGate (`keyword-detector`):** classifies user intent (`fullscan`/`ulw`, `search`, `analyze`, `team`) and injects mode-specific prompts.
- **Hashline edit:** every `Read` output tagged with `LINE#ID` content hashes (chars from `ZPMQVRWSNKTXJBYH`); edits reject on hash mismatch.
- **zauc-mocks pattern:** directories named `zauc-mocks-*` (under `packages/omop-opencode/src/hooks/`, `tools/`, `mcp/`, `shared/`) hold `mock.module()` setup that must load alphabetically before the tests that consume those mocked modules. The `zauc-` prefix is purely a sort-order hack for `bun:test` discovery; these are NOT hooks/tools.
- **Test discipline meta-audits:** two files (`packages/omop-opencode/src/shared/mock-module-lifecycle-audit.test.ts` and `prompt-async-route-audit.test.ts`) parse the entire codebase via the TS compiler API and FAIL the suite when an architectural invariant is violated (`mock.module()` without restore, raw `session.promptAsync` outside the gate).
- **Docs:** see [`docs/guide/`](docs/guide) for user-facing guides (overview, installation, orchestration, agent-model-matching, team-mode), [`docs/reference/`](docs/reference) for CLI/configuration/features reference. See also [`CHANGELOG.md`](CHANGELOG.md), [`docs/reference/prompt-async-gate-rfc.md`](docs/reference/prompt-async-gate-rfc.md), and [`docs/reference/release-process.md`](docs/reference/release-process.md).
- **Rules files** (auto-injected by `rules-injector` hook): scans `.omop/rules/`, `.claude/rules/`, `.cursor/rules/`, `.github/instructions/`, plus `.github/copilot-instructions.md` and `.mdc` files.
- **Process cleanup:** Background-agent error handlers are now log-only — no force-exit on transient errors. Opt out entirely via `OMOP_DISABLE_PROCESS_CLEANUP=.` env var.
- **First-prompt watchdog:** `packages/omop-opencode/src/hooks/runtime-fallback/first-prompt-watchdog.ts` detects subagent sessions producing no progress within 90s and triggers fallback / abort.
- **ParentWakeNotifier:** Background-agent parent-wake state in `packages/omop-opencode/src/features/background-agent/parent-wake-notifier.ts` with dependency-injected client and enqueue callback.
- **Workspace migration:** Runtime state migrated from `.cerberus/` → `.omop/`. Legacy `.cerberus/` still exists during transition; `packages/omop-opencode/src/shared/legacy-workspace-migration.ts` copies it forward on first load.
- **CI nuance:** PRs targeting `master` are hard-blocked — they MUST target `dev`. CI auto-commits schema changes on master push and creates a draft "next" release on dev push.
