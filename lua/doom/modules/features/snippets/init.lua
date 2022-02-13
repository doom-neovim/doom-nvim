local snippets = {}

snippets.settings = {
  history = true,
  updateevents = "TextChanged,TextChangedI",
}

snippets.packages = {
  ["LuaSnip"] = {
    "L3MON4D3/LuaSnip",
    commit = "eb84bb89933141fa0cd0683cb960fef975106dfd",
    requires = { "rafamadriz/friendly-snippets", opt = true },
    event = "InsertEnter",
  },
}

snippets.configure_functions = {}
snippets.configure_functions["LuaSnip"] = function()
  require("luasnip").config.set_config(doom.modules.snippets.settings)
  require("luasnip.loaders.from_vscode").load()
end

return snippets
