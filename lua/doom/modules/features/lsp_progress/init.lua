local fidget = {}

fidget.settings = {}

fidget.packages = {
  ["fidget.nvim"] = {
    "j-hui/fidget.nvim",
    commit = "1097a86db8ba38e390850dc4035a03ed234a4673",
    after = "nvim-lspconfig",
  },
}

fidget.configs = {}
fidget.configs["fidget.nvim"] = function()
  require("fidget").setup(doom.features.lsp_progress.settings)
end

return fidget
