#!/etc/profiles/per-user/shuntaka/bin/deno run --allow-read --allow-run

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

interface HookData {
	session_id: string;
	transcript_path: string;
	tool_name: string;
	tool_input: ToolInput | Record<string, any>;
	tool_response: ToolResponse | Record<string, any>;
}

const findPackageJson = async (startPath: string): Promise<string | null> => {
	let currentPath = startPath;

	while (currentPath !== "/" && currentPath !== "") {
		const packageJsonPath = `${currentPath}/package.json`;
		try {
			const stat = await Deno.stat(packageJsonPath);
			return packageJsonPath;
		} catch (error) {
			const parent = currentPath.split("/").slice(0, -1).join("/");
			if (parent === currentPath) break;
			currentPath = parent || "/";
		}
	}

	return null;
};

const runLintFix = async (packageJsonPath: string, filePath: string) => {
	try {
		const packageJson = await Deno.readTextFile(packageJsonPath);
		const packageData = JSON.parse(packageJson);
		const projectDir = packageJsonPath.replace("/package.json", "");

		if (packageData.scripts) {
			const scripts = Object.keys(packageData.scripts);

			const relevantScripts = scripts
				.filter(
					(script) =>
						script.toLowerCase().includes("lint") ||
						script.toLowerCase().includes("format") ||
						script.toLowerCase().includes("fix"),
				)
				.sort();

			if (relevantScripts.length > 0) {
				for (const command of relevantScripts) {
					const process = new Deno.Command("npm", {
						args: ["run", command, "--", filePath],
						cwd: projectDir,
						stdout: "piped",
						stderr: "piped",
					});

					const { code, stdout, stderr } = await process.output();

					if (stdout.length > 0) {
					}
					if (stderr.length > 0) {
					}
				}
			} else {
			}
		}
	} catch (error) {
		console.error("Error running lint/fix:", error);
	}
};

const main = async () => {
	const input = await new Response(Deno.stdin.readable).text();

	try {
		const data: HookData = JSON.parse(input);

		console.log(`Tool: ${data.tool_name}`);
		console.log(`Session: ${data.session_id}`);

		const filePath = data.tool_input.file_path;

		if (
			filePath.endsWith(".ts") ||
			filePath.endsWith(".tsx") ||
			filePath.endsWith(".js") ||
			filePath.endsWith(".jsx")
		) {
			console.log(`Processing file: ${filePath}`);

			const fileDir = filePath.split("/").slice(0, -1).join("/");
			const packageJsonPath = await findPackageJson(fileDir);

			if (packageJsonPath) {
				await runLintFix(packageJsonPath, filePath);
			} else {
				console.log("No package.json found in parent directories");
			}
		}

		console.log(JSON.stringify(data, null, 2));
	} catch (error) {
		console.error("Error parsing input:", error);
		console.log(input);
	}
};

await main();
