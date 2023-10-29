local fidget = {}

fidget.settings = {}

fidget.packages = {
  ["fidget.nvim"] = {
    "j-hui/fidget.nvim",
    tag = "legacy",
    dependencies = {"neovim/nvim-lspconfig"},
    -- after = "nvim-lspconfig",
    event = "VeryLazy",
  },
}

fidget.configs = {}
fidget.configs["fidget.nvim"] = function()
  require("fidget").setup(doom.features.lsp_progress.settings)
end

return fidget
