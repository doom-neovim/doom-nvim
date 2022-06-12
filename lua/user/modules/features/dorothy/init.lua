local dorotho = {}

dorotho.packages = {}

-- autoformat dorothy on save.
dorothy.autocommands = {
  -- {
  --   "ColorScheme",
  --   "*",
  --   function()
  --     print("colorscheme update")
  --     print(vim.inspect(require('heirline').statusline))
  --     -- doom.modules.features.statusline2.configs["heirline.nvim"]()
  --   end,
  -- },
  -- {
  -- user
  --  - auto commit on change?
  --  -> qhq / tmux / other??
  -- }
}

-- dorotho.binds = {}
--
-- if require("doom.utils").is_module_enabled("whichkey") then
--   table.insert(dorotho.binds, {
--     "<leader>",
--     name = "+prefix",
--     {
--       {
--         "n",
--         name = "+test",
--         {
--           {
--             {
--               "w",
--               name = "+wm",
--               { "c", [[ :lua print("wm hello")<cr> ]], name = "wm hello" },
--             },
--           },
--         },
--       },
--     },
--   })
-- end

return dorothy
