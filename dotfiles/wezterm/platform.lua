-- Which OS this config is running on. Shared by the other modules.
local wezterm = require 'wezterm'

local triple = wezterm.target_triple

local M = {
    is_windows = triple:find('windows') ~= nil,
    is_mac = triple:find('darwin') ~= nil,
    is_linux = triple:find('linux') ~= nil,
}

-- 'windows', 'mac', 'linux' or 'unknown'; handy as a table key.
M.name = M.is_windows and 'windows'
    or M.is_mac and 'mac'
    or M.is_linux and 'linux'
    or 'unknown'

return M
