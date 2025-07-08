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

interface CommandResult {
  code: number;
  stdout: string;
  stderr: string;
}

interface Command {
  cmd: string;
  args: string[];
  cwd: string;
}

const runCommand = async (
  cmd: string,
  args: string[],
  cwd: string,
): Promise<CommandResult> => {
  const command = new Deno.Command(cmd, {
    args,
    cwd,
    stdout: "piped",
    stderr: "piped",
  });

  const { code, stdout, stderr } = await command.output();
  const result = {
    code,
    stdout: new TextDecoder().decode(stdout),
    stderr: new TextDecoder().decode(stderr),
  };

  return result;
};

const main = async () => {
  try {
    const input = await new Response(Deno.stdin.readable).text();
    const data: HookPostToolUseData = JSON.parse(input);

    const currentDir = Deno.cwd();
    const homeDir = Deno.env.get("HOME");

    const commands: Command[] = [];

    if (currentDir === `${homeDir}/dotfiles`) {
      commands.push({ cmd: "nix", args: ["fmt"], cwd: currentDir });
    } else {
      const filePath = data.tool_response.filePath;
      const extension = filePath.substring(filePath.lastIndexOf("."));

      if (extension === ".rs") {
        const hasMakefile = await Deno.stat(`${currentDir}/Makefile.toml`)
          .then(() => true)
          .catch(() => false);

        if (hasMakefile) {
          commands.push({ cmd: "cargo", args: ["fmt"], cwd: currentDir });
          commands.push({
            cmd: "cargo",
            args: ["make", "ci"],
            cwd: currentDir,
          });
        } else {
          commands.push({ cmd: "cargo", args: ["check"], cwd: currentDir });
          commands.push({ cmd: "cargo", args: ["fmt"], cwd: currentDir });
        }
      }
    }

    const results: CommandResult[] = [];
    for (const command of commands) {
      const result = await runCommand(command.cmd, command.args, command.cwd);
      results.push(result);
    }

    const failedCommands = commands
      .map((cmd, index) => ({
        command: `${cmd.cmd} ${cmd.args.join(" ")}`,
        cwd: cmd.cwd,
        exitCode: results[index].code,
        stdout: results[index].stdout,
        stderr: results[index].stderr,
      }))
      .filter((cmd) => cmd.exitCode !== 0);

    if (failedCommands.length > 0) {
      const output = {
        message:
          "Hook execution completed with errors. Please address the following issues:",
        failedCommands: failedCommands,
      };
      console.error(JSON.stringify(output));
      Deno.exit(2);
    }
  } catch (error) {
    console.error(`[ERROR] Format hook failed: ${error}`);
    throw error;
  }
};

await main();
