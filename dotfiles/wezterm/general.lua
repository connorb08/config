-- Behaviour that is neither looks nor keys.
local M = {}

function M.apply_to_config(config)
    config.scrollback_lines = 20000
    config.audible_bell = 'Disabled'
    config.window_close_confirmation = 'NeverPrompt'
    config.native_macos_fullscreen_mode = false
end

return M
