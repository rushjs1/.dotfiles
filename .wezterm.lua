--pull in the wezterm API
local wezterm = require("wezterm")

--this will hold the configuration
local config = wezterm.config_builder()

-- my coolnight colorscheme:
config.colors = {
	-- The default text color
	foreground = "#ECE0EC",
	-- The default background color
	background = "#010C18",

	-- Overrides the cell background color when the current cell is occupied by the
	-- cursor and the cursor style is set to Block
	cursor_bg = "#38FF9D",
	-- Overrides the text color when the current cell is occupied by the cursor
	cursor_fg = "#000000",
	-- Specifies the border color of the cursor when the cursor style is set to Block,
	-- or the color of the vertical or horizontal bar when the cursor style is set to
	-- Bar or Underline.
	cursor_border = "#38FF9D",

	-- the foreground color of selected text
	selection_fg = "#000000",
	-- the background color of selected text
	selection_bg = "#38FF9D",

	-- The color of the scrollbar "thumb"; the portion that represents the current viewport
	scrollbar_thumb = "#222222",

	-- The color of the split lines between panes
	split = "#222222",

	ansi = {
		"#0A3B61", -- black
		"#FF3A3A", -- red
		"#38FF9D", -- green
		"#FFF383", -- yellow
		"#378EFF", -- blue
		"#C792EA", -- magenta (purple)
		"#FF5ED4", -- cyan
		"#16FD9F", -- white
	},
	brights = {
		"#626869", -- bright black
		"#FF5454", -- bright red
		"#38FF9D", -- bright green
		"#FCF5AE", -- bright yellow
		"#378EFF", -- bright blue
		"#AE81FF", -- bright magenta (purple)
		"#FF6AD7", -- bright cyan
		"#60FBC0", -- bright white
	},

	-- Arbitrary colors of the palette in the range from 16 to 255
	indexed = {
		[136] = "#AF87D7",
	},

	-- Since: 20220319-142410-0fcdea07
	-- When the IME, a dead key or a leader key are being processed and are effectively
	-- holding input pending the result of input composition, change the cursor
	-- to this color to give a visual cue about the compose state.
	compose_cursor = "#38FF9D",
}

--config.font = wezterm.font("MesloLGS Nerd Font Mono", { weight = "Regular" })
config.font_size = 18

config.window_background_opacity = 0.75
config.window_padding = {
	left = "0pt",
	right = "0pt",
	top = "0pt",
	bottom = "0pt",
}

config.keys = {
	{
		key = "k",
		mods = "CMD",
		action = wezterm.action.ClearScrollback("ScrollbackAndViewport"),
	},
	{
		key = "Escape",
		mods = "SHIFT",
		action = wezterm.action.ToggleFullScreen,
	},
}

for i = 1, 8 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = "CTRL",
		action = wezterm.action.MoveTab(i - 1),
	})
end

return config
