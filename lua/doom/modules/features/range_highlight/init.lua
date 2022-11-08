local DoomModule = require('doom.modules').DoomModule

---@toc doom.features.range_highlight
---@text # Range Highlight
---
--- Highlights the current range entered in the command line.
---

local range_highlight = DoomModule.new("range_highlight")

range_highlight.settings = {}

---@eval return doom.core.doc_gen.generate_packages_documentation("features.range_highlight")
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

range_highlight.configs = {}
range_highlight.configs["range-highlight.nvim"] = function()
  require("range-highlight").setup(doom.features.range_highlight.settings)
end

return range_highlight
