local DoomModule = require('doom.modules').DoomModule

---@toc doom.features.suda
---@text # Suda
---
--- Easily read and write files as a super user from a non super user neovim
--- session.
---

local suda = DoomModule.new("suda")

suda.settings = {}

---@eval return doom.core.doc_gen.generate_packages_documentation("features.suda")
suda.packages = {
  ["suda.vim"] = {
    "lambdalisue/suda.vim",
    commit = "6bffe36862faa601d2de7e54f6e85c1435e832d0",
    opt = true,
    cmd = { "SudaRead", "SudaWrite" },
  },
}

suda.configs = {}

---@eval return doom.core.doc_gen.generate_keybind_documentation("features.suda")
suda.binds = {
  "<leader>",
  name = "+prefix",
  {
    {
      "f",
      name = "+file",
      {
        { "R", "<cmd>SudaRead<CR>", name = "Read with sudo" },
        { "W", "<cmd>SudaWrite<CR>", name = "Write with sudo" },
      },
    },
  },
}

return suda
