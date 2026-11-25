-- Tab bar behaviour and tab titles. Tab bar colours live in theme.lua.
local wezterm = require 'wezterm'

local MIN_TAB_WIDTH = 6

-- How many cells the tab bar spans. It runs the full width of the window,
-- while the terminal area is narrower by the window padding, so measure the
-- window in pixels and divide by a cell's width (from the terminal area).
local function tab_bar_cells(tab)
    local mux_tab = wezterm.mux.get_tab(tab.tab_id)
    local size = mux_tab:get_size()
    local cols = size.cols
    local ok, dims = pcall(function()
        return mux_tab:window():gui_window():get_dimensions()
    end)
    if ok and dims and dims.pixel_width and (size.pixel_width or 0) > 0 then
        cols = math.floor(dims.pixel_width / (size.pixel_width / size.cols))
    end
    return cols
end

-- This tab's share of the row, split evenly between the tabs; the first few
-- take the leftover cells so the row is filled exactly.
local function share_of_row(tab, tab_count, fallback)
    local ok, row = pcall(tab_bar_cells, tab)
    if not ok or not row then
        return fallback
    end
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
