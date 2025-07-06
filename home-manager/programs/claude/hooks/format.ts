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

const runCommand = async (cmd: string, args: string[], cwd: string) => {
  const command = new Deno.Command(cmd, {
    args,
    cwd,
    stdout: "piped",
    stderr: "piped",
  });
  const { stdout, stderr } = await command.output();

  return {
    stdout: new TextDecoder().decode(stdout),
    stderr: new TextDecoder().decode(stderr),
  };
};

const main = async () => {
  const input = await new Response(Deno.stdin.readable).text();
  const data: HookPostToolUseData = JSON.parse(input);

  const currentDir = Deno.cwd();
  const homeDir = Deno.env.get("HOME");

  let allOutput = "";
  let allError = "";

  // dotfilesディレクトリの場合はnix fmtを実行
  if (currentDir === `${homeDir}/dotfiles`) {
    const result = await runCommand("nix", ["fmt"], currentDir);
    allOutput += result.stdout;
    allError += result.stderr;
  } else {
    const filePath = data.tool_response.filePath;
    const extension = filePath.substring(filePath.lastIndexOf("."));

    if (extension === ".rs") {
      const hasMakefile = await Deno.stat(`${currentDir}/Makefile.toml`)
        .then(() => true)
        .catch(() => false);

      if (hasMakefile) {
        const result = await runCommand("cargo", ["make", "ci"], currentDir);
        allOutput += result.stdout;
        allError += result.stderr;
      } else {
        const checkResult = await runCommand("cargo", ["check"], currentDir);
        allOutput += checkResult.stdout;
        allError += checkResult.stderr;

        const fmtResult = await runCommand("cargo", ["fmt"], currentDir);
        allOutput += fmtResult.stdout;
        allError += fmtResult.stderr;
      }
    }
  }

  // 最後にまとめて出力
  if (allOutput) {
    console.log(allOutput);
  }
  if (allError) {
    console.error(allError);
  }
};

await main();
