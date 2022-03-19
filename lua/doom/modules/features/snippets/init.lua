local snippets = {}

snippets.settings = {
  history = true,
  updateevents = "TextChanged,TextChangedI",
}

snippets.uses = {
  ["LuaSnip"] = {
    "L3MON4D3/LuaSnip",
    commit = "7c634ddf7ff99245ef993b5fa459c3b61e905075",
    requires = { "rafamadriz/friendly-snippets", opt = true },
    event = "InsertEnter",
  },
}

snippets.configs = {}
snippets.configs["LuaSnip"] = function()
  require("luasnip").config.set_config(doom.modules.snippets.settings)
  require("luasnip.loaders.from_vscode").load()
end

return snippets
