local fidget = {}

fidget.settings = {
}

fidget.uses = {
  ["fidget.nvim"] = {
    "j-hui/fidget.nvim",
    commit = "cbe0db4f2adfddfd830310e5846f8735d4e068fa",
    after = "nvim-lspconfig",
  },
}

fidget.configs = {}
fidget.configs["fidget.nvim"] = function()
  require("fidget").setup(doom.modules.lsp_progress.settings)
end

return fidget
