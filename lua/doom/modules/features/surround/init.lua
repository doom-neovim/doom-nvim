local surround = {}

surround.settings = {}

surround.packages = {
  ["vim-surround"] = { "tpope/vim-surround" },
  -- ["surround.nvim"] = { "ur4ltz/surround.nvim" }, -- pure lua
  -- https://github.com/echasnovski/mini.nvim/blob/main/lua/mini/surround.lua
  -- [""] = { 'echasnovski/mini.nvim', branch = 'stable' }
}

surround.configs = {}

-- surround.configs["surround.nvim"] = function()
--   require("surround").setup({
--     context_offset = 100,
--     load_autogroups = false,
--     mappings_style = "surround", -- sandwich uses `s` | surround uses `y`
--     map_insert_mode = true,
--     quotes = { "'", '"' },
--     brackets = { "(", "{", "[" },
--     space_on_closing_char = false,
--     pairs = {
--       nestable = { b = { "(", ")" }, s = { "[", "]" }, B = { "{", "}" }, a = { "<", ">" } },
--       linear = { q = { "'", "'" }, t = { "`", "`" }, d = { '"', '"' } },
--       prefix = "s",
--     },
--   })
-- end

-- surround.configs["mini"] = function()
--   require('mini.surround').setup()
-- end


surround.binds = {}

-- https://github.com/justinmk/vim-sneak/issues/268
-- map ds       <Plug>Dsurround
-- nmap cs       <Plug>Csurround
-- nmap cS       <Plug>CSurround
-- nmap ys       <Plug>Ysurround
-- nmap yS       <Plug>YSurround
-- nmap yss      <Plug>Yssurround
-- nmap ySs      <Plug>YSsurround
-- nmap ySS      <Plug>YSsurround
-- xmap gs       <Plug>VSurround
-- xmap gS       <Plug>VgSurround
-- normal mode

-- TODO: move into `doom.settings`
table.insert(surround.binds, {
  { "z", "<Plug>VSurround", mode = "x", name = "surr" },
  { "yzz", "<Plug>Yssurround", mode = "n", name = "surr" }, -- double ss
  { "yz", "<Plug>Ysurround", mode = "n", name = "surr" }, -- single s
  { "dz", "<Plug>Dsurround", mode = "n", name = "surr" },
  { "cz", "<Plug>Csurround", mode = "n", name = "surr" },
})

return surround
