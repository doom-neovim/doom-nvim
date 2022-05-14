local modules_merge = {}

-- TODO:
--
--    - use tree-sitter to merge modules. basically put everything in one file and refactor
--
--    should there be a module.setup field that is general config setup that doesn't belong to any package or whatever.
--

-- modules_merge.settings = {}

-- modules_merge.packages = {
-- [""] = {},
-- -- [""] = {},
-- -- [""] = {},
-- -- [""] = {},
-- }

-- modules_merge.cmds = {}
-- modules_merge.autocmds = {}
-- modules_merge.binds = {}

-- if require("doom.utils").is_module_enabled("whichkey") then
--   table.insert(modules_merge.binds, {
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

return modules_merge

