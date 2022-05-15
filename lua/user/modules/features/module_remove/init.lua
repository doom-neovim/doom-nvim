local module_remove = {}

-- TODO:
--
--    - remove module easilly so that we can throw out ideas faster which is something that would be nice
--
--    use telescope > make binding select multiple modules > rm

local function remove_dir()
end

local function prompt_callback_remove()
	-- 1. nui menu -> are you sure
	-- 2. if yes ->
	-- 	a. transform `modules.lua`
	-- 	b. remove dir.
end

local function picker_remove_module()
end

local function module_remove_by_select()
	-- 1. get all modules from user

	-- 2. map entries UI
	-- 3. call `picker_remove_module`
end

-- module_remove.settings = {}

-- module_remove.packages = {
-- [""] = {},
-- -- [""] = {},
-- -- [""] = {},
-- -- [""] = {},
-- }

-- module_remove.cmds = {}
-- module_remove.autocmds = {}
-- module_remove.binds = {}

-- if require("doom.utils").is_module_enabled("whichkey") then
--   table.insert(module_remove.binds, {
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

return module_remove

