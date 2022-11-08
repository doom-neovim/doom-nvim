local DoomModule = require('doom.modules').DoomModule

---@toc doom.features.terminal
---@text # Code terminal
---
--- Adds the ability to generate terminal from function, class or variable
--- signatures.
---

local terminal = DoomModule.new("terminal")

---@eval return doom.core.doc_gen.generate_settings_documentation(MiniDoc.current.eval_section, "features.terminal")
terminal.settings = {
  size = 10,
  open_mapping = "<F4>",
  hide_numbers = true,
  shade_filetypes = {},
  shade_terminals = true,
  start_in_insert = true,
  persist_size = true,
  direction = "horizontal",
  close_on_exit = true,
  float_opts = {
    border = "curved",
    width = 70,
    height = 20,
    winblend = 0,
    highlights = {
      border = "Special",
      background = "Normal",
    },
  },
}
---minidoc_afterlines_end

---@eval return doom.core.doc_gen.generate_packages_documentation("features.terminal")
terminal.packages = {
  ["toggleterm.nvim"] = {
    "akinsho/toggleterm.nvim",
    commit = "2a787c426ef00cb3488c11b14f5dcf892bbd0bda",
    cmd = { "ToggleTerm", "TermExec" },
    opt = true,
  },
}

terminal.configs = {}
terminal.configs["toggleterm.nvim"] = function()
  require("toggleterm").setup(doom.features.terminal.settings)
end

---@eval return doom.core.doc_gen.generate_keybind_documentation("features.terminal")
terminal.binds = {
  "<leader>",
  name = "+prefix",
  {
    {
      "o",
      name = "+open/close",
      {
        { "t", "<cmd>ToggleTerm<CR>", name = "Terminal" },
      },
    },
  },
}

return terminal
