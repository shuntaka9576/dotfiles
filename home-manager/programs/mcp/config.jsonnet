local secrets = import 'secrets.jsonnet';

{
  mcpServers: {
    cal2prompt: {
      command: '/Users/shuntaka/.cargo/bin/cal2prompt',
      args: ['mcp'],
      env: {
        HOME: '/Users/shuntaka',
      },
    },
    claude_code: {
      command: '/Users/shuntaka/.local/share/mise/installs/node/22.13.0/bin/node',
      args: [
        '/Users/shuntaka/.local/share/mise/installs/node/22.13.0/bin/claude',
        'mcp',
        'serve',
      ],
      env: {},
    },
    playwright: {
      command: '/Users/shuntaka/.local/share/mise/installs/node/22.13.0/bin/npx',
      args: ['@playwright/mcp@latest'],
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