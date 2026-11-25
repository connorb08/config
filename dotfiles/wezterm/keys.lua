-- Key bindings.
local wezterm = require 'wezterm'
local platform = require 'platform'

local act = wezterm.action
local off = act.DisableDefaultAssignment
local maximized_windows = {}


-- SUPER is the Cmd key.
local mac_keys = {
    -- Give these back to the programs running in the terminal instead of
    -- opening tabs and panes (the same set the Ghostty config unbinds).
    { key = 't',          mods = 'SUPER',       action = off },
    { key = 'w',          mods = 'SUPER',       action = off },
    { key = 'd',          mods = 'SUPER',       action = off },
    { key = 'd',          mods = 'SUPER|SHIFT', action = off },
    { key = 'a',          mods = 'SUPER',       action = off },
    { key = '.',          mods = 'SUPER',       action = off },
    { key = 'DownArrow',  mods = 'SUPER|SHIFT', action = off },
    { key = 'r',          mods = 'CTRL|SHIFT',  action = off },

    -- New tab and close tab move to the shifted keys.
    { key = 't',          mods = 'SUPER|SHIFT', action = act.SpawnTab 'CurrentPaneDomain' },
    { key = 'w',          mods = 'SUPER|SHIFT', action = act.CloseCurrentTab { confirm = true } },

    -- Better handling

    -- Move cursor by word (Option + Left/Right)
    { key = 'LeftArrow',  mods = 'OPT',         action = act.SendKey { key = 'b', mods = 'ALT' } },
    { key = 'RightArrow', mods = 'OPT',         action = act.SendKey { key = 'f', mods = 'ALT' } },

    -- Move cursor to start/end of line (Cmd + Left/Right)
    { key = 'LeftArrow',  mods = 'CMD',         action = act.SendKey { key = 'a', mods = 'CTRL' } },
    { key = 'RightArrow', mods = 'CMD',         action = act.SendKey { key = 'e', mods = 'CTRL' } },

    -- Delete word backwards (Option + Backspace)
    { key = 'Backspace',  mods = 'OPT',         action = act.SendKey { key = 'w', mods = 'CTRL' } },

    -- Delete word forwards (Option + Delete/Fn+Backspace)
    { key = 'Delete',     mods = 'OPT',         action = act.SendKey { key = 'd', mods = 'ALT' } },

    -- Delete entire line to the left of cursor (Cmd + Backspace)
    { key = 'Backspace',  mods = 'CMD',         action = act.SendKey { key = 'u', mods = 'CTRL' } },

    -- Delete entire line to the right of cursor (Cmd + Delete/Fn+Backspace)
    { key = 'Delete',     mods = 'CMD',         action = act.SendKey { key = 'k', mods = 'CTRL' } },
    { key = 'X',          mods = 'CMD|SHIFT',   action = act.ActivateCopyMode },
}
-- for i = 1, 9 do
--     table.insert(mac_keys, { key = tostring(i), mods = 'SUPER', action = off })
-- end

local M = {}

function M.apply_to_config(config)
    -- Option is Alt on macOS. That is WezTerm's default for the left key;
    -- this makes the right key match.
    config.send_composed_key_when_right_alt_is_pressed = false
    -- Ensure Option keys act as Meta/Alt rather than typing special characters (like ß or ∂)
    -- config.send_composed_key_when_left_alt_is_pressed = false

    if platform.is_mac then
        config.keys = mac_keys
    end
end

return M
