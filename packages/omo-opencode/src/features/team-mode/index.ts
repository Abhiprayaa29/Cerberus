export * from "./types"
export * from "./team-worktree"

import { setTeamCoreLogger } from "@oh-my-open-pentest/team-core"

import { log } from "../../shared/logger"

setTeamCoreLogger(log)
