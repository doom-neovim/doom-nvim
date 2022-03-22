local autopairs = {}

autopairs.settings = {
  enable_afterquote = true,
  enable_check_bracket_line = true,
  enable_moveright = true,
}

autopairs.uses = {
  ["nvim-autopairs"] = {
    "windwp/nvim-autopairs",
    commit = "771fda8d169384d345c8bbf2f871b75ba4a2dee5",
    event = "BufReadPost",
  },
}

autopairs.configs = {}
autopairs.configs["nvim-autopairs"] = function()
  require("nvim-autopairs").setup(vim.tbl_deep_extend("force", doom.modules.autopairs.settings, { check_ts = true }))
end

autopairs.binds = {
  "<leader>", name = "+prefix", {
    { "t", name = "+tweak", {
        { "p", function() require("doom.core.functions").toggle_autopairs() end, name = "Toggle autopairs" },
      },
    },
  },
}
return autopairs
