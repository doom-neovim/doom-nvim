local fidget = {}

fidget.settings = {
}

fidget.packages = {
  ["fidget.nvim"] = {
    "j-hui/fidget.nvim",
    commit = "d47f2bbf7d984f69dc53bf2d37f9292e3e99ae8a",
    after = "nvim-lspconfig",
  },
}

fidget.configs = {}
fidget.configs["fidget.nvim"] = function()
  require("fidget").setup(doom.modules.lsp_progress.settings)
end

return fidget
