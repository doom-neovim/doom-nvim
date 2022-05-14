local ui_pipeline = {}

-- TODO:
--
--    - this should probably go into a util/ui...
--    - allow for passing a selection table and a callback to UI node
--    	so that you can easilly chain UIs and make very complex UI
--    	situations that can walk through anything in the code and manage it.

----------------------------
-- SETTINGS
----------------------------

-- ui_pipeline.settings = {}

----------------------------
-- PACKAGES
----------------------------

-- ui_pipeline.packages = {
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

-- ui_pipeline.cmds = {}

--------------------------
-- AUTOCMDS
--------------------------

-- ui_pipeline.autocmds = {}

----------------------------
-- BINDS
----------------------------

-- ui_pipeline.binds = {}

----------------------------
-- LEADER BINDS
----------------------------

-- if require("doom.utils").is_module_enabled("whichkey") then
--   table.insert(ui_pipeline.binds, {
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

return ui_pipeline


