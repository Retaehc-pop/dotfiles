local M = {}

function M.setup()
  require('base16-colorscheme').setup {
    -- Background tones
    base00 = '#14130e', -- Default Background
    base01 = '#21201a', -- Lighter Background (status bars)
    base02 = '#2b2a24', -- Selection Background
    base03 = '#949181', -- Comments, Invisibles
    -- Foreground tones
    base04 = '#cbc7b5', -- Dark Foreground (status bars)
    base05 = '#e6e2d9', -- Default Foreground
    base06 = '#e6e2d9', -- Light Foreground
    base07 = '#e6e2d9', -- Lightest Foreground
    -- Accent colors
    base08 = '#ffb4ab', -- Variables, XML Tags, Errors
    base09 = '#a5d0ba', -- Integers, Constants
    base0A = '#ccc8a3', -- Classes, Search Background
    base0B = '#d3ca52', -- Strings, Diff Inserted
    base0C = '#a5d0ba', -- Regex, Escape Chars
    base0D = '#d3ca52', -- Functions, Methods
    base0E = '#ccc8a3', -- Keywords, Storage
    base0F = '#93000a', -- Deprecated, Embedded Tags
  }
end

-- Register a signal handler for SIGUSR1 (matugen updates)
local signal = vim.uv.new_signal()
signal:start(
  'sigusr1',
  vim.schedule_wrap(function()
    package.loaded['matugen'] = nil
    require('matugen').setup()
  end)
)

return M
