return {
  ["range-highlight.nvim"] = {
    "winston0410/range-highlight.nvim",
    commit = "8b5e8ccb3460b2c3675f4639b9f54e64eaab36d9",
    requires = {
      { "winston0410/cmd-parser.nvim", module = "cmd-parser" },
    },
    event = "BufReadPre",
  },
}
