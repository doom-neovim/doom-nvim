local DoomModule = require('doom.modules').DoomModule
---@toc doom.features.auto_session
---@text # Sessions
---
--- Save and restore neovim sessions

local auto_session = DoomModule.new("auto_session")

---@eval return doom.core.doc_gen.generate_settings_documentation(MiniDoc.current.eval_section, "features.auto_session")
auto_session.settings = {
  dir = vim.fn.stdpath("data") .. "/sessions/",
}

---@eval return doom.core.doc_gen.generate_packages_documentation("features.auto_session")
auto_session.packages = {
  ["persistence.nvim"] = {
    "folke/persistence.nvim",
    commit = "251e89523dabc94242d4a1f2226fc44a95c29d9e",
    module = "persistence",
  },
}

auto_session.configs = {}
auto_session.configs["persistence.nvim"] = function()
  require("persistence").setup(doom.features.auto_session.settings)
end

---@eval return doom.core.doc_gen.generate_keybind_documentation("features.auto_session")
auto_session.binds = {
  "<leader>",
  name = "+prefix",
  {
    {
      "q",
      name = "+quit",
      {
        {
          "r",
          function()
            require("persistence").load({ last = true })
          end,
          name = "Restore session",
        },
      },
    },
  },
}

return auto_session
