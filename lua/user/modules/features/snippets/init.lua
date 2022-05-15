local up = require("user.utils").paths

local snippets = {}

snippets.settings = {
  history = true,
  updateevents = "TextChanged,TextChangedI",
}

snippets.packages = {
  ["LuaSnip"] = {
    "L3MON4D3/LuaSnip",
    commit = "80e68242cf8127844653060fbada32dca15579fc",
    requires = {
      { "rafamadriz/friendly-snippets", opt = true },
      { up.ghq.github .. "molleweide/LuaSnip-snippets.nvim" }, -- override with local versions in the `config.lua`
    },
  },
}

snippets.configs = {}
snippets.configs["LuaSnip"] = function()
  local ls = require("luasnip")
  -- ls.config.set_config(snippets.settings)
  -- ls.snippets = require("luasnip_snippets").load_snippets()
  require("luasnip.loaders.from_vscode").load()
end

return snippets
