local wezterm = require("wezterm")

local keys = {
  { key = "=", mods = "CTRL", action = wezterm.action.IncreaseFontSize },
  { key = "-", mods = "CTRL", action = wezterm.action.DecreaseFontSize },
  { key = "0", mods = "CTRL", action = wezterm.action.ResetFontSize },
  { key = "f", mods = "CMD|CTRL", action = wezterm.action.ToggleFullScreen },
  { key = "Enter", mods = "SHIFT", action = wezterm.action.SendString("\n") },
}

return {
  enable_tab_bar = false,
  window_decorations = "RESIZE",
  native_macos_fullscreen_mode = true,
  automatically_reload_config = true,
  audible_bell = "SystemBeep",
  color_scheme = "Dracula (Official)",
  initial_cols = 200,
  initial_rows = 60,
  window_background_opacity = 1.0,
  default_cursor_style = "SteadyBlock",
  front_end = "WebGpu",
  font = wezterm.font_with_fallback({
    { family = "PlemolJP Console NF", assume_emoji_presentation = false },
    { family = "Symbols Nerd Font Mono", assume_emoji_presentation = false },
    { family = "Noto Emoji", assume_emoji_presentation = true },
  }),
  use_ime = true,
  allow_square_glyphs_to_overflow_width = "Always",
  adjust_window_size_when_changing_font_size = false,
  warn_about_missing_glyphs = true,
  window_padding = {
    left = "0.5cell",
    right = "0.5cell",
    top = "0.1cell",
    bottom = 0,
  },
  keys = keys,
  font_size = 14.0,
  enable_wayland = false,
  window_close_confirmation = "NeverPrompt",
  check_for_updates = false,
}
