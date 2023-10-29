local indentlines = {}

indentlines.settings = {
  indent = {
    char = "│",
  },
  exclude = {
    filetypes = { "help", "dashboard", "packer", "norg", "DoomInfo" },
    buftypes = { "terminal" },
  }
}

indentlines.packages = {
  ["indent-blankline.nvim"] = {
    "lukas-reineke/indent-blankline.nvim",
  },
}

indentlines.configs = {}
indentlines.configs["indent-blankline.nvim"] = function()
  require("ibl").setup(
    vim.tbl_deep_extend("force", doom.features.indentlines.settings, {
      -- To remove indent lines, remove the module. Having the module and
      -- disabling it makes no sense.
      enabled = true,
    })
  )
end

return indentlines
