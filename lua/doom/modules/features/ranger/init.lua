local DoomModule = require('doom.modules').DoomModule

---@toc doom.features.ranger
---@text # Ranger
---
--- File exploring using [ranger](https://github.com/ranger/ranger).
---

local ranger = DoomModule.new("ranger")

ranger.settings = {}

---@eval return doom.core.doc_gen.generate_packages_documentation("features.ranger")
ranger.packages = {
  ["ranger.vim"] = {
    "francoiscabrol/ranger.vim",
    commit = "91e82debdf566dfaf47df3aef0a5fd823cedf41c",
    requires = {
      { "rbgrouleff/bclose.vim", opt = true },
    },
    opt = true,
    cmd = {
      "Ranger",
      "RangerNewTab",
      "RangerWorkingDirectory",
      "RangerWorkingDirectoryNewTab",
    },
  },
}

ranger.configs = {}

---@eval return doom.core.doc_gen.generate_keybind_documentation("features.ranger")
ranger.binds = {
  "<leader>",
  name = "+prefix",
  {
    {
      "o",
      name = "+open/close",
      {
        { "r", "<cmd>Ranger<CR>", name = "Ranger" },
      },
    },
  },
}

return ranger
