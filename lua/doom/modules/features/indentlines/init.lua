local indentlines = {}

indentlines.settings = {
  char = "│",
  use_treesitter = true,
  show_first_indent_level = false,
  filetype_exclude = { "help", "dashboard", "packer", "norg", "DoomInfo" },
  buftype_exclude = { "terminal" },
}

indentlines.uses = {
  ["indent-blankline.nvim"] = {
    "lukas-reineke/indent-blankline.nvim",
    commit = "9915d46ba9361784c70036bb7259c436249e5b0c",
    event = "ColorScheme",
  },
}

indentlines.configs = {}
indentlines.configs["indent-blankline.nvim"] = function()
  require("indent_blankline").setup(vim.tbl_deep_extend("force", doom.modules.indentlines.settings, {
    -- To remove indent lines, remove the module. Having the module and
    -- disabling it makes no sense.
    enabled = true,
  }))
end

return indentlines
