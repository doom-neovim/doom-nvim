local autopairs = {}

autopairs.settings = {
  enable_afterquote = true,
  enable_check_bracket_line = true,
  enable_moveright = true,
}

autopairs.packages = {
  ["nvim-autopairs"] = {
    "windwp/nvim-autopairs",
    commit = "f00eb3b766c370cb34fdabc29c760338ba9e4c6c",
    event = "InsertEnter",
  },
}

autopairs.configs = {}
autopairs.configs["nvim-autopairs"] = function()
  require("nvim-autopairs").setup(
    vim.tbl_deep_extend("force", doom.features.autopairs.settings, { check_ts = true })
  )
end

autopairs.binds = {
  "<leader>",
  name = "+prefix",
  {
    {
      "t",
      name = "+tweak",
      {
        {
          "p",
          function()
            local autopairs_plugin = require("nvim-autopairs")
            if autopairs_plugin.state.disabled then
              autopairs_plugin.enable()
            else
              autopairs_plugin.disable()
            end
          end,
          name = "Toggle autopairs",
        },
      },
    },
  },
}
return autopairs
