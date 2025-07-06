#!/etc/profiles/per-user/shuntaka/bin/deno run --allow-run --allow-env

interface HookStopData {
  session_id: string;
  transcript_path: string;
  hook_event_name: "Stop";
  stop_hook_active: boolean;
}

const main = async () => {
  const input = await new Response(Deno.stdin.readable).text();

  try {
    const data: HookStopData = JSON.parse(input);

    const currentDir = Deno.cwd();
    const repoName = currentDir.split("/").pop() || "";

    // Get current branch name
    const branchProcess = new Deno.Command("git", {
      args: ["branch", "--show-current"],
      stdout: "piped",
      stderr: "piped",
    });

    const branchResult = await branchProcess.output();
    const branchName = new TextDecoder().decode(branchResult.stdout).trim();

    const repoInfo = branchName ? `${repoName} (${branchName})` : repoName;

    const process = new Deno.Command("osascript", {
      args: [
        "-e",
        `display notification "Task Completed 🚀" with title "⚡ Claude Code" subtitle "${repoInfo} 📦"`,
      ],
      stdout: "piped",
      stderr: "piped",
    });

    await process.output();

    console.log(JSON.stringify({ success: true }));
  } catch (error) {
    console.log(
      JSON.stringify({
        success: false,
        error: error instanceof Error ? error.message : String(error),
      }),
    );

    const process = new Deno.Command("osascript", {
      args: [
        "-e",
        'display notification "Hook Failed !" with title "Claude Code Error 🚨"',
      ],
      stdout: "piped",
      stderr: "piped",
    });

    await process.output();
  }
};

await main();
