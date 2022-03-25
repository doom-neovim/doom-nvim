local snippets = {}

snippets.settings = {
  history = true,
  updateevents = "TextChanged,TextChangedI",
}

snippets.packages = {
  ["LuaSnip"] = {
    "L3MON4D3/LuaSnip",
    commit = "80e68242cf8127844653060fbada32dca15579fc",
    requires = { "rafamadriz/friendly-snippets", opt = true },
  },
}

snippets.configs = {}
snippets.configs["LuaSnip"] = function()
  require("luasnip").config.set_config(doom.modules.snippets.settings)
  require("luasnip.loaders.from_vscode").load()
end

return snippets
