local indentlines = {}

indentlines.defaults = {
  char = "│",
  use_treesitter = true,
  show_first_indent_level = false,
  filetype_exclude = { "help", "dashboard", "packer", "norg", "DoomInfo" },
  buftype_exclude = { "terminal" },
}

indentlines.packer_config = {}
indentlines.packer_config["indent-blankline.nvim"] = function()
  require("indent_blankline").setup(vim.tbl_deep_extend("force", doom.indentlines, {
    -- To remove indent lines, remove the module. Having the module and
    -- disabling it makes no sense.
    enabled = true,
  }))
end

return indentlines
