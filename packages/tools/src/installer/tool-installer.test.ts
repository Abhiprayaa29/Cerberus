import { describe, expect, it } from "bun:test"
import { checkPermission, createPermissionConfig, denyTool } from "./permission-manager"
import { getInstallCommand, installTool } from "./tool-installer"
import type { ToolEntry } from "@omop/pentest-core"

const fakeTool = {
  tools_name: "nmap",
  requires_root: false,
  category: "enumeration",
  phase: ["recon"],
  tags: [],
  check_installed: { command: "nmap --version", parse_version: "([\\d.]+)" },
  installation: {
    linux: { command: "apt install nmap" },
    darwin: { command: "brew install nmap" },
    win32: { command: "choco install nmap" },
  },
  command: { base: "nmap", flags: [], positional: [] },
} as unknown as ToolEntry

describe("tools installer permission gate", () => {
  it("#given deny override #when installTool #then returns denied without installing", async () => {
    // given
    const config = createPermissionConfig("allow", [denyTool("nmap", "policy")])

    // when
    const result = await installTool(fakeTool, config, "linux")

    // then
    expect(result.success).toBe(false)
    expect(result.permission).toBe("deny")
    expect(result.message).toContain("denied")
  })

  it("#given core re-export #when getInstallCommand #then matches platform install string", () => {
    // given / when
    const cmd = getInstallCommand(fakeTool, "linux")

    // then
    expect(cmd).toBe("apt install nmap")
  })

  it("#given default allow config #when checkPermission #then allow", () => {
    // given
    const config = createPermissionConfig("allow")

    // when / then
    expect(checkPermission("nmap", config)).toBe("allow")
  })
})
