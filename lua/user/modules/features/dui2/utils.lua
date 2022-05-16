local M = {}

M.check_if_module_name_exists = function(c, new_name)
  print(vim.inspect(c.selected_module))
  local already_exists = false
  for _, v in pairs(c.all_modules_data) do
    if v.section == c.selected_module.section and v.name == new_name then
	print("module already exists!!!")
      already_exists = true
    end
  end
  return already_exists
end


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

M.flatten_regular_binds_tree = function(nest_tree)

end

M.flatten_ts_nest_tree = function(ts_nest_table)
  local ts_nest_flat = {}
  return ts_nest_flat
end

return M
