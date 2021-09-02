return function()
  local config = require("doom.core.config").config

  vim.g.symbols_outline = {
    highlight_hovered_item = true,
    show_guides = true,
    position = config.doom.explorer_right and "left" or "right",
    keymaps = {
      close = "<Esc>",
      goto_location = "<CR>",
      focus_location = "o",
      hover_symbol = "<C-space>",
      rename_symbol = "r",
      code_actions = "a",
    },
    lsp_blacklist = {},
  }
end
