import { z } from "zod"

export const DefaultModeConfigSchema = z.object({
  /**
   * Automatically inject fullscan mode prompt on main session start
   * without requiring "fullscan"/"ulw" keyword in the message.
   * The fullscan mode system prompt is injected once per session.
   */
  fullscan: z.boolean().default(false),
  /**
   * Automatically start ralph loop on main session start
   * without requiring /pentest-loop or /pentest-loop commands.
   * When fullscan is also enabled, the loop starts in fullscan mode.
   */
  pentest_loop: z.boolean().default(false),
})

export type DefaultModeConfig = z.infer<typeof DefaultModeConfigSchema>
