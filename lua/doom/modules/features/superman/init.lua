local DoomModule = require('doom.modules').DoomModule

---@toc doom.features.superman
---@text # Code superman
---
--- Read linux man pages inside of neovim
---

local superman = DoomModule.new("superman")

superman.settings = {}

---@eval return doom.core.doc_gen.generate_packages_documentation("features.superman")
superman.packages = {
  ["vim-superman"] = {
    "jez/vim-superman",
    commit = "19d307446576d9118625c5d9d3c7a4c9bec5571a",
    cmd = "SuperMan",
    opt = true,
  },
}

superman.configs = {}

return superman
