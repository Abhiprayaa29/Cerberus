import { setCerberusRuleDeprecationLogger } from "@oh-my-open-pentest/rules-engine";
import { log } from "../../shared/logger";

setCerberusRuleDeprecationLogger(log);

export { findRuleFiles } from "@oh-my-open-pentest/rules-engine";
export type { FindRuleFilesOptions } from "@oh-my-open-pentest/rules-engine";
