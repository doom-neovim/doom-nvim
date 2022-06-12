local fidget = {}

fidget.settings = {
}

fidget.packages = {
  ["fidget.nvim"] = {
    "j-hui/fidget.nvim",
    commit = "37d536bbbee47222ddfeca0e8186e8ee6884f9a2",
    after = "nvim-lspconfig",
  },
}

fidget.configs = {}
fidget.configs["fidget.nvim"] = function()
  require("fidget").setup(doom.features.lsp_progress.settings)
end

return fidget
