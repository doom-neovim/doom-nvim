local DoomModule = require('doom.modules').DoomModule

---@toc doom.features.editorconfig
---@text # Editorconfig
---
--- Adds support for per-project [editorconfig](https://editorconfig.org/) files.
---

local editorconfig = DoomModule.new("editorconfig")

editorconfig.settings = {}

---@eval return doom.core.doc_gen.generate_packages_documentation("features.editorconfig")
editorconfig.packages = {
  ["editorconfig-vim"] = {
    "editorconfig/editorconfig-vim",
    commit = "d354117b72b3b43b75a29b8e816c0f91af10efe9",
  },
}

editorconfig.configs = {}

return editorconfig
