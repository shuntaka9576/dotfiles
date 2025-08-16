local secrets = import 'secrets.jsonnet';
local home = std.extVar('HOME');
local nodepath = home + '/.local/share/mise/installs/node/24.6.0';
local pythonpath = home + '/.local/share/mise/installs/python/3.13.5';

{
  mcpServers: {
    // "Framelink Figma MCP": {
    //   "command": "npx",
    //   "args": ["-y", "figma-developer-mcp", "--figma-api-key=" + secrets.figma.token, "--stdio"]
    // },
    // playwright: {
    //   command: nodepath + '/bin/npx',
    //   args: ['@playwright/mcp@latest'],
    // },
    // "awslabs.aws-documentation-mcp-server": {
    //   command: pythonpath + '/bin/uvx',
    //   args: ["awslabs.aws-documentation-mcp-server@latest"],
    //   env: {
    //     "FASTMCP_LOG_LEVEL": "ERROR"
    //   }
    // },
    "mysql": {
      "command": pythonpath + '/bin/mysql_mcp_server',
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
      "command": nodepath + '/bin/npx',
      "args": [
        "-y",
        "mcp-remote",
        "https://knowledge-mcp.global.api.aws"
      ],
      "env": {
        "PATH": nodepath + '/bin:/usr/local/bin:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin'
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
    "aws.dp-mcp": {
      command: pythonpath + '/bin/uvx',
      args: [
        "awslabs.aws-dataprocessing-mcp-server@latest",
        "--allow-write",
        "--allow-sensitive-data-access"
      ],
      env: {
        "AWS_PROFILE": "iot-demo",
        "AWS_REGION": "ap-northeast-1"
      }
    },
    serena: {
      command: pythonpath + '/bin/uvx',
      args: [
        '--from',
        'git+https://github.com/oraios/serena',
        'serena',
        'start-mcp-server'
      ],
    }
  },
}
