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
    commit = "db7cbcb40cc00fc5d6074d7569fb37197705e7f6",
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
