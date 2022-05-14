local doom_user_settings_ui = {}

--  add override to `config.lua` file
--
--
--
--
--  TODO:
--
--  	1. first implement `doom.settings`
--  	2. pass table to picker
--  	3. if you select a leaf
--  		-> enter text input for field
--  	4. if selection has child
--  		-> put child in picker.
--
--  	5. telescope-table-edit-children-picker
--  	 	-> recursive picker
--  	 		-->> if not child_table then edit child
--  	 		-->> if child_table then picker(child_table)

----------------------------
-- SETTINGS
----------------------------

-- doom_user_settings_ui.settings = {}

----------------------------
-- PACKAGES
----------------------------

-- doom_user_settings_ui.packages = {
-- [""] = {},
-- -- [""] = {},
-- -- [""] = {},
-- -- [""] = {},
-- }

----------------------------
-- CONFIGS
----------------------------

----------------------------
-- CMDS
----------------------------

-- doom_user_settings_ui.cmds = {}

--------------------------
-- AUTOCMDS
--------------------------

-- doom_user_settings_ui.autocmds = {}

----------------------------
-- BINDS
----------------------------

-- doom_user_settings_ui.binds = {}

----------------------------
-- LEADER BINDS
----------------------------

-- if require("doom.utils").is_module_enabled("whichkey") then
--   table.insert(doom_user_settings_ui.binds, {
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

return doom_user_settings_ui


