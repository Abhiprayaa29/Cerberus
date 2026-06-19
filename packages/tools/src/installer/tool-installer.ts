import type { ToolEntry, ToolAvailability, InstallationConfig, PlatformInstallation } from "@omop/pentest-core"
import type { ToolPermission, ToolPermissionConfig, ToolInstallResult, ToolStatusReport } from "../types"
import { checkPermission } from "./permission-manager"
import { exec } from "child_process"
import { promisify } from "util"

const execAsync = promisify(exec)

export async function checkToolInstalled(tool: ToolEntry): Promise<ToolAvailability> {
  try {
    const { stdout } = await execAsync(tool.check_installed.command, { timeout: 10000 })
    
    let version: string | undefined
    if (tool.check_installed.parse_version) {
      const match = stdout.match(new RegExp(tool.check_installed.parse_version))
      version = match?.[1]
    }

    return {
      tools_name: tool.tools_name,
      installed: true,
      version
    }
  } catch (error) {
    return {
      tools_name: tool.tools_name,
      installed: false,
      error: error instanceof Error ? error.message : "Unknown error"
    }
  }
}

export async function checkAllToolsInstalled(tools: readonly ToolEntry[]): Promise<ToolAvailability[]> {
  return Promise.all(tools.map(checkToolInstalled))
}

export function getInstallCommand(tool: ToolEntry, platform: NodeJS.Platform = process.platform): string | null {
  const config = tool.installation[platform as keyof InstallationConfig]
  return config?.command ?? null
}

export function getInstallCommands(tool: ToolEntry): Partial<Record<NodeJS.Platform, PlatformInstallation>> {
  const result: Partial<Record<NodeJS.Platform, PlatformInstallation>> = {}
  
  if (tool.installation.linux) result.linux = tool.installation.linux
  if (tool.installation.darwin) result.darwin = tool.installation.darwin
  if (tool.installation.win32) result.win32 = tool.installation.win32
  
  return result
}

export async function installTool(
  tool: ToolEntry,
  permissionConfig: ToolPermissionConfig,
  platform: NodeJS.Platform = process.platform,
): Promise<ToolInstallResult> {
  const permission = checkPermission(tool.tools_name, permissionConfig)
  
  if (permission === "deny") {
    return {
      tools_name: tool.tools_name,
      success: false,
      message: `Installation denied by permission policy for: ${tool.tools_name}`,
      permission
    }
  }

  const config = tool.installation[platform as keyof InstallationConfig]
  
  if (!config) {
    return {
      tools_name: tool.tools_name,
      success: false,
      message: `No installation command available for platform: ${platform}`,
      permission
    }
  }

  try {
    const { stdout, stderr } = await execAsync(config.command, { timeout: 300000 })
    const message = stdout || stderr || "Installation completed"
    
    let version: string | undefined
    if (tool.check_installed.parse_version) {
      const match = (stdout || "").match(new RegExp(tool.check_installed.parse_version))
      version = match?.[1]
    }

    return {
      tools_name: tool.tools_name,
      success: true,
      message,
      version,
      permission
    }
  } catch (error) {
    return {
      tools_name: tool.tools_name,
      success: false,
      message: error instanceof Error ? error.message : "Installation failed",
      permission
    }
  }
}

export async function installToolWithSudo(
  tool: ToolEntry,
  permissionConfig: ToolPermissionConfig,
  platform: NodeJS.Platform = process.platform,
): Promise<ToolInstallResult> {
  if (!tool.requires_root) {
    return installTool(tool, permissionConfig, platform)
  }

  const permission = checkPermission(tool.tools_name, permissionConfig)
  
  if (permission === "deny") {
    return {
      tools_name: tool.tools_name,
      success: false,
      message: `Installation denied by permission policy for: ${tool.tools_name} (requires root)`,
      permission
    }
  }

  const config = tool.installation[platform as keyof InstallationConfig]
  
  if (!config) {
    return {
      tools_name: tool.tools_name,
      success: false,
      message: `No installation command available for platform: ${platform}`,
      permission
    }
  }

  const sudoCommand = platform === "win32" 
    ? `Start-Process -Verb RunAs -Wait -FilePath "${config.command.split(" ")[0]}" -ArgumentList "${config.command.split(" ").slice(1).join(" ")}"`
    : `sudo ${config.command}`

  try {
    const { stdout, stderr } = await execAsync(sudoCommand, { timeout: 300000 })
    return {
      tools_name: tool.tools_name,
      success: true,
      message: stdout || stderr || "Installation completed (with elevated privileges)",
      permission
    }
  } catch (error) {
    return {
      tools_name: tool.tools_name,
      success: false,
      message: error instanceof Error ? error.message : "Installation with sudo failed",
      permission
    }
  }
}

export function getMissingTools(availability: ToolAvailability[]): ToolAvailability[] {
  return availability.filter(a => !a.installed)
}

export function getInstalledTools(availability: ToolAvailability[]): ToolAvailability[] {
  return availability.filter(a => a.installed)
}

export async function ensureToolsInstalled(
  tools: readonly ToolEntry[],
  permissionConfig: ToolPermissionConfig,
  platform: NodeJS.Platform = process.platform,
): Promise<{
  installed: ToolInstallResult[]
  denied: ToolInstallResult[]
  missing: ToolAvailability[]
  failed: ToolInstallResult[]
}> {
  const availability = await checkAllToolsInstalled(tools)
  const missing = getMissingTools(availability)
  const installed: ToolInstallResult[] = []
  const denied: ToolInstallResult[] = []
  const failed: ToolInstallResult[] = []

  for (const toolAvail of missing) {
    const toolEntry = tools.find(t => t.tools_name === toolAvail.tools_name)
    if (!toolEntry) continue

    const result = toolEntry.requires_root
      ? await installToolWithSudo(toolEntry, permissionConfig, platform)
      : await installTool(toolEntry, permissionConfig, platform)

    if (result.permission === "deny") {
      denied.push(result)
    } else if (result.success) {
      installed.push(result)
    } else {
      failed.push(result)
    }
  }

  return { installed, denied, missing: getMissingTools(await checkAllToolsInstalled(tools)), failed }
}

export async function getToolStatusReport(
  tools: readonly ToolEntry[],
  permissionConfig: ToolPermissionConfig,
  platform: NodeJS.Platform = process.platform,
): Promise<ToolStatusReport[]> {
  const availability = await checkAllToolsInstalled(tools)
  
  return tools.map(tool => {
    const avail = availability.find(a => a.tools_name === tool.tools_name)
    const permission = checkPermission(tool.tools_name, permissionConfig)
    const installCmd = getInstallCommand(tool, platform)
    
    return {
      tools_name: tool.tools_name,
      installed: avail?.installed ?? false,
      version: avail?.version,
      permission,
      requires_root: tool.requires_root,
      category: tool.category,
      phase: tool.phase,
      installable: installCmd !== null && permission === "allow",
      install_command: installCmd ?? undefined,
    }
  })
}
