#!/usr/bin/env -S deno run --allow-read --allow-env

// Helper function to get color based on percentage
function getColor(percentage: number): string {
  if (percentage >= 90) return "\x1b[31m"
  if (percentage >= 70) return "\x1b[33m"
  return "\x1b[32m"
}

// Helper function to format token count
function formatTokenCount(tokens: number): string {
  if (tokens >= 1000000) {
    return `${(tokens / 1000000).toFixed(1)}M`
  } else if (tokens >= 1000) {
    return `${(tokens / 1000).toFixed(1)}K`
  }
  return tokens.toString()
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
const contextWindow = data.context_window
const rateLimits = data.rate_limits

// Build context window part
let ctxPart = "0 (0%)"
if (contextWindow) {
  const totalTokens =
    (contextWindow.total_input_tokens || 0) + (contextWindow.total_output_tokens || 0)
  const tokenDisplay = formatTokenCount(totalTokens)
  const percentage = contextWindow.used_percentage ?? 0
  const color = getColor(percentage)
  ctxPart = `${tokenDisplay} (${color}${percentage}%\x1b[0m)`
}

// Build rate limits part
let rateLimitPart = ""
if (rateLimits) {
  const parts: string[] = []
  if (rateLimits.five_hour) {
    const pct = Math.round(rateLimits.five_hour.used_percentage)
    const { color } = getColor(pct)
    parts.push(`5h: ${color}${pct}%\x1b[0m`)
  }
  if (rateLimits.seven_day) {
    const pct = Math.round(rateLimits.seven_day.used_percentage)
    const { color } = getColor(pct)
    parts.push(`7d: ${color}${pct}%\x1b[0m`)
  }
  if (parts.length > 0) {
    rateLimitPart = ` | ${parts.join(" ")}`
  }
}

// Output
console.log(`${ctxPart}${rateLimitPart}`)
