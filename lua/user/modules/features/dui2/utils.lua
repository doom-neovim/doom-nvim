local M = {}

local function i(x)
  print(vim.inspect(x))
end

-- M.check_if_module_name_exists = function(c, new_name)
--   print(vim.inspect(c.selected_module))
--   local already_exists = false
--   for _, v in pairs(c.all_modules_data) do
--     if v.section == c.selected_module.section and v.name == new_name then
-- 	print("module already exists!!!")
--       already_exists = true
--     end
--   end
--   return already_exists
-- end


-- filter the list of all modules
M.filter_modules = function(filter)
  local filtered = {}
  -- if has each filter then return modules
  -- for all modules -> for each filter.

  -- -- with the new module extension util this will be much easier
  -- local function check_if_module_name_exists(c, new_name)
  --   print(vim.inspect(c.selected_module))
  --   local already_exists = false
  --   for _, v in pairs(c.all_modules_data) do
  --     if v.section == c.selected_module.section and v.name == new_name then
  -- 	print("module already exists!!!")
  --       already_exists = true
  --     end
  --   end
  --   return already_exists
  -- end

  return filtered
end

M.settings_flattened = function(nest_tree, flattened, bstack)
end

M.packages_flattened = function(nest_tree, flattened, bstack)
end

M.configs_flattened = function(nest_tree, flattened, bstack)
end


M.cmds_flattened = function(nest_tree, flattened, bstack)
end

M.autocmds_flattened = function(nest_tree, flattened, bstack)
end


M.binds_flattened = function(nest_tree, flattened, bstack)
  local flattened = {}
  local sep = " | "
  local bstack = bstack or {}
  if acc == nil then
    for _, t in ipairs(nest_tree) do
      if type(t.rhs) == "table" then
        -- :: BRANCH ::::::::::::::::::::::::::::::::::::::::::::::
        table.insert(bstack, t.lhs)
        flattened = M.binds_flattened(t.rhs, flattened, bstack)
      else
        -- :: LEAF ::::::::::::::::::::::::::::::::::::::::::::::::
        -- local pre = ""
        -- if #bstack > 0 then
        --   pre = table.concat(bstack, " -> ")
        -- end
        -- local res = "#".. t.lhs .. sep .. t[1] .. sep .. t.name .. sep .. sep .. type(t.rhs)
        t["type"] = "module_bind"
        table.insert(flattened, t)
      end
    end
  end
  table.remove(bstack, #bstack)
  return flattened
end

M.flatten_ts_nest_tree = function(ts_nest_table)
  local ts_nest_flat = {}
  return ts_nest_flat
end

return M
