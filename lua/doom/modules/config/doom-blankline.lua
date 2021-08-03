return function()
  local config = require("doom.core.config").load_config()

  require("indent_blankline").init()
  require("indent_blankline").setup({
    enabled = config.doom.show_indent,
    char = "|",
    -- If treesitter plugin is enabled then use its indentation
    use_treesitter = require("doom.core.functions").check_plugin("nvim-treesitter", "opt")
        and true
      or false,
    show_first_indent_level = false,
    filetype_exclude = { "help", "dashboard", "packer" },
    buftype_exclude = { "terminal" },
  })
end
