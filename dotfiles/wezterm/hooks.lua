local wezterm = require 'wezterm'
local M = {}
-- local mux = wezterm.mux

-- wezterm.on('gui-startup', function(cmd)
--   local tab, pane, window = mux.spawn_window(cmd or {})
--   window:gui_window():maximize()
-- end)
--
-- local seen_windows = {}

-- wezterm.on('window-config-reloaded', function(window, pane)
--   local id = tostring(window:window_id())
--   if not seen_windows[id] then
--     seen_windows[id] = true
--     window:maximize()
--   end
-- end)

function M.apply_to_config(config)
end

return M
