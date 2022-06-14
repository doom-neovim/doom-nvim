local snippets = {}

snippets.settings = {
  history = true,
  updateevents = "TextChanged,TextChangedI",
}

snippets.packages = {
  ["LuaSnip"] = {
    "L3MON4D3/LuaSnip",
    commit = "52f4aed58db32a3a03211d31d2b12c0495c45580",
    requires = { "rafamadriz/friendly-snippets", opt = true },
  },
}

snippets.configs = {}
snippets.configs["LuaSnip"] = function()
  require("luasnip").config.set_config(doom.features.snippets.settings)
  require("luasnip.loaders.from_vscode").lazy_load()
end

return snippets
