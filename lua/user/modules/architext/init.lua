local ts_architext_ui = {}

-- TODO:
--
--    -  play around with the plugin and learn how it works, then make a cool ui
--    	for it that makes it look cool when you make queries.
--
--    	floating popup ui where I can use keys to jump around between these ui windows.
--    	also add mappings for moving the ui around. or repositioning the floats.
--
--    	this is stupid but it is also fun and good practice to play around with UI placement etc.
--
--    	TODO: add ability to apply architext to a file, instead of a buffer.
--
--    	TODO: highlight captures from repl query.

----------------------------
-- SETTINGS
----------------------------

ts_architext_ui.settings = {}

----------------------------
-- PACKAGES
----------------------------

ts_architext_ui.packages = {
  ["architext.nvim"] = { doom.settings.local_plugins_path .. "vigoux/architext.nvim" },
-- [""] = {},
-- [""] = {},
-- [""] = {},
}

----------------------------
-- CONFIGS
----------------------------

----------------------------
-- CMDS
----------------------------

-- ts_architext_ui.cmds = {}

--------------------------
-- AUTOCMDS
--------------------------

-- ts_architext_ui.autocmds = {}

----------------------------
-- BINDS
----------------------------

-- ts_architext_ui.binds = {}

----------------------------
-- LEADER BINDS
----------------------------

-- if require("doom.utils").is_module_enabled("whichkey") then
--   table.insert(ts_architext_ui.binds, {
--     "<leader>",
--     name = "+prefix",
--     {
--       {
--         "YYY",
--         name = "+ZZZ",
--         {
--         -- first level
--         },
--       },
--     },
--   })
-- end

----------------------------
-- RETURN
----------------------------

return ts_architext_ui


