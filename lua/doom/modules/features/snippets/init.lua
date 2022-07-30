local snippets = {}

snippets.settings = {
  history = true,
  updateevents = "TextChanged,TextChangedI",
}

snippets.packages = {
  ["friendly-snippets"] = {
    "rafamadriz/friendly-snippets",
    after = "LuaSnip"
  },
}

snippets.configs = {}
snippets.configs["friendly-snippets"] = function()
  require("luasnip.loaders.from_vscode").lazy_load()
end

return snippets
