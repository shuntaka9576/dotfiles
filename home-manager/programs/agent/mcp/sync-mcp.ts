import { existsSync, mkdirSync, readFileSync, writeFileSync } from "fs"
import { parse as parseJsonc } from "jsonc-parser"
import { dirname, resolve } from "path"

const HOME = process.env.HOME!
const DOTFILES = `${HOME}/dotfiles`

const mcpCodePath = resolve(DOTFILES, "home-manager/programs/agent/mcp/.mcp-code.json")
const mcpCode = JSON.parse(readFileSync(mcpCodePath, "utf-8"))

// --- Claude Code ---
// ~/.config/claude/.claude.json に mcpServers をマージ
const claudeJsonPath = `${HOME}/.config/claude/.claude.json`
if (existsSync(claudeJsonPath)) {
  const claudeJson = JSON.parse(readFileSync(claudeJsonPath, "utf-8"))
  delete claudeJson.mcpServers
  const merged = { ...claudeJson, ...mcpCode }
  writeFileSync(claudeJsonPath, JSON.stringify(merged, null, 2) + "\n")
  console.log(`[sync-mcp] Updated ${claudeJsonPath}`)
} else {
  console.warn(`[sync-mcp] Skipped: ${claudeJsonPath} not found`)
}

// --- Opencode ---
// ベース設定を読み込み、MCP をマージして出力
const opencodeBasePath = resolve(DOTFILES, "home-manager/programs/opencode/opencode.jsonc")
const opencodeOutPath = `${HOME}/.config/opencode/opencode.jsonc`

type McpServer = {
  command: string
  args?: string[]
  env?: Record<string, string>
}

type OpencodeMcpServer = {
  type: "local"
  command: string[]
  environment?: Record<string, string>
}

function toOpencodeFormat(servers: Record<string, McpServer>) {
  const result: Record<string, OpencodeMcpServer> = {}
  for (const [name, server] of Object.entries(servers)) {
    const cmd = [server.command, ...(server.args ?? [])]
    const entry: OpencodeMcpServer = {
      type: "local",
      command: cmd,
    }
    if (server.env && Object.keys(server.env).length > 0) {
      entry.environment = server.env
    }
    result[name] = entry
  }
  return result
}

if (existsSync(opencodeBasePath)) {
  const baseText = readFileSync(opencodeBasePath, "utf-8")
  const base = parseJsonc(baseText) as Record<string, unknown>
  delete base.mcp
  const opencodeMcp = toOpencodeFormat(mcpCode.mcpServers ?? {})
  const merged = { ...base, mcp: opencodeMcp }
  const outDir = dirname(opencodeOutPath)
  if (!existsSync(outDir)) mkdirSync(outDir, { recursive: true })
  writeFileSync(opencodeOutPath, JSON.stringify(merged, null, 2) + "\n")
  console.log(`[sync-mcp] Updated ${opencodeOutPath}`)
}

// --- Codex ---
// ベース設定を読み込み、MCP をマージして TOML で出力
const codexBasePath = resolve(DOTFILES, "home-manager/programs/codex/config.toml")
const codexOutPath = `${HOME}/.codex/config.toml`

function toTomlKey(key: string): string {
  if (/^[a-zA-Z0-9_-]+$/.test(key)) return key
  return `"${key.replace(/\\/g, "\\\\").replace(/"/g, '\\"')}"`
}

function toToml(obj: Record<string, unknown>, prefix = ""): string {
  const lines: string[] = []
  const simple: [string, unknown][] = []
  const tables: [string, unknown][] = []

  for (const [key, value] of Object.entries(obj)) {
    if (typeof value === "object" && value !== null && !Array.isArray(value)) {
      tables.push([key, value])
    } else {
      simple.push([key, value])
    }
  }

  for (const [key, value] of simple) {
    lines.push(`${toTomlKey(key)} = ${toTomlValue(value)}`)
  }

  for (const [key, value] of tables) {
    const quotedKey = toTomlKey(key)
    const fullKey = prefix ? `${prefix}.${quotedKey}` : quotedKey
    lines.push("")
    lines.push(`[${fullKey}]`)
    const nested = value as Record<string, unknown>
    const nestedSimple: [string, unknown][] = []
    const nestedTables: [string, unknown][] = []
    for (const [nk, nv] of Object.entries(nested)) {
      if (typeof nv === "object" && nv !== null && !Array.isArray(nv)) {
        nestedTables.push([nk, nv])
      } else {
        nestedSimple.push([nk, nv])
      }
    }
    for (const [nk, nv] of nestedSimple) {
      lines.push(`${toTomlKey(nk)} = ${toTomlValue(nv)}`)
    }
    for (const [nk, nv] of nestedTables) {
      lines.push(toToml({ [nk]: nv }, fullKey))
    }
  }

  return lines.join("\n")
}

