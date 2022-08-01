local extra_snippets = {}

extra_snippets.settings = {}

extra_snippets.packages = {
  ["friendly-snippets"] = {
    "rafamadriz/friendly-snippets",
    after = "LuaSnip",
  },
}

extra_snippets.configs = {}
extra_snippets.configs["friendly-snippets"] = function()
  require("luasnip.loaders.from_vscode").lazy_load()
end

return extra_snippets
