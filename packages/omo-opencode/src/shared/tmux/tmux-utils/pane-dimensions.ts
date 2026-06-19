import { getPaneDimensions as getPaneDimensionsCore } from "@oh-my-open-pentest/tmux-core"
import type { PaneDimensions } from "@oh-my-open-pentest/tmux-core"

export async function getPaneDimensions(
	paneId: string,
): Promise<PaneDimensions | null> {
  const [{ getTmuxPath }, { runTmuxCommand }] = await Promise.all([
    import("../../../tools/interactive-bash/tmux-path-resolver"),
    import("../runner"),
  ])
	return getPaneDimensionsCore(paneId, { getTmuxPath, runTmuxCommand })
}

export type { PaneDimensions }
