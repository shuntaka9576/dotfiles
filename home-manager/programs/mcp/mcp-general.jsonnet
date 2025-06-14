local secrets = import 'secrets.jsonnet';

{
  mcpServers: {
    "Framelink Figma MCP": {
      "command": "npx",
      "args": ["-y", "figma-developer-mcp", "--figma-api-key=" + secrets.figma.token, "--stdio"]
    },
    playwright: {
      command: '/Users/shuntaka/.local/share/mise/installs/node/22.13.0/bin/npx',
      args: ['@playwright/mcp@latest'],
    },
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
