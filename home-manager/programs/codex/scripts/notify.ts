#!/usr/bin/env bun

interface CodexPayload {
  type: string
  "turn-id"?: string
  cwd?: string
  [key: string]: unknown
}

const main = async () => {
  // Codex は notify コマンドの最後の引数に JSON payload を追加する
  const jsonArg = process.argv[process.argv.length - 1]
  const data: CodexPayload = JSON.parse(jsonArg)

  const currentDir = data.cwd || process.cwd()

  // Check if current directory is a git repository
  const gitCheck = Bun.spawnSync(["git", "rev-parse", "--is-inside-work-tree"], { cwd: currentDir })
  const isGitRepo = gitCheck.exitCode === 0 && gitCheck.stdout.toString().trim() === "true"

  let repoName = ""
  let branchName = ""

  if (isGitRepo) {
    // Get repository name from git remote
    const remote = Bun.spawnSync(["git", "remote", "get-url", "origin"], { cwd: currentDir })
    const remoteUrl = remote.stdout.toString().trim()

    if (remoteUrl && remote.exitCode === 0) {
      // Extract repo name from URL (supports both HTTPS and SSH formats)
      const match = remoteUrl.match(/[/:]([^/]+?)(?:\.git)?$/)
      repoName = match ? match[1] : ""
    }

    // Fallback to directory name if no git remote
    if (!repoName) {
      repoName = currentDir.split("/").pop() || ""
    }

    // Get current branch name
    const branch = Bun.spawnSync(["git", "branch", "--show-current"], { cwd: currentDir })
    branchName = branch.stdout.toString().trim()
  } else {
    // Not a git repository, use directory name
    repoName = currentDir.split("/").pop() || ""
  }

  const event = "Notification"
  const message = "Task Completed"

  const proc = Bun.spawn([
    "notibar",
    "send",
    "--source",
    "openai",
    "--event",
    event,
    "--repo",
    repoName,
    "--branch",
    branchName,
    "--message",
    message,
  ])

  await proc.exited
}

await main()
