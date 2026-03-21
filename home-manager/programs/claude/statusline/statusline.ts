#!/usr/bin/env -S deno run --allow-read --allow-env

const BAR_CHAR = "⣿"
const R = "\x1b[0m"
const DIM = "\x1b[2m"
function dimGradient(pct: number): string {
  if (pct < 50) {
    return "\x1b[38;2;0;60;24m"
  } else if (pct < 80) {
    return "\x1b[38;2;76;60;0m"
  } else {
    return "\x1b[38;2;76;18;18m"
  }
}

function gradient(pct: number): string {
  if (pct < 50) {
    return "\x1b[38;2;0;200;80m"
  } else if (pct < 80) {
    return "\x1b[38;2;255;200;0m"
  } else {
    return "\x1b[38;2;255;60;60m"
  }
}

function bar(pct: number, width = 10): string {
  pct = Math.min(Math.max(pct, 0), 100)
  const full = Math.round((pct * width) / 100)
  const filled = gradient(pct) + "█".repeat(full) + R
  const empty = dimGradient(pct) + BAR_CHAR.repeat(width - full) + R
  return filled + empty
}

function fmt(label: string, pct: number): string {
  const p = Math.round(pct)
  return `${label} ${bar(pct)} ${gradient(pct)}${p}%${R}`
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

const parts: string[] = []

const ctx = data.context_window?.used_percentage
if (ctx != null) {
  parts.push(fmt("ctx", ctx))
}

const five = data.rate_limits?.five_hour?.used_percentage
if (five != null) {
  parts.push(fmt("5h", five))
}

const week = data.rate_limits?.seven_day?.used_percentage
if (week != null) {
  parts.push(fmt("7d", week))
}

const output = parts.map((p) => ` ${p} `).join(`${DIM}│${R}`)
console.log(output)
