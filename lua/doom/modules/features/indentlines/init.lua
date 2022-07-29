local indentlines = {}

indentlines.settings = {
  char = "│",
  use_treesitter = true,
  show_first_indent_level = false,
  filetype_exclude = { "help", "dashboard", "packer", "norg", "DoomInfo" },
  buftype_exclude = { "terminal" },
}

indentlines.packages = {
  ["indent-blankline.nvim"] = {
    "lukas-reineke/indent-blankline.nvim",
    commit = "c15bbe9f23d88b5c0b4ca45a446e01a0a3913707",
    event = "ColorScheme",
  },
}

indentlines.configs = {}
indentlines.configs["indent-blankline.nvim"] = function()
  require("indent_blankline").setup(
    vim.tbl_deep_extend("force", doom.features.indentlines.settings, {
      -- To remove indent lines, remove the module. Having the module and
      -- disabling it makes no sense.
      enabled = true,
    })
  )
end

return indentlines
