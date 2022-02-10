local autopairs = {}

autopairs.defaults = {
  enable_afterquote = true,
  enable_check_bracket_line = true,
  enable_moveright = true,
}

autopairs.packages = {
  ["nvim-autopairs"] = {
    "windwp/nvim-autopairs",
    commit = "97e454ce9b1371373105716d196c1017394bc947",
    event = "BufReadPost",
  },
}

autopairs.configure_functions = {}
autopairs.configure_functions["nvim-autopairs"] = function()
  require("nvim-autopairs").setup(vim.tbl_deep_extend("force", doom.autopairs, { check_ts = true }))
end

autopairs.binds = {
  "<leader>",
  name = "+prefix",
  {
    {
      "t",
      name = "+tweak",
      {
        { "p", require("doom.core.functions").toggle_autopairs, name = "Toggle autopairs" },
      },
    },
  },
}
return autopairs
