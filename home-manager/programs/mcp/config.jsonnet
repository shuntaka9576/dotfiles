local secrets = import 'secrets.jsonnet';

{
  mcpServers: {
    // cal2prompt: {
    //   command: '/Users/shuntaka/.cargo/bin/cal2prompt',
    //   args: ['mcp'],
    //   env: {
    //     HOME: '/Users/shuntaka',
    //   },
    // },
    // claude_code: {
    //   command: '/Users/shuntaka/.local/share/mise/installs/node/22.13.0/bin/node',
    //   args: [
    //     '/Users/shuntaka/.local/share/mise/installs/node/22.13.0/bin/claude',
    //     'mcp',
    //     'serve',
    //   ],
    //   env: {},
    // },
    fetchMcp: {
      command: '/Users/shuntaka/.local/share/mise/installs/node/22.13.0/bin/npx',
      args: ['-y', 'fetch-mcp'],
    },
    // playwright: {
    //   command: '/Users/shuntaka/.local/share/mise/installs/node/22.13.0/bin/npx',
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
    //   command: "/Users/shuntaka/.local/share/mise/installs/node/22.13.0/bin/node",
    //   args: ["--experimental-transform-types", "/Users/shuntaka/repos/github.com/shuntaka9576/my-mcp/src/index.mts"]
    // },
    "awslabs.aws-documentation-mcp-server": {
      command: "/Users/shuntaka/.local/share/mise/installs/python/3.13.2/bin/uvx",
      args: ["awslabs.aws-documentation-mcp-server@latest"],
      env: {
        "FASTMCP_LOG_LEVEL": "ERROR"
      }
    },
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
