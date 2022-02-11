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
    commit = "2e35f7dcdc72f39b37c21e43cdb538d7a41c7e07",
    event = "ColorScheme",
  },
}

indentlines.configure_functions = {}
indentlines.configure_functions["indent-blankline.nvim"] = function()
  require("indent_blankline").setup(vim.tbl_deep_extend("force", doom.modules.indentlines.settings, {
    -- To remove indent lines, remove the module. Having the module and
    -- disabling it makes no sense.
    enabled = true,
  }))
end

return indentlines
