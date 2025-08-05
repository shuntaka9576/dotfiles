local secrets = import 'secrets.jsonnet';

{
  mcpServers: {
    // "Framelink Figma MCP": {
    //   "command": "npx",
    //   "args": ["-y", "figma-developer-mcp", "--figma-api-key=" + secrets.figma.token, "--stdio"]
    // },
    // playwright: {
    //   command: '/Users/shuntaka/.local/share/mise/installs/node/22.13.0/bin/npx',
    //   args: ['@playwright/mcp@latest'],
    // },
    // "awslabs.aws-documentation-mcp-server": {
    //   command: "/Users/shuntaka/.local/share/mise/installs/python/3.13.2/bin/uvx",
    //   args: ["awslabs.aws-documentation-mcp-server@latest"],
    //   env: {
    //     "FASTMCP_LOG_LEVEL": "ERROR"
    //   }
    // },
    "mysql": {
      "command": "/Users/shuntaka/.local/share/mise/installs/python/3.13.5/bin/mysql_mcp_server",
      "args": [],
      "env": {
        "MYSQL_HOST": secrets.mcp_server_mysql.host,
        "MYSQL_PORT": secrets.mcp_server_mysql.port,
        "MYSQL_USER": secrets.mcp_server_mysql.mysqlUser,
        "MYSQL_PASSWORD": secrets.mcp_server_mysql.mysqlPass,
        "MYSQL_DATABASE": secrets.mcp_server_mysql.database
      }
    },
    "aws-knowledge-mcp-server": {
      "command": "/Users/shuntaka/.local/share/mise/installs/node/24.5.0/bin/npx",
      "args": [
        "-y",
        "mcp-remote",
        "https://knowledge-mcp.global.api.aws"
      ],
      "env": {
        "PATH": "/Users/shuntaka/.local/share/mise/installs/node/24.4.1/bin:/usr/local/bin:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin"
      }
    },
    // github: {
    //   command: '/etc/profiles/per-user/shuntaka/bin/docker',
    //   args: [
    //     'run',
    //     '-i',
    //     '--rm',
    //     '-e',
    //     'GITHUB_PERSONAL_ACCESS_TOKEN',
    //     'ghcr.io/github/github-mcp-server'
    //   ],
    //   env: {
    //     GITHUB_PERSONAL_ACCESS_TOKEN: secrets.github.token,
    //   },
    // },
    "github": {
      "type": "http",
      "url": "https://api.githubcopilot.com/mcp/",
      "headers": {
        "Authorization": "Bearer " + secrets.github.token
      }
    },
    serena: {
      command: '/Users/shuntaka/.local/share/mise/installs/python/3.13.5/bin/uvx',
      args: [
        '--from',
        'git+https://github.com/oraios/serena',
        'serena',
        'start-mcp-server'
      ],
    },
  },
}
