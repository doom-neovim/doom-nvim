local snippets = {}

snippets.settings = {
  history = true,
  updateevents = "TextChanged,TextChangedI",
}

snippets.packages = {
  ["LuaSnip"] = {
    "L3MON4D3/LuaSnip",
    commit = "cc0086390c6cd2eaebae1834b115c891649ec95f",
    requires = { "rafamadriz/friendly-snippets", opt = true },
  },
}

snippets.configs = {}
snippets.configs["LuaSnip"] = function()
  require("luasnip").config.set_config(doom.modules.snippets.settings)
  require("luasnip.loaders.from_vscode").lazy_load()
end

return snippets
