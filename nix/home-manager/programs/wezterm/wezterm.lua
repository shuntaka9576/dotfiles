-- ~/.wezterm.lua
local wezterm = require("wezterm")

return {
  color_scheme = "Dracula (Official)",
  automatically_reload_config = true,
  initial_cols = 200,
  initial_rows = 60,
  window_padding = {
    left = 10,
    right = 10,
    top = 0,
    bottom = 0,
  },
  window_background_opacity = 1.0,
  default_cursor_style = "SteadyBar",
  scrollback_lines = 100000,
  mouse_wheel_scroll_speed = 3,
  front_end = "WebGpu",
  font = wezterm.font("Hack Nerd Font"),
  font_size = 13.0,
  keys = {
    {
      key = "¥",
      mods = "NONE",
      action = wezterm.action({ SendString = "\\" }),
    },
    {
      key = "=",
      mods = "CMD",
      action = wezterm.action.IncreaseFontSize,
    },
    {
      key = "-",
      mods = "CMD",
      action = wezterm.action.DecreaseFontSize,
    },
    {
      key = "0",
      mods = "CMD",
      action = wezterm.action.ResetFontSize,
    },
  },
}
