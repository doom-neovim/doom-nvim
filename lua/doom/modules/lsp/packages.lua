local is_plugin_disabled = require("doom.utils").is_plugin_disabled

return {
  ["nvim-lspconfig"] = {
    "neovim/nvim-lspconfig",
    commit = "5dc61fa6bf837b91c4de2ed95ba6c840e47d25ac",
    opt = true,
    cmd = {
      "LspStart",
      "LspRestart",
      "LspStop",
    },
    module = "lspconfig",
  },
  ["nvim-cmp"] = {
    "hrsh7th/nvim-cmp",
    commit = "2e4270d02843d15510b3549354e238788ca07ca5",
    after = is_plugin_disabled("snippets") or "LuaSnip",
  },
  ["cmp-nvim-lua"] = {
    "hrsh7th/cmp-nvim-lua",
    commit = "d276254e7198ab7d00f117e88e223b4bd8c02d21",
    after = "nvim-cmp",
  },
  ["cmp-nvim-lsp"] = {
    "hrsh7th/cmp-nvim-lsp",
    commit = "134117299ff9e34adde30a735cd8ca9cf8f3db81",
    after = "nvim-cmp",
  },
  ["cmp-path"] = {
    "hrsh7th/cmp-path",
    commit = "81518cf6ae29f5f0c79cd47770ae90ff5225ee13",
    after = "nvim-cmp",
  },
  ["cmp-buffer"] = {
    "hrsh7th/cmp-buffer",
    commit = "a706dc69c49110038fe570e5c9c33d6d4f67015b",
    after = "nvim-cmp",
  },
  ["cmp_luasnip"] = {
    "saadparwaiz1/cmp_luasnip",
    commit = "16832bb50e760223a403ffa3042859845dd9ef9d",
    after = "nvim-cmp",
    disabled = is_plugin_disabled("snippets"),
  },
  ["lsp_signature.nvim"] = {
    "ray-x/lsp_signature.nvim",
    commit = "c7b2b2e14b597c077804ae201f1ec9a7dac76ad0",
    after = "nvim-lspconfig",
    opt = true,
  },
}
