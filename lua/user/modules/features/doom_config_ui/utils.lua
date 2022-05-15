
local function check_if_module_name_exists(c, new_name)
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


