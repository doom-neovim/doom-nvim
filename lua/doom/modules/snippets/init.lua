local snippets = {}

snippets.defaults = {
  history = true,
  updateevents = "TextChanged,TextChangedI",
}

snippets.packer_config = {}
snippets.packer_config["LuaSnip"] = function()
  require("luasnip").config.set_config(doom.snippets)
  require("luasnip.loaders.from_vscode").load()
end

return snippets
