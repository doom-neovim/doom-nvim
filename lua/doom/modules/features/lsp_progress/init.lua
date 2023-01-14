local fidget = {}

fidget.settings = {}

fidget.packages = {
  ["fidget.nvim"] = {
    "j-hui/fidget.nvim",
    commit = "44585a0c0085765195e6961c15529ba6c5a2a13b",
    after = "nvim-lspconfig",
    event = "VeryLazy",
  },
}

fidget.configs = {}
fidget.configs["fidget.nvim"] = function()
  require("fidget").setup(doom.features.lsp_progress.settings)
end

return fidget
