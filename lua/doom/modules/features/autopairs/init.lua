local autopairs = {}

autopairs.settings = {
  enable_afterquote = true,
  enable_check_bracket_line = true,
  enable_moveright = true,
}

autopairs.packages = {
  ["nvim-autopairs"] = {
    "windwp/nvim-autopairs",
    commit = "84cde3547e9a8b16db0bfe523e98e19b7be5148b",
    event = "BufReadPost",
  },
}

autopairs.configs = {}
autopairs.configs["nvim-autopairs"] = function()
  require("nvim-autopairs").setup(vim.tbl_deep_extend("force", doom.features.autopairs.settings, { check_ts = true }))
end

autopairs.binds = {
  "<leader>", name = "+prefix", {
    { "t", name = "+tweak", {
        { "p", function()
          local autopairs_plugin = require('nvim-autopairs')
          if autopairs_plugin.state.disabled then
            autopairs_plugin.enable()
          else
            autopairs_plugin.disable()
          end
        end, name = "Toggle autopairs" },
      },
    },
  },
}
return autopairs
