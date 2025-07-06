#!/etc/profiles/per-user/shuntaka/bin/deno run --allow-read --allow-run --allow-env

interface ToolInput {
  file_path: string;
  new_string: string;
  old_string: string;
  replace_all: boolean;
}

interface ToolResponse {
  filePath: string;
  oldString: string;
  newString: string;
  originalFile: string;
  structuredPatch: Array<{
    oldStart: number;
    oldLines: number;
    newStart: number;
    newLines: number;
    lines: string[];
  }>;
  userModified: boolean;
  replaceAll: boolean;
}

interface HookPostToolUseData {
  session_id: string;
  transcript_path: string;
  hook_event_name: string;
  tool_name: string;
  tool_input: ToolInput;
  tool_response: ToolResponse;
}

const runCargoCommand = async (args: string[], cwd: string) => {
  const command = new Deno.Command("cargo", { args, cwd });
  await command.output();
};

const main = async () => {
  const input = await new Response(Deno.stdin.readable).text();
  const data: HookPostToolUseData = JSON.parse(input);

  const currentDir = Deno.cwd();
  const homeDir = Deno.env.get("HOME");

  // dotfilesディレクトリの場合はnix fmtを実行
  if (currentDir === `${homeDir}/dotfiles`) {
    const command = new Deno.Command("nix", { args: ["fmt"], cwd: currentDir });
    await command.output();
    return;
  }

  const filePath = data.tool_response.filePath;
  const extension = filePath.substring(filePath.lastIndexOf("."));

  if (extension === ".rs") {
    const hasMakefile = await Deno.stat(`${currentDir}/Makefile.toml`)
      .then(() => true)
      .catch(() => false);

    if (hasMakefile) {
      await runCargoCommand(["make", "ci"], currentDir);
    } else {
      await runCargoCommand(["check"], currentDir);
      await runCargoCommand(["fmt"], currentDir);
    }
  }
};

await main();
