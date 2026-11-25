-- What runs in a new tab: the shell, its starting directory and environment.
local wezterm = require 'wezterm'
local platform = require 'platform'

local home = wezterm.home_dir

local M = {}

function M.apply_to_config(config)
    -- macOS/Linux: no default_prog, so WezTerm starts the account's login shell
    -- (the one `chsh` sets) as a login shell. Windows has no login shell.
    if platform.is_windows then
        config.default_prog = { 'pwsh.exe', '-NoLogo' }
    end

    config.default_cwd = home

    if not platform.is_windows then
        -- The shells and the tools they run (k9s, yazi) find their config
        -- through this; apps started from the Dock get no shell environment.
        config.set_environment_variables = { XDG_CONFIG_HOME = home .. '/.config' }
    end
end

return M
