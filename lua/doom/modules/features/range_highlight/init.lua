local range_highlight = {}

range_highlight.settings = {}

range_highlight.packages = {
  ["range-highlight.nvim"] = {
    "winston0410/range-highlight.nvim",
    dependencies = {
      { "winston0410/cmd-parser.nvim" },
    },
    event = "VeryLazy",
  },
}

range_highlight.configs = {}
range_highlight.configs["range-highlight.nvim"] = function()
  require("range-highlight").setup(doom.features.range_highlight.settings)
end

return range_highlight
