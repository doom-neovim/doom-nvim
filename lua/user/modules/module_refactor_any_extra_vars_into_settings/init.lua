local module_refactor_any_extra_vars_into_settings = {}

-- TODO:
--
--    - make sure that any locals that don't import anything are being
--    moved into the settings table so that the module structure is kept clean.

----------------------------
-- SETTINGS
----------------------------

-- module_refactor_any_extra_vars_into_settings.settings = {}

----------------------------
-- PACKAGES
----------------------------

-- module_refactor_any_extra_vars_into_settings.packages = {
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

-- module_refactor_any_extra_vars_into_settings.cmds = {}

--------------------------
-- AUTOCMDS
--------------------------

-- module_refactor_any_extra_vars_into_settings.autocmds = {}

----------------------------
-- BINDS
----------------------------

-- module_refactor_any_extra_vars_into_settings.binds = {}

----------------------------
-- LEADER BINDS
----------------------------

-- if require("doom.utils").is_module_enabled("whichkey") then
--   table.insert(module_refactor_any_extra_vars_into_settings.binds, {
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

return module_refactor_any_extra_vars_into_settings


