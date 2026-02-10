#!/etc/profiles/per-user/shuntaka/bin/deno run --allow-run --allow-env

interface HookData {
  session_id: string
  transcript_path: string
  hook_event_name: "Stop" | "Notification"
  stop_hook_active?: boolean
}

const main = async () => {
  const input = await new Response(Deno.stdin.readable).text()

  try {
    const data: HookData = JSON.parse(input)

    const currentDir = Deno.cwd()

    // Check if current directory is a git repository
    const gitCheckProcess = new Deno.Command("git", {
      args: ["rev-parse", "--is-inside-work-tree"],
      stdout: "piped",
      stderr: "piped",
    })

    const gitCheckResult = await gitCheckProcess.output()
    const isGitRepo =
      gitCheckResult.success && new TextDecoder().decode(gitCheckResult.stdout).trim() === "true"

    let repoName = ""
    let branchName = ""

    if (isGitRepo) {
      // Get repository name from git remote
      const remoteProcess = new Deno.Command("git", {
        args: ["remote", "get-url", "origin"],
        stdout: "piped",
        stderr: "piped",
      })

      const remoteResult = await remoteProcess.output()
      const remoteUrl = new TextDecoder().decode(remoteResult.stdout).trim()

      if (remoteUrl && remoteResult.success) {
        // Extract repo name from URL (supports both HTTPS and SSH formats)
        const match = remoteUrl.match(/[/:]([^/]+?)(?:\.git)?$/)
        repoName = match ? match[1] : ""
      }

      // Fallback to directory name if no git remote
      if (!repoName) {
        repoName = currentDir.split("/").pop() || ""
      }

      // Get current branch name
      const branchProcess = new Deno.Command("git", {
        args: ["branch", "--show-current"],
        stdout: "piped",
        stderr: "piped",
      })

      const branchResult = await branchProcess.output()
      branchName = new TextDecoder().decode(branchResult.stdout).trim()
    } else {
      // Not a git repository, use directory name
      repoName = currentDir.split("/").pop() || ""
    }

    const message = data.hook_event_name === "Stop" ? "Task Completed" : "Awaiting Confirmation"

    const process = new Deno.Command("notibar", {
      args: [
        "send",
        "--source",
        "claude-code",
        "--event",
        data.hook_event_name,
        "--repo",
        repoName,
        "--branch",
        branchName,
        "--session-id",
        data.session_id,
        "--message",
        message,
      ],
      stdout: "piped",
      stderr: "piped",
    })

    await process.output()

    console.log(JSON.stringify({ success: true }))
  } catch (error) {
    console.log(
      JSON.stringify({
        success: false,
        error: error instanceof Error ? error.message : String(error),
      }),
    )

    const process = new Deno.Command("osascript", {
      args: ["-e", 'display notification "Hook Failed !" with title "Claude Code Error 🚨"'],
      stdout: "piped",
      stderr: "piped",
    })

    await process.output()
  }
}

await main()
