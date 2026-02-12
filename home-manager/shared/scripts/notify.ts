#!/etc/profiles/per-user/shuntaka/bin/deno run --allow-run --allow-env

type Source = "claude-code" | "codex"

interface ClaudeHookData {
  session_id: string
  transcript_path: string
  hook_event_name: "Stop" | "Notification"
  stop_hook_active?: boolean
}

interface CodexPayload {
  type: string
  "turn-id"?: string
  cwd?: string
  [key: string]: unknown
}

const parseSource = (): Source => {
  const idx = Deno.args.indexOf("--source")
  if (idx === -1 || !Deno.args[idx + 1]) {
    throw new Error("--source argument is required (claude-code | codex)")
  }
  const source = Deno.args[idx + 1]
  if (source !== "claude-code" && source !== "codex") {
    throw new Error(`Invalid source: ${source}`)
  }
  return source
}

const runCommand = async (
  cmd: string,
  args: string[],
  cwd?: string,
): Promise<{ success: boolean; stdout: string }> => {
  const command = new Deno.Command(cmd, {
    args,
    cwd,
    stdout: "piped",
    stderr: "piped",
  })
  const result = await command.output()
  return {
    success: result.success,
    stdout: new TextDecoder().decode(result.stdout).trim(),
  }
}

const getGitInfo = async (cwd: string): Promise<{ repoName: string; branchName: string }> => {
  const gitCheck = await runCommand("git", ["rev-parse", "--is-inside-work-tree"], cwd)
  const isGitRepo = gitCheck.success && gitCheck.stdout === "true"

  let repoName = ""
  let branchName = ""

  if (isGitRepo) {
    const remote = await runCommand("git", ["remote", "get-url", "origin"], cwd)

    if (remote.stdout && remote.success) {
      const match = remote.stdout.match(/[/:]([^/]+?)(?:\.git)?$/)
      repoName = match ? match[1] : ""
    }

    if (!repoName) {
      repoName = cwd.split("/").pop() || ""
    }

    const branch = await runCommand("git", ["branch", "--show-current"], cwd)
    branchName = branch.stdout
  } else {
    repoName = cwd.split("/").pop() || ""
  }

  return { repoName, branchName }
}

const main = async () => {
  const source = parseSource()

  let event: string
  let message: string
  let sessionId = ""
  let cwd = Deno.cwd()

  if (source === "claude-code") {
    const input = await new Response(Deno.stdin.readable).text()
    const data: ClaudeHookData = JSON.parse(input)
    event = data.hook_event_name
    sessionId = data.session_id
    message = data.hook_event_name === "Stop" ? "Task Completed" : "Awaiting Confirmation"
  } else {
    const jsonArg = Deno.args[Deno.args.length - 1]
    const data: CodexPayload = JSON.parse(jsonArg)
    cwd = data.cwd || Deno.cwd()
    event = "Notification"
    message = "Task Completed"
  }

  const { repoName, branchName } = await getGitInfo(cwd)
  const tmuxPane = Deno.env.get("TMUX_PANE") || ""
  const terminalApp = Deno.env.get("TERM_PROGRAM") || ""

  const args = [
    "send",
    "--source",
    source === "claude-code" ? "claude-code" : "openai",
    "--event",
    event,
    "--repo",
    repoName,
    "--branch",
    branchName,
    "--message",
    message,
  ]

  if (sessionId) {
    args.push("--session-id", sessionId)
  }

  if (terminalApp) {
    args.push("--terminal-app", terminalApp)
  }

  if (tmuxPane) {
    args.push("--tmux-pane", tmuxPane)
  }

  await runCommand("notibar", args)

  console.log(JSON.stringify({ success: true }))
}

try {
  await main()
} catch (error) {
  console.log(
    JSON.stringify({
      success: false,
      error: error instanceof Error ? error.message : String(error),
    }),
  )

  await runCommand("osascript", [
    "-e",
    'display notification "Hook Failed !" with title "Notify Error"',
  ])
}
