-- Behaviour that is neither looks nor keys.
local M = {}

function M.apply_to_config(config)
    config.scrollback_lines = 20000
    config.audible_bell = 'Disabled'
    config.window_close_confirmation = 'NeverPrompt'
    -- Fullscreen without a separate macOS Space; on a notched MacBook it fills
    -- the strip beside the camera too, instead of stopping below it.
    config.native_macos_fullscreen_mode = false
    config.macos_fullscreen_extend_behind_notch = true
end

return M
