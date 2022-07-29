local snippets = {}

snippets.settings = {
  history = true,
  updateevents = "TextChanged,TextChangedI",
}

snippets.packages = {
  ["LuaSnip"] = {
    "L3MON4D3/LuaSnip",
    commit = "53e812a6f51c9d567c98215733100f0169bcc20a",
    requires = { "rafamadriz/friendly-snippets", opt = true },
  },
}

snippets.configs = {}
snippets.configs["LuaSnip"] = function()
  require("luasnip").config.set_config(doom.features.snippets.settings)
  require("luasnip.loaders.from_vscode").lazy_load()
end

return snippets
