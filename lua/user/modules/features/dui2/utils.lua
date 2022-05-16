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

-- system.sep!!! -> util?
M.get_query_file = function(lang, query_name)
  return fs.read_file(string.format("%s/queries/%s/%s.scm", system.doom_root, lang, query_name))
end

M.ts_get_doom_captures = function(buf, doom_capture_name)
  local t_matched_captures = {}
  local query_str = conf_ui.get_query_file("lua", "doom_conf_ui")
  local language_tree = vim.treesitter.get_parser(buf, "lua")
  local syntax_tree = language_tree:parse()
  local root = syntax_tree[1]:root()
  local qp = vim.treesitter.parse_query("lua", query_str)

  for id, node, _ in qp:iter_captures(root, buf, root:start(), root:end_()) do
    local name = qp.captures[id]
	  if name == doom_capture_name then
        table.insert(t_matched_captures, node)
	  end
   end
   return t_matched_captures
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
