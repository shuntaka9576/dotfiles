#!/usr/bin/env -S deno run --allow-read --allow-run --allow-env

// Read JSON input from stdin
const decoder = new TextDecoder();
const input = decoder.decode(
  await Deno.stdin.readable
    .getReader()
    .read()
    .then((r) => r.value),
);
const data = JSON.parse(input);

// Extract values
const modelDisplay = data.model.display_name;
const currentDir = data.workspace.current_dir;

// Get ccusage status
const ccusageProcess = new Deno.Command("npx", {
  args: ["ccusage@latest", "statusline"],
  stdin: "piped",
  stdout: "piped",
  stderr: "piped",
});

const ccusageChild = ccusageProcess.spawn();
const writer = ccusageChild.stdin.getWriter();
await writer.write(new TextEncoder().encode(input));
await writer.close();

const ccusageOutput = await ccusageChild.output();
const ccusage = new TextDecoder().decode(ccusageOutput.stdout).trim();

// Get git branch if in a git repo
let gitBranch = "";
try {
  // Check if we're in a git repo
  const gitCheckProcess = new Deno.Command("git", {
    args: ["rev-parse", "--git-dir"],
    stdout: "piped",
    stderr: "piped",
  });

  const gitCheckOutput = await gitCheckProcess.output();

  if (gitCheckOutput.success) {
    // Get current branch
    const branchProcess = new Deno.Command("git", {
      args: ["branch", "--show-current"],
      stdout: "piped",
      stderr: "piped",
    });

    const branchOutput = await branchProcess.output();
    gitBranch = new TextDecoder().decode(branchOutput.stdout).trim();
  }
} catch {
  // Not in a git repo, ignore
}

// Get directory name (basename)
const dirName = currentDir.split("/").pop() || currentDir;

// Output the statusline
if (gitBranch) {
  console.log(`${ccusage} | 📁 ${dirName} | 🌿 ${gitBranch}`);
} else {
  console.log(`${ccusage} | 📁 ${dirName}`);
}