function toTomlValue(value: unknown): string {
  if (typeof value === "string") return `"${value.replace(/\\/g, "\\\\").replace(/"/g, '\\"')}"`
  if (typeof value === "number" || typeof value === "boolean") return String(value)
  if (Array.isArray(value)) return `[${value.map(toTomlValue).join(", ")}]`
  return String(value)
}

function splitTomlSectionKey(section: string): string[] {
  const parts: string[] = []
  let i = 0
  while (i < section.length) {
    if (section[i] === '"') {
      const end = section.indexOf('"', i + 1)
      if (end === -1) {
        parts.push(section.slice(i + 1))
        break
      }
      parts.push(section.slice(i + 1, end))
      i = end + 1
      if (i < section.length && section[i] === ".") i++
    } else {
      const dot = section.indexOf(".", i)
      const quote = section.indexOf('"', i)
      let end: number
      if (dot === -1) end = section.length
      else if (quote !== -1 && quote < dot) end = quote
      else end = dot
      const part = section.slice(i, end).trim()
      if (part) parts.push(part)
      i = end
      if (i < section.length && section[i] === ".") i++
    }
  }
  return parts
}

function parseSimpleToml(text: string): Record<string, unknown> {
  const result: Record<string, unknown> = {}
  let currentSection: string | null = null

  for (const line of text.split("\n")) {
    const trimmed = line.trim()
    if (!trimmed || trimmed.startsWith("#")) continue

    const sectionMatch = trimmed.match(/^\[(.+)\]$/)
    if (sectionMatch) {
      currentSection = sectionMatch[1]
      continue
    }

    const kvMatch = trimmed.match(/^([^=]+?)\s*=\s*(.+)$/)
    if (kvMatch) {
      const key = kvMatch[1].trim()
      const rawValue = kvMatch[2].trim()
      const value = parseTomlValue(rawValue)

      if (currentSection) {
        const parts = splitTomlSectionKey(currentSection)
        let obj = result as Record<string, unknown>
        for (const part of parts) {
          if (!(part in obj)) obj[part] = {}
          obj = obj[part] as Record<string, unknown>
        }
        obj[key] = value
      } else {
        result[key] = value
      }
    }
  }
  return result
}

function parseTomlValue(raw: string): unknown {
  if (raw === "true") return true
  if (raw === "false") return false
  if (/^-?\d+$/.test(raw)) return parseInt(raw, 10)
  if (/^-?\d+\.\d+$/.test(raw)) return parseFloat(raw)
  if (raw.startsWith('"') && raw.endsWith('"'))
    return raw.slice(1, -1).replace(/\\"/g, '"').replace(/\\\\/g, "\\")
  if (raw.startsWith("[") && raw.endsWith("]")) {
    const inner = raw.slice(1, -1).trim()
    if (!inner) return []
    return inner.split(",").map((s) => parseTomlValue(s.trim()))
  }
  return raw
}

type CodexMcpServer = {
  command: string
  args?: string[]
  env?: Record<string, string>
}

function toCodexFormat(servers: Record<string, McpServer>) {
  const result: Record<string, CodexMcpServer> = {}
  for (const [name, server] of Object.entries(servers)) {
    const entry: CodexMcpServer = {
      command: server.command,
    }
    if (server.args && server.args.length > 0) {
      entry.args = server.args
    }
    if (server.env && Object.keys(server.env).length > 0) {
      entry.env = server.env
    }
    result[name] = entry
  }
  return result
}

if (existsSync(codexBasePath)) {
  const baseText = readFileSync(codexBasePath, "utf-8")
  const base = parseSimpleToml(baseText)
  // Remove existing mcp_servers
  delete base.mcp_servers
  // Add new mcp_servers
  const codexMcp = toCodexFormat(mcpCode.mcpServers ?? {})
  base.mcp_servers = codexMcp
  const outDir = dirname(codexOutPath)
  if (!existsSync(outDir)) mkdirSync(outDir, { recursive: true })
  const tomlContent = toToml(base) + "\n"
  writeFileSync(codexOutPath, tomlContent)
  console.log(`[sync-mcp] Updated ${codexOutPath}`)
}
