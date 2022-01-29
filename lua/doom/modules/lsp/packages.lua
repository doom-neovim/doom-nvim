local is_plugin_disabled = require("doom.utils").is_plugin_disabled

return {
  ["nvim-lspconfig"] = {
    "neovim/nvim-lspconfig",
    commit = "e7df7ecae0b0d2f997ea65e951ddbe98ca3e154b",
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
    commit = "d93104244c3834fbd8f3dd01da9729920e0b5fe7",
    after = is_plugin_disabled("snippets") or "LuaSnip",
  },
  ["cmp-nvim-lua"] = {
    "hrsh7th/cmp-nvim-lua",
    commit = "d276254e7198ab7d00f117e88e223b4bd8c02d21",
    after = "nvim-cmp",
  },
  ["cmp-nvim-lsp"] = {
    "hrsh7th/cmp-nvim-lsp",
    commit = "ebdfc204afb87f15ce3d3d3f5df0b8181443b5ba",
    after = "nvim-cmp",
  },
  ["cmp-path"] = {
    "hrsh7th/cmp-path",
    commit = "c5230cb439df9547294678d0f1c1465ad7989e5f",
    after = "nvim-cmp",
  },
  ["cmp-buffer"] = {
    "hrsh7th/cmp-buffer",
    commit = "f83773e2f433a923997c5faad7ea689ec24d1785",
    after = "nvim-cmp",
  },
  ["cmp_luasnip"] = {
    "saadparwaiz1/cmp_luasnip",
    commit = "d6f837f4e8fe48eeae288e638691b91b97d1737f",
    after = "nvim-cmp",
    disabled = is_plugin_disabled("snippets"),
  },
  ["lsp_signature.nvim"] = {
    "ray-x/lsp_signature.nvim",
    commit = "1178ad69ce5c2a0ca19f4a80a4048a9e4f748e5f",
    after = "nvim-lspconfig",
    opt = true,
  },
}
