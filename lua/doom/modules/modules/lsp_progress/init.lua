local fidget = {}

fidget.settings = {
}

fidget.packages = {
  ["fidget.nvim"] = {
    "j-hui/fidget.nvim",
    commit = "956683191df04c5a401e1f1fb2e53b957fbcecaa",
    after = "nvim-lspconfig",
  },
}

fidget.configs = {}
fidget.configs["fidget.nvim"] = function()
  require("fidget").setup(doom.modules.lsp_progress.settings)
end

return fidget
