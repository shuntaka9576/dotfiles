local secrets = import 'secrets.jsonnet';
local home = std.extVar('HOME');
// mise の shim 経由にすることで node/python のバージョンを上げても追従する
local shims = home + '/.local/share/mise/shims';
local bin(name) = shims + '/' + name;
local defaultPath = shims + ':/usr/local/bin:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin';

{
  mcpServers: {
    'ask-user': {
      command: home + '/.local/share/mise/shims/mcp-ask-user',
      args: ['--stdio'],
      env: {
        PATH: defaultPath,
      },
    },
    // 'color-picker': {
    //   command: bin('node'),
    //   args: ['--experimental-strip-types', '/Users/shuntaka/repos/github.com/shuntaka9576/mcp-apps-practice/server.ts'],
    // },
    // "Framelink Figma MCP": {
    //   "command": bin('npx'),
    //   "args": ["-y", "figma-developer-mcp", "--figma-api-key=" + secrets.figma.token, "--stdio"]
    // },
    // "mcp_server_mysql": {
    //   "command": bin('node'),
    //   "args": [
    //     bin('mcp-server-mysql')
    //   ],
    //   "env": {
    //     "MYSQL_HOST": secrets.mcp_server_mysql.host,
    //     "MYSQL_PORT": secrets.mcp_server_mysql.port,
    //     "MYSQL_USER": secrets.mcp_server_mysql.mysqlUser,
    //     "MYSQL_PASS": secrets.mcp_server_mysql.mysqlPass,
    //     "MYSQL_DB": secrets.mcp_server_mysql.database,
    //     "ALLOW_INSERT_OPERATION": "false",
    //     "ALLOW_UPDATE_OPERATION": "false",
    //     "ALLOW_DELETE_OPERATION": "false",
    //   }
    // },
    // "mysql": {
    //   "command": bin('npx'),
    //   "args": [
    //     "-y",
    //     "@modelcontextprotocol/server-mysql"
    //   ],
    //   "env": {
    //     "MYSQL_HOST": secrets.mcp_server_mysql.host,
    //     "MYSQL_PORT": secrets.mcp_server_mysql.port,
    //     "MYSQL_USER": secrets.mcp_server_mysql.mysqlUser,
    //     "MYSQL_PASSWORD": secrets.mcp_server_mysql.mysqlPass,
    //     "MYSQL_DATABASE": secrets.mcp_server_mysql.database
    //   }
    // },
    // 'aws-knowledge-mcp-server': {
    //   command: bin('npx'),
    //   args: [
    //     '-y',
    //     'mcp-remote',
    //     'https://knowledge-mcp.global.api.aws',
    //   ],
    //   env: {
    //     PATH: defaultPath,
    //   },
    // },
    // mysql: {
    //   command: bin('mysql_mcp_server'),
    //   args: [],
    //   env: {
    //     MYSQL_HOST: secrets.mcp_server_mysql.host,
    //     MYSQL_PORT: secrets.mcp_server_mysql.port,
    //     MYSQL_USER: secrets.mcp_server_mysql.mysqlUser,
    //     MYSQL_PASSWORD: secrets.mcp_server_mysql.mysqlPass,
    //     MYSQL_DATABASE: secrets.mcp_server_mysql.database,
    //   },
    // },
    // playwright: {
    //   command: bin('npx'),
    //   args: ['@playwright/mcp@latest'],
    // },
    // "awslabs.aws-documentation-mcp-server": {
    //   command: bin('uvx'),
    //   args: ["awslabs.aws-documentation-mcp-server@latest"],
    //   env: {
    //     "FASTMCP_LOG_LEVEL": "ERROR"
    //   }
    // },
    // github: {
    //   command: '/etc/profiles/per-user/shuntaka/bin/docker',
    //   args: [
    //     'run',
    //     '-i',
    //     '--rm',
    //     '-e',
    //     'GITHUB_PERSONAL_ACCESS_TOKEN',
    //     'ghcr.io/github/github-mcp-server',
    //   ],
    //   env: {
    //     GITHUB_PERSONAL_ACCESS_TOKEN: secrets.github.token,
    //   },
    // },
    // backlog: {
    //   command: '/etc/profiles/per-user/shuntaka/bin/docker',
    //   args: [
    //     'run',
    //     '--pull',
    //     'always',
    //     '-i',
    //     '--rm',
    //     '-e',
    //     'BACKLOG_DOMAIN',
    //     '-e',
    //     'BACKLOG_API_KEY',
    //     'ghcr.io/nulab/backlog-mcp-server',
    //   ],
    //   env: {
    //     BACKLOG_DOMAIN: secrets.backlog.domain,
    //     BACKLOG_API_KEY: secrets.backlog.token,
    //   },
    // },
    // 'aws.dp-mcp': {
    //   command: bin('uvx'),
    //   args: [
    //     'awslabs.aws-dataprocessing-mcp-server@latest',
    //     '--allow-write',
    //     '--allow-sensitive-data-access',
    //   ],
    //   env: {
    //     AWS_PROFILE: 'iot-demo',
    //     AWS_REGION: 'ap-northeast-1',
    //   },
    // },
  },
}
