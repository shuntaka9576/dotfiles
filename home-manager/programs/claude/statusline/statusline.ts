#!/usr/bin/env -S deno run --allow-read --allow-env

const R = "\x1b[0m"
const DIM = "\x1b[2m"

function gradient(pct: number): string {
  if (pct < 50) {
    return "\x1b[38;2;0;200;80m"
  } else if (pct < 80) {
    return "\x1b[38;2;255;200;0m"
  } else {
    return "\x1b[38;2;255;60;60m"
  }
}

const PIE = ["○", "◔", "◑", "◕", "●"] as const

function pie(pct: number): string {
  pct = Math.min(Math.max(pct, 0), 100)
  const idx = Math.min(4, Math.floor((pct + 12.5) / 25))
  return `${gradient(pct)}${PIE[idx]}${R}`
}

const EFFORT_IDX: Record<string, number> = {
  low: 0,
  medium: 1,
  high: 2,
  xhigh: 3,
  max: 4,
}

function effortPie(level: string | undefined): string {
  if (!level) return ""
  const idx = EFFORT_IDX[level.toLowerCase()]
  if (idx == null) return ""
  return ` ${PIE[idx]}`
}

function formatRemaining(secs: number): string | null {
  if (secs <= 0) return null
  if (secs >= 86400) {
    const d = Math.floor(secs / 86400)
    const h = Math.floor((secs % 86400) / 3600)
    return `${d}d${h}h`
  }
  const h = Math.floor(secs / 3600)
  return `${h}h`
}

function fmtPie(label: string, pct: number, resetsAt?: number): string {
  const p = Math.round(pct)
  let suffix = ""
  if (resetsAt != null) {
    const remaining = formatRemaining(resetsAt - Math.floor(Date.now() / 1000))
    if (remaining !== null) {
      suffix = `${DIM}·${remaining}${R}`
    }
  }
  return `${label} ${pie(pct)} ${gradient(pct)}${p}%${R}${suffix}`
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

function shortModelName(id: string | undefined, displayName: string | undefined): string {
  const src = (id ?? "").replace(/\[.*?\]/g, "")
  const m = src.match(/^claude-(opus|sonnet|haiku)-(\d+)-(\d+)/i)
  if (m) {
    return `${m[1].toLowerCase()}${m[2]}.${m[3]}`
  }
  return (displayName ?? "").replace(/\s+/g, "").toLowerCase()
}

function contextTag(size: number | undefined): string {
  if (size === 1000000) return "[1m]"
  if (size === 200000) return "[200k]"
  return ""
}

const compact = shortModelName(data.model?.id, data.model?.display_name)
if (compact !== "") {
  const tag = effortPie(data.effort?.level)
  parts.push(`${compact}${contextTag(data.context_window?.context_window_size)}${tag}`)
}

const ctx = data.context_window?.used_percentage
if (ctx != null) {
  parts.push(fmtPie("ctx", ctx))
}

const five = data.rate_limits?.five_hour?.used_percentage
if (five != null) {
  parts.push(fmtPie("5h", five, data.rate_limits?.five_hour?.resets_at))
}

const week = data.rate_limits?.seven_day?.used_percentage
if (week != null) {
  parts.push(fmtPie("7d", week, data.rate_limits?.seven_day?.resets_at))
}

const output = parts.map((p) => ` ${p} `).join(`${DIM}│${R}`)
console.log(output)
