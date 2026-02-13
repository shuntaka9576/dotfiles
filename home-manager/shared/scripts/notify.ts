#!/etc/profiles/per-user/shuntaka/bin/deno run --allow-run --allow-env --allow-read

type Source = "claude-code" | "codex"

interface HookData {
  session_id: string
  transcript_path: string
  hook_event_name: "Stop" | "Notification"
  notification_type?: "permission_prompt" | "idle_prompt" | "auth_success" | "elicitation_dialog"
  stop_hook_active?: boolean
}

const FOCUS_EVENTS = new Set(["Stop", "permission_prompt", "elicitation_dialog"])

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

  let title: string
  let color: string
  let focus = false
  let cwd = Deno.cwd()

  if (source === "claude-code") {
    const input = await new Response(Deno.stdin.readable).text()
    const data: HookData = JSON.parse(input)
    const isStop = data.hook_event_name === "Stop"
    title = data.hook_event_name
    color = isStop ? "red" : "blue"
    const eventKey = data.notification_type || data.hook_event_name
    focus = FOCUS_EVENTS.has(eventKey)
  } else {
    const jsonArg = Deno.args[Deno.args.length - 1]
    const data: CodexPayload = JSON.parse(jsonArg)
    cwd = data.cwd || Deno.cwd()
    title = "Notification"
    color = "blue"
  }

  const { repoName, branchName } = await getGitInfo(cwd)
  const tmuxPane = Deno.env.get("TMUX_PANE") || ""

  const args = [
    "send",
    "--title",
    title,
    "--color",
    color,
    "--icon",
    source === "claude-code" ? "claude-code" : "codex",
    "--group",
    repoName,
  ]

  if (tmuxPane) {
    args.push("--tmux-pane", tmuxPane)
  }

  if (branchName) {
    args.push("--meta", `branch=${branchName}`)
  }

  if (focus) {
    args.push("--focus")
  }

  await runCommand("agentoast", args)

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
}
