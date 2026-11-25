-- Fonts, colour scheme and window chrome.
local wezterm = require 'wezterm'
local theme = require 'theme'

-- Terminal text.
local font = wezterm.font_with_fallback {
    { family = 'Cascadia Code', weight = 'Medium' },
    'CaskaydiaCove Nerd Font',
}
local font_size = 16.0

-- WezTerm's own UI: title bar, command palette, character picker.
local ui_font = wezterm.font_with_fallback {
    { family = 'Google Sans Flex', weight = 500 },
    'CaskaydiaCove Nerd Font',
}
local ui_font_size = 16.0

local M = {}

function M.apply_to_config(config)
    config.color_schemes = { [theme.name] = theme.colors }
    config.color_scheme = theme.name

    config.font = font
    config.font_size = font_size
    config.line_height = 1.15
    config.cell_width = 1.0

    config.command_palette_font = ui_font
    config.command_palette_font_size = ui_font_size
    config.char_select_font = ui_font
    config.char_select_font_size = ui_font_size

    config.window_frame = { font = ui_font, font_size = ui_font_size }
    config.window_decorations = 'RESIZE'
    -- config.window_padding = { left = 80, right = 80, top = 60, bottom = 60 }
    config.window_padding = { left = 8, right = 8, top = 6, bottom = 6 }
    -- config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
end

return M
