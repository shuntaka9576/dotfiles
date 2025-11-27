#!/usr/bin/env -S deno run --allow-read --allow-env

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

// Extract values
const sessionId = data.session_id
const transcriptPath = data.transcript_path

// Calculate token usage for current session
let totalTokens = 0

// Try to get tokens from transcript file
if (transcriptPath) {
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

// Output
if (totalTokens > 0) {
  const tokenDisplay = formatTokenCount(totalTokens)
  const percentage = Math.min(100, Math.round((totalTokens / COMPACTION_THRESHOLD) * 100))

  const { color, emoji } = (() => {
    if (percentage >= 90) {
      return { color: "\x1b[31m", emoji: "🔴" }
    }
    if (percentage >= 70) {
      return { color: "\x1b[33m", emoji: "🟡" }
    }
    return { color: "\x1b[32m", emoji: "🟢" }
  })()

  console.log(`${emoji} ${tokenDisplay} (${color}${percentage}%\x1b[0m)`)
} else {
  console.log("🟢 0 (0%)")
}
