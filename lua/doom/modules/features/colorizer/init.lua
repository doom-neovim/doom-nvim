local DoomModule = require('doom.modules').DoomModule

---@toc doom.features.colorizer
---@text # Code colorizer
---
--- Colorises colour strings within the nvim buffer
---

local colorizer = DoomModule.new("colorizer")

---@eval return doom.core.doc_gen.generate_settings_documentation(MiniDoc.current.eval_section, "features.colorizer")
colorizer.settings = {
  "*",
  css = { rgb_fn = true },
  html = { names = false },
}
---minidoc_afterlines_end

---@eval return doom.core.doc_gen.generate_packages_documentation("features.colorizer")
colorizer.packages = {
  ["nvim-colorizer.lua"] = {
    "norcalli/nvim-colorizer.lua",
    commit = "36c610a9717cc9ec426a07c8e6bf3b3abcb139d6",
    event = "WinEnter",
  },
}

colorizer.configs = {}
colorizer.configs["nvim-colorizer.lua"] = function()
  require("colorizer").setup(doom.features.colorizer.settings)
end

return colorizer
