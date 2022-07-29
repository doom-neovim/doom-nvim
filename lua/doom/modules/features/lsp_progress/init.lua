local fidget = {}

fidget.settings = {}

fidget.packages = {
  ["fidget.nvim"] = {
    "j-hui/fidget.nvim",
    commit = "492492e7d50452a9ace8346d31f6d6da40439f0e",
    after = "nvim-lspconfig",
  },
}

fidget.configs = {}
fidget.configs["fidget.nvim"] = function()
  require("fidget").setup(doom.features.lsp_progress.settings)
end

return fidget
