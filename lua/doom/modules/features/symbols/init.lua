local symbols = {}

symbols.settings = {
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

symbols.packagesages = {
  ["symbols-outline.nvim"] = {
    "simrat39/symbols-outline.nvim",
    commit = "1361738c47892c3cee0d0b7a3b3bc7a8b48139c2",
    cmd = {
      "SymbolsOutline",
      "SymbolsOutlineOpen",
      "SymbolsOutlineClose",
    },
    opt = true,
  },
}



symbols.configs = {}
symbols.configs["symbols_outline.nvim"] = function()
  vim.g.symbols_outline = doom.modules.symbols.settings
end

symbols.binds = {
  { "<F2>", ":SymbolsOutline<CR>", name = "Toggle symbols outline" },
  {
    "<leader>",
    name = "+prefix",
    {
      {
        "o",
        name = "+open/close",
        {
          { "s", "<cmd>SymbolsOutline<CR>", name = "Symbol outline" },
        },
      },
    },
  }
}

return symbols
