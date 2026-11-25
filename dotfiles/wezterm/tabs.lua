-- Tab bar behaviour and tab titles. Tab bar colours live in theme.lua.
local wezterm = require 'wezterm'

local MIN_TAB_WIDTH = 6

-- This tab's share of the row. WezTerm caps each tab at
--   (columns - (tabs - 1) - width of the "+" button) / tabs
-- and trims anything wider, so size the tabs to exactly that budget (the "+"
-- button's text is empty below, so it reserves nothing) and spread the
-- leftover cells over the first few tabs.
local function share_of_row(tab, tab_count, fallback)
    local ok, size = pcall(function()
        return wezterm.mux.get_tab(tab.tab_id):get_size()
    end)
    if not ok or not size or not size.cols then
        return fallback
    end
    local row = size.cols - (tab_count - 1)
    local width = math.floor(row / tab_count)
    if tab.tab_index < row % tab_count then
        width = width + 1
    end
    return math.max(width, MIN_TAB_WIDTH)
end

local M = {}

function M.apply_to_config(config)
    config.use_fancy_tab_bar = false
    config.hide_tab_bar_if_only_one_tab = true
    -- No "+" button: tabs share the whole row (new tab is Cmd-Shift-T).
    config.show_new_tab_button_in_tab_bar = false
    -- WezTerm still reserves the hidden button's width unless its text is empty.
    config.tab_bar_style = { new_tab = '', new_tab_hover = '' }
    -- Tabs share the whole row (format-tab-title below sizes them), so only a
    -- generous cap here.
    config.tab_max_width = 512

    wezterm.on('format-tab-title', function(tab, tabs, _panes, _config, _hover, max_width)
        local width = share_of_row(tab, #tabs, max_width)
        -- Centre the title in its share, truncated to leave a cell either side.
        local title = wezterm.truncate_right(tab.active_pane.title, width - 2)
        local spare = width - wezterm.column_width(title)
        local left = math.floor(spare / 2)
        return {
            { Text = string.rep(' ', left) .. title .. string.rep(' ', spare - left) },
        }
    end)
end

return M
