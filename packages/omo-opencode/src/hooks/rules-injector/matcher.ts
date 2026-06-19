export {
  createContentHash,
  getMatcherCacheStats,
  isDuplicateByContentHash,
  isDuplicateByRealPath,
  resetMatcherCache,
  shouldApplyRule,
} from "@oh-my-open-pentest/rules-engine";
export type { MatchResult } from "@oh-my-open-pentest/rules-engine";

export interface MatcherCacheStats {
  readonly entries: number;
}
