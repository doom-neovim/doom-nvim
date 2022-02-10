local range_highlight = {}

range_highlight.defaults = {}

range_highlight.packages = {
  ["range-highlight.nvim"] = {
    "winston0410/range-highlight.nvim",
    commit = "8b5e8ccb3460b2c3675f4639b9f54e64eaab36d9",
    requires = {
      { "winston0410/cmd-parser.nvim", module = "cmd-parser" },
    },
    event = "BufReadPre",
  },
}

range_highlight.configure_functions = {}
range_highlight.configure_functions["range-highlight.nvim"] = function()
  require("range-highlight").setup(doom.range_highlight)
end

return range_highlight
