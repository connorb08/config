-- WezTerm: the same config on macOS, Windows and Linux.
--
-- This file only wires modules together. Each module lives next to it and
-- exports apply_to_config(config); to add one, create the file and list it
-- below.
local wezterm = require 'wezterm'

local config = wezterm.config_builder()
wezterm.add_to_config_reload_watch_list(wezterm.config_dir)

local modules = {
    'general',    -- scrollback, bell, close confirmation
    'shell',      -- default program, cwd, environment
    'appearance', -- fonts, colour scheme, window chrome
    'tabs',       -- tab bar and tab titles
    'keys',       -- key bindings
    'hooks',
}

-- config.enable_kitty_keyboard = true

for _, name in ipairs(modules) do
    require(name).apply_to_config(config)
end

-- wezterm.on('window-config-reloaded', function(window, pane)
--     window:toast_notification('WezTerm', 'Configuration reloaded!', nil, 4000)
-- end)

return config
