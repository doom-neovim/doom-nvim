return function()
  local config = require("doom.core.config").config

  require("indent_blankline").setup({
    enabled = config.doom.show_indent,
    char = "│",
    -- If treesitter plugin is enabled then use its indentation
    use_treesitter = require("doom.utils").check_plugin("nvim-treesitter", "opt"),
    show_first_indent_level = false,
    filetype_exclude = { "help", "dashboard", "packer", "norg", "DoomInfo" },
    buftype_exclude = { "terminal" },
  })
end
