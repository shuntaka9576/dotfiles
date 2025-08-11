#!/usr/bin/env -S deno run --allow-read --allow-run --allow-env

// Constants
const COMPACTION_THRESHOLD = 200000 * 0.8 // 160,000 tokens

// Helper function to format token count
function formatTokenCount(tokens: number): string {
  if (tokens >= 1000000) {
    return `${(tokens / 1000000).toFixed(1)}M`
  } else if (tokens >= 1000) {
    return `${(tokens / 1000).toFixed(1)}K`
  }
  return tokens.toString()
}

// Function to calculate tokens from transcript
async function calculateTokensFromTranscript(filePath: string): Promise<number> {
  try {
    const content = await Deno.readTextFile(filePath)
    const lines = content.trim().split("\n")

    let lastUsage = null

    for (const line of lines) {
      try {
        const entry = JSON.parse(line)

        // Check if this is an assistant message with usage data
        if (entry.type === "assistant" && entry.message?.usage) {
          lastUsage = entry.message.usage
        }
      } catch {
        // Skip invalid JSON lines
      }
    }

    if (lastUsage) {
      // The last usage entry contains cumulative tokens
      const totalTokens =
        (lastUsage.input_tokens || 0) +
        (lastUsage.output_tokens || 0) +
        (lastUsage.cache_creation_input_tokens || 0) +
        (lastUsage.cache_read_input_tokens || 0)
      return totalTokens
    }

    return 0
  } catch {
    return 0
  }
}

// Read JSON input from stdin
const decoder = new TextDecoder()
const input = decoder.decode(
  await Deno.stdin.readable
    .getReader()
    .read()
    .then((r) => r.value),
)
const data = JSON.parse(input)

// Debug: Log the received data to stderr
await Deno.stderr.write(
  new TextEncoder().encode(
    `DEBUG: session_id=${data.session_id}, transcript_path=${data.transcript_path}\n`,
  ),
)

// Extract values
const currentDir = data.workspace.current_dir
const sessionId = data.session_id
const transcriptPath = data.transcript_path

// Get ccusage status
const ccusageProcess = new Deno.Command("ccusage", {
  args: ["statusline"],
  stdin: "piped",
  stdout: "piped",
  stderr: "piped",
})

const ccusageChild = ccusageProcess.spawn()
const writer = ccusageChild.stdin.getWriter()
await writer.write(new TextEncoder().encode(input))
await writer.close()

const ccusageOutput = await ccusageChild.output()
const ccusage = new TextDecoder().decode(ccusageOutput.stdout).trim()

// Calculate token usage for current session
let totalTokens = 0
let tokenDisplay = "0"
let percentageWithColor = "0%"
let tokenEmoji = "🟢" // Default green circle

// Try to get tokens from transcript file
if (transcriptPath) {
  // Use the transcript path directly if provided
  try {
    const stat = await Deno.stat(transcriptPath)
    if (stat.isFile) {
      totalTokens = await calculateTokensFromTranscript(transcriptPath)
    }
  } catch {
    // Transcript file doesn't exist or can't be read
  }
} else if (sessionId) {
  // Fallback: Find transcript file for the current session
  const projectsDir = `${Deno.env.get("HOME")}/.claude/projects`

  try {
    // Get all project directories
    for await (const entry of Deno.readDir(projectsDir)) {
      if (entry.isDirectory) {
        const transcriptFile = `${projectsDir}/${entry.name}/${sessionId}.jsonl`

        try {
          const stat = await Deno.stat(transcriptFile)
          if (stat.isFile) {
            totalTokens = await calculateTokensFromTranscript(transcriptFile)
            break
          }
        } catch {
          // File doesn't exist in this project, continue
        }
      }
    }
  } catch {
    // Projects directory doesn't exist or other error
  }
}

// Format token display if we have tokens
if (totalTokens > 0) {
  tokenDisplay = formatTokenCount(totalTokens)

  // Calculate percentage
  const percentage = Math.min(100, Math.round((totalTokens / COMPACTION_THRESHOLD) * 100))

  // Color coding and emoji for percentage
  const { color: percentageColor, emoji } = (() => {
    if (percentage >= 90) {
      return { color: "\x1b[31m", emoji: "🔴" } // Red
    }
    if (percentage >= 70) {
      return { color: "\x1b[33m", emoji: "🟡" } // Yellow
    }
    return { color: "\x1b[32m", emoji: "🟢" } // Green
  })()

  tokenEmoji = emoji
  percentageWithColor = `${percentageColor}${percentage}%\x1b[0m`
}

// Get Claude Code version
let claudeVersion = ""
try {
  const versionProcess = new Deno.Command("claude", {
    args: ["--version"],
    stdout: "piped",
    stderr: "piped",
  })

  const versionOutput = await versionProcess.output()
  const versionText = new TextDecoder().decode(versionOutput.stdout).trim()
  // Extract version number (e.g., "1.0.72" from "1.0.72 (Claude Code)")
  const versionMatch = versionText.match(/^([\d.]+)/)
  if (versionMatch) {
    claudeVersion = versionMatch[1]
  }
} catch {
  // Claude command not available, ignore
}

// Get git branch if in a git repo
let gitBranch = ""
try {
  // Check if we're in a git repo
  const gitCheckProcess = new Deno.Command("git", {
    args: ["rev-parse", "--git-dir"],
    stdout: "piped",
    stderr: "piped",
  })

  const gitCheckOutput = await gitCheckProcess.output()

  if (gitCheckOutput.success) {
    // Get current branch
    const branchProcess = new Deno.Command("git", {
      args: ["branch", "--show-current"],
      stdout: "piped",
      stderr: "piped",
    })

    const branchOutput = await branchProcess.output()
    gitBranch = new TextDecoder().decode(branchOutput.stdout).trim()
  }
} catch {
  // Not in a git repo, ignore
}

// Get directory name (basename)
const dirName = currentDir.split("/").pop() || currentDir

// Output the statusline
// Build the output parts
let output = `${ccusage}`
if (totalTokens > 0) {
  output += ` | ${tokenEmoji} ${tokenDisplay} (${percentageWithColor})`
}
output += ` | 📁 ${dirName}`
if (gitBranch) {
  output += ` | 🌿 ${gitBranch}`
}
if (claudeVersion) {
  output += ` | ⚡ v${claudeVersion}`
}
console.log(output)
