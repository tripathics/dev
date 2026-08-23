local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.font = wezterm.font_with_fallback({ "Iosevka" })
config.font_size = 16

config.line_height = 1.2

-- config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}
config.window_background_opacity = 0.85

config.color_scheme = "carbonfox"

config.enable_kitty_keyboard = true

return config
