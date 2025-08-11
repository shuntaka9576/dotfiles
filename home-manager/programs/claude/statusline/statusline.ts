#!/usr/bin/env -S deno run --allow-read --allow-run --allow-env

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
const currentDir = data.workspace.current_dir

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
let output = `${ccusage} | 📁 ${dirName}`
if (gitBranch) {
  output += ` | 🌿 ${gitBranch}`
}
if (claudeVersion) {
  output += ` | ⚡ v${claudeVersion}`
}
console.log(output)
