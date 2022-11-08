local DoomModule = require('doom.modules').DoomModule

---@toc doom.features.extra_snippets
---@text # Extra Snippets
---
--- Adds extra snippets for all languages.  This module depends on the `lsp` module.
---

local extra_snippets = DoomModule.new("extra_snippets")

extra_snippets.settings = {}

---@eval return doom.core.doc_gen.generate_packages_documentation("features.extra_snippets")
extra_snippets.packages = {
  ["friendly-snippets"] = {
    "rafamadriz/friendly-snippets",
    after = "LuaSnip",
  },
}

extra_snippets.requires_modules = { "features.lsp" }
extra_snippets.configs = {}
extra_snippets.configs["friendly-snippets"] = function()
  require("luasnip.loaders.from_vscode").lazy_load()
end

return extra_snippets
