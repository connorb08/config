-- Tab bar behaviour and tab titles. Tab bar colours live in theme.lua.
local wezterm = require 'wezterm'

local TITLE_PAD = '   ' -- cells of padding either side of a tab title

local M = {}

function M.apply_to_config(config)
    config.use_fancy_tab_bar = false
    config.hide_tab_bar_if_only_one_tab = true
    config.tab_max_width = 32

    wezterm.on('format-tab-title', function(tab, _tabs, _panes, _config, _hover, max_width)
        local title = tab.active_pane.title

        -- Truncate so the title plus padding never exceeds max_width.
        local available = max_width - (#TITLE_PAD * 2)
        if available > 0 then
            title = wezterm.truncate_right(title, available)
        end

        return {
            { Text = TITLE_PAD .. title .. TITLE_PAD },
        }
    end)
end

return M
