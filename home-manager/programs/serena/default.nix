{
  config,
  pkgs,
  lib,
  ...
}:
let
  yamlFormat = pkgs.formats.yaml { };
  projects = import ./projects.nix;
  serenaConfig = {
    gui_log_window = false;
    web_dashboard = true;
    web_dashboard_open_on_launch = false;
    log_level = 20;
    trace_lsp_communication = false;
    tool_timeout = 240;
    excluded_tools = [ ];
    included_optional_tools = [ ];
    jetbrains = false;
    record_tool_usage_stats = false;
    token_count_estimator = "TIKTOKEN_GPT4O";
    inherit projects;
  };
in
{
  home.file.".serena/serena_config.yml" = {
    source = yamlFormat.generate "serena_config.yml" serenaConfig;
  };
}
