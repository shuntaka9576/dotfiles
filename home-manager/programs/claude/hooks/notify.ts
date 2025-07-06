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

    const process = new Deno.Command("osascript", {
      args: [
        "-e",
        `display notification "Task Completed 🚀" with title "⚡ Claude Code" subtitle "${repoName} 📦"`,
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
