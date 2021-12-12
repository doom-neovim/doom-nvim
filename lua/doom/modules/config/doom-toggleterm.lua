return function()
  local config = require("doom.core.config").config

  require("toggleterm").setup({
    size = config.doom.terminal_height,
    open_mapping = [[<F4>]],
    hide_numbers = true,
    shade_filetypes = {},
    shade_terminals = true,
    start_in_insert = true,
    persist_size = true,
    direction = config.doom.terminal_direction,
    close_on_exit = true,
    float_opts = {
      border = "curved",
      width = config.doom.terminal_width,
      height = config.doom.terminal_height,
      winblend = 0,
      highlights = {
        border = "Special",
        background = "Normal",
      },
    },
  })
end
