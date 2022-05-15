local surround = {}

surround.settings = {}

-- 1. consider switching to nvim plugin because vim surround mappings just don't do anything ???
-- 2. add command that allows for wrapping selection in a `function() ... end``

surround.packages = {
  ["vim-surround"] = { "tpope/vim-surround" }, -- cs`' to change `` to '', etc
  -- ["surround.nvim"] = { "ur4ltz/surround.nvim" }, -- https://github.com/ur4ltz/surround.nvim
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

surround.binds = {}

----------------------------
---       surround       ---
----------------------------

-- https://github.com/justinmk/vim-sneak/issues/268

-- -- map ds       <Plug>Dsurround
-- -- nmap cs       <Plug>Csurround
-- -- nmap cS       <Plug>CSurround
-- -- nmap ys       <Plug>Ysurround
-- -- nmap yS       <Plug>YSurround
-- -- nmap yss      <Plug>Yssurround
-- -- nmap ySs      <Plug>YSsurround
-- -- nmap ySS      <Plug>YSsurround
-- -- xmap gs       <Plug>VSurround
-- -- xmap gS       <Plug>VgSurround
-- normal mode

table.insert(surround.binds, {
  { "z", "<Plug>VSurround", mode = "x", name = "surr" },
  { "yzz", "<Plug>Yssurround", mode = "n", name = "surr" }, -- double ss
  { "yz", "<Plug>Ysurround", mode = "n", name = "surr" }, -- single s
  { "dz", "<Plug>Dsurround", mode = "n", name = "surr" },
  { "cz", "<Plug>Csurround", mode = "n", name = "surr" },
})

-- test map with leader.
-- if require("doom.utils").is_module_enabled("whichkey") then
--   table.insert(surround.binds, {
--     "<leader>",
--     name = "+prefix",
--     {
--       {
--         "w",
--         name = "+windows",
--         {
--           { "z", [[<esc><cmd>suspend<CR>]], name = "suspend vim" },
--           -- { "S", [[<esc><CR>]], name = "solo window / close all others" }, -- nvim get windows > compare some idx/name > close match set
--           -- { "move"}
--           -- { "new/rm"}
--         },
--       },
--     },
--   })
-- end

return surround
