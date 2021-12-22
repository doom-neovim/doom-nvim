local symbols = {}

symbols.defaults = {
  highlight_hovered_item = true,
  show_guides = true,
  position = "right",
  keymaps = {
    close = "<Esc>",
    goto_location = "<CR>",
    focus_location = "o",
    hover_symbol = "<C-space>",
    rename_symbol = "r",
    code_actions = "a",
  },
  lsp_blacklist = {},
  width = 25,
}

symbols.packer_config = {}
symbols.packer_config["symbols_outline.nvim"] = function()
  vim.g.symbols_outline = doom.symbols
end

return symbols
