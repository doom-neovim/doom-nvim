local DoomModule = require('doom.modules').DoomModule

---@toc doom.features.trouble
---@text # Trouble
---
--- Shows project wide lsp diagnostics.
---
--- > ⚠️ Due to the way some LSPs are implemented it may only show diagnostics
--- > for current or recently opened buffers.

local trouble = DoomModule.new("trouble")

trouble.settings = {}

---@eval return doom.core.doc_gen.generate_settings_documentation(MiniDoc.current.eval_section, "features.trouble")
trouble.packages = {
  ["trouble.nvim"] = {
    "folke/trouble.nvim",
    commit = "929315ea5f146f1ce0e784c76c943ece6f36d786",
    cmd = { "Trouble", "TroubleClose", "TroubleRefresh", "TroubleToggle" },
    opt = true,
  },
}
---minidoc_afterlines_end

trouble.configs = {}
trouble.configs["trouble.nvim"] = function()
  require("trouble").setup(doom.features.trouble.settings)
end

---@eval return doom.core.doc_gen.generate_packages_documentation("features.trouble")
trouble.binds = {
  "<leader>",
  name = "+prefix",
  {
    {
      "o",
      name = "+open/close",
      {
        { "T", "<cmd>TroubleToggle<CR>", name = "Trouble" },
      },
    },
    {
      "c",
      name = "+code",
      {
        { "e", "<cmd>TroubleToggle<CR>", name = "Open trouble" },
        {
          "d",
          name = "+diagnostics",
          {
            { "t", "<cmd>TroubleToggle<CR>", name = "Trouble" },
          },
        },
      },
    },
  },
}

return trouble
