local DoomModule = require('doom.modules').DoomModule
---@toc doom.features.lsp_progress
---@text # REPL
---
--- Adds a floating element that shows LSP loading progress

local lsp_progress = DoomModule.new("lsp_progress")

---@eval return doom.core.doc_gen.generate_settings_documentation(MiniDoc.current.eval_section, "features.lsp_progress")
lsp_progress.settings = {
  -- Passed into `require("fidget").setup()`
  -- We just rely on the defaults
  fidget_settings = {},
}

---@eval return doom.core.doc_gen.generate_packages_documentation("features.lsp_progress")
lsp_progress.packages = {
  ["fidget.nvim"] = {
    "j-hui/fidget.nvim",
    commit = "1097a86db8ba38e390850dc4035a03ed234a4673",
    after = "nvim-lspconfig",
  },
}

lsp_progress.configs = {}
lsp_progress.configs["fidget.nvim"] = function()
  require("fidget").setup(doom.features.lsp_progress.settings.fidget_settings)
end

return lsp_progress
