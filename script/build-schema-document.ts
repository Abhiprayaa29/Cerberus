import { z } from "zod"
import { OhMyOpenCodeConfigSchema } from "../packages/omo-opencode/src/config/schema"

export function createOhMyOpenCodeJsonSchema(): Record<string, unknown> {
  const jsonSchema = z.toJSONSchema(OhMyOpenCodeConfigSchema, {
    target: "draft-7",
    unrepresentable: "any",
  }) as Record<string, unknown>

  return {
    $schema: "http://json-schema.org/draft-07/schema#",
    $id: "https://raw.githubusercontent.com/code-yeongyu/oh-my-open-pentest/dev/assets/oh-my-open-pentest.schema.json",
    title: "Oh My Open Pentest Configuration",
    description: "Configuration schema for oh-my-open-pentest plugin",
    ...jsonSchema,
  }
}
