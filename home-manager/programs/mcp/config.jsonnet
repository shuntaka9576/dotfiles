local secrets = import 'secrets.jsonnet';
local home = std.extVar('HOME');
local nodepath = home + '/.local/share/mise/installs/node/24.5.0';
local pythonpath = home + '/.local/share/mise/installs/python/3.13.5';

{
  mcpServers: {
    cal2prompt: {
      command: home + '/.cargo/bin/cal2prompt',
      args: ['mcp'],
      env: {
        HOME: home,
      },
    },
    "slack": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-slack"
      ],
      "env": {
        "SLACK_BOT_TOKEN": secrets.slack.token,
        "SLACK_TEAM_ID": secrets.slack.teamID
      }
    },
    "Framelink Figma MCP": {
      "command": "npx",
      "args": ["-y", "figma-developer-mcp", "--figma-api-key=" + secrets.figma.token, "--stdio"]
    },
    // claude_code: {
    //   command: nodepath + '/bin/node',
    //   args: [
    //     nodepath + '/bin/claude',
    //     'mcp',
    //     'serve',
    //   ],
    //   env: {},
    // },
    fetchMcp: {
      command: nodepath + '/bin/npx',
      args: ['-y', 'fetch-mcp'],
    },
    // playwright: {
    //   command: nodepath + '/bin/npx',
    //   args: ['@playwright/mcp@latest'],
    // },
    // "shuntaka.dev": {
    //   "command": "npx",
    //   "args": [
    //     "-m",
    //     "-y",
    //     "sitemcp",
    //     "https://shuntaka.dev"
    //   ]
    // },
    // mymcp: {
    //   command: nodepath + '/bin/node',
    //   args: ["--experimental-transform-types", home + "/repos/github.com/shuntaka9576/my-mcp/src/index.mts"]
    // },
    // "awslabs.aws-documentation-mcp-server": {
    //   command: pythonpath + '/bin/uvx',
    //   args: ["awslabs.aws-documentation-mcp-server@latest"],
    //   env: {
    //     "FASTMCP_LOG_LEVEL": "ERROR"
    //   }
    // },
    github: {
      command: '/etc/profiles/per-user/shuntaka/bin/docker',
      args: [
        'run',
        '-i',
        '--rm',
        '-e',
        'GITHUB_PERSONAL_ACCESS_TOKEN',
        'ghcr.io/github/github-mcp-server'
      ],
      env: {
        GITHUB_PERSONAL_ACCESS_TOKEN: secrets.github.token,
      },
    },
  },
}
