local secrets = import 'secrets.jsonnet';
local home = std.extVar('HOME');
// mise の shim 経由にすることで node/python のバージョンを上げても追従する
local shims = home + '/.local/share/mise/shims';
local bin(name) = shims + '/' + name;
local defaultPath = shims + ':/usr/local/bin:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin';

{
  mcpServers: {
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
    // 'aws-knowledge-mcp-server': {
    //   command: 'mcp-remote',
    //   args: [
    //     'https://knowledge-mcp.global.api.aws',
    //   ],
    // },
    // 'aws-knowledge-mcp-server': {
    //   url: 'https://knowledge-mcp.global.api.aws',
    // },
    // github: {
    //   type: 'http',
    //   url: 'https://api.githubcopilot.com/mcp/',
    //   headers: {
    //     Authorization: 'Bearer ' + secrets.github.token,
    //   },
    // },
    // "Framelink Figma MCP": {
    //   "command": "npx",
    //   "args": ["-y", "figma-developer-mcp", "--figma-api-key=" + secrets.figma.token, "--stdio"]
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
    // postgres: {
    //   command: bin('uvx'),
    //   args: ['postgres-mcp-server'],
    //   env: {
    //     POSTGRES_HOST: secrets.postgres.host,
    //     POSTGRES_PORT: secrets.postgres.port,
    //     POSTGRES_USER: secrets.postgres.user,
    //     POSTGRES_PASSWORD: secrets.postgres.password,
    //     POSTGRES_DATABASE: secrets.postgres.database,
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
