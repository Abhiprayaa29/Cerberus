import { findRuleFilesRecursive as findRuleFileEntriesRecursive, safeRealpathSync } from "@oh-my-open-pentest/rules-engine";
import type { DirectoryScanEntry } from "@oh-my-open-pentest/rules-engine";

export { safeRealpathSync };

export function findRuleFilesRecursive(dir: string, results: string[]): void {
  const entries: DirectoryScanEntry[] = [];
  findRuleFileEntriesRecursive(dir, entries);
  results.push(...entries.map((entry) => entry.path));
}
