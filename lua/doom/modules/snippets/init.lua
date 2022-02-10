local snippets = {}

snippets.defaults = {
  history = true,
  updateevents = "TextChanged,TextChangedI",
}

snippets.packages = {
  ["LuaSnip"] = {
    "L3MON4D3/LuaSnip",
    commit = "35322c97b041542f95c85e87a8215892ea4137d5",
    requires = { "rafamadriz/friendly-snippets", opt = true },
    event = "InsertEnter",
  },
}

snippets.configure_functions = {}
snippets.configure_functions["LuaSnip"] = function()
  require("luasnip").config.set_config(doom.snippets)
  require("luasnip.loaders.from_vscode").load()
end

return snippets
