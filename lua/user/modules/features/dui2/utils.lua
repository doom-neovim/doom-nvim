local M = {}

-- rename this file to `flatteners.lua` or `make_array.lua`

local MODULE_COMPONENTS = {
  "name",
  "enabled",
  "settings",
  "packages",
  "configs",
  "binds",
  "cmds",
  "autocmds",
  -- "options",
}

local function i(x)
  print(vim.inspect(x))
end

-- only return true if the table is pure string
-- keys and at least one key
local function is_sub_setting(s, a, b)
  -- print("is_sub_settings:", type(a), type(b))

  if type(a) == "number" then
    -- print("IS_SUB; a == number",  a)
    return false
  end

  if type(b) ~= "table" then
    -- print("IS_SUB; b ~= table",  a)
    return false
  end

  local cnt = 0
  for k, v in pairs(b) do
    cnt = cnt + 1
    if type(k) == "number" then
      -- print("IS_SUB; sub table has number",  a)
      return false
    end
  end

  if cnt == 0 then
    -- print("IS_SUB: sub table has no keys", a)
    return false
  end

  -- print("IS_SUB; table is pure", a, b)
  return true
end

local function indent(s)
  local res = ""
  for i = 1, #s do res = res .. "- " end res = res .. ">"
  return res
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



-- refactor: make accept
-- @param table: of each component you require flattened,
--          -> eg. get_flat { "user_settings", "module_settings", "module_packages" } returns { {}, {}, ... }
-- @return list of flattened doom components, use with eg. telescope.
--
-- EACH ENTRY SHOULD HAVE ENOUGH INFORMATION TO STRUCTURAL FIND AND TRANSFORM
-- THE DATA IN THE CODEBASE.
M.get_module_components_prepared_for_picker = function()

  local prep = {}

  -- Iterate selected module
  for m_key, m_comp in pairs(doom_ui_state.prev.selection) do
    -- print(m_key)
    if vim.tbl_contains(MODULE_COMPONENTS, m_key) then

      if m_key == "settings" then
        for _, setting_flat in ipairs(M.settings_flattened(m_comp)) do
          table.insert(prep, setting_flat)
        end

      elseif m_key == "packages" then
        for _, package_flat in ipairs(M.packages_flattened(m_comp)) do
          table.insert(prep, package_flat)
        end

      elseif m_key == "configs" then
        for _, config_flat in ipairs(M.configs_flattened(m_comp)) do
          table.insert(prep, config_flat)
        end

      elseif m_key == "cmds" then
        for _, cmd_flat in ipairs(M.cmds_flattened(m_comp)) do
          -- i(cmd_flat)
          table.insert(prep, cmd_flat)
        end

      elseif m_key == "autocmds" then
        for _, autocmd_flat in ipairs(M.autocmds_flattened(m_comp)) do
          table.insert(prep, autocmd_flat)
        end

      elseif m_key == "binds" then
          for _, bind_flat in ipairs(M.binds_flattened(m_comp)) do
            table.insert(prep, bind_flat)
          end

      else
        table.insert(prep, {
          type = "__" .. m_key,
          value = m_comp
        })

      end

    end
  end

  return prep
end

-- TODO: could the same flattener be used for both user settings and module settings? Yes, right?!
--
-- tree flattener: user settings and module settings,
M.user_settings_flattened = function(t_settings, flattened, stack)
  local flattened = flattened or {}
  local stack = stack or {}
  for k, v in pairs(t_settings) do
    if is_sub_setting(stack, k,v) then
      -- if type(v) ~= "table" then print("!!!!! sub t") end
      table.insert(stack, k)
      flattened = M.settings_flattened(v, flattened, stack)
    else
      local entry = { type = "module_setting",path_components = k, value = tostring(v) }
      if #stack > 0 then
        local pc = table.concat(stack, ".")
        entry.path_components = pc .. "." .. k
      end
      table.insert(flattened, entry)
    end
  end
  table.remove(stack, #stack)
  return flattened
end

M.settings_flattened = function(t_settings, flattened, stack)
  local flattened = flattened or {}
  local stack = stack or {}
  for k, v in pairs(t_settings) do
    if is_sub_setting(stack, k,v) then
      -- if type(v) ~= "table" then print("!!!!! sub t") end
      table.insert(stack, k)
      flattened = M.settings_flattened(v, flattened, stack)
    else
      local entry = { type = "module_setting",path_components = k, value = tostring(v) }
      if #stack > 0 then
        local pc = table.concat(stack, ".")
        entry.path_components = pc .. "." .. k
      end
      table.insert(flattened, entry)
    end
  end
  table.remove(stack, #stack)
  return flattened
end

-- list flattener: cmds, and autocmds, and packages.???
M.packages_flattened = function(t_packages)
  local flattened = {}
  if t_packages == nil then return end
  for k, v in pairs(t_packages) do
    if type(k) == "number" then
      k = "anonymous"
      if type(v) == "string" then
        entry.spec = { v }
      end
    end
    local entry = { type = "module_package", name = k, spec = v }
    table.insert(flattened, entry)
  end
  return flattened
end

M.configs_flattened = function(t_configs)
  local flattened = {}
  for k, v in pairs(t_configs) do
    local entry = { type = "module_config", name = k, value = v }
    table.insert(flattened, entry)
  end
  return flattened
end

M.cmds_flattened = function(t_cmds)
  local flattened = {}
  if t_cmds == nil then return end
  for k, v in pairs(t_cmds) do
    table.insert(flattened, {
      type = "module_cmd",
      name = v[1],
      cmd = v[2]
    })
  end

  return flattened
end

M.autocmds_flattened = function(t_autocmds)
  local flattened = {}
  if t_autocmds == nil then return end
  if type(t_autocmds) == "function" then
    table.insert(flattened, {
      type = "module_autocmd",
      event = nil,
      pattern = nil,
      action = nil,
      is_func = true,
      func = t_autocmds
    })
  else
    for k, v in pairs(t_autocmds) do
      table.insert(flattened, {
        type = "module_autocmd",
        event = v[1],
        pattern = v[2],
        action = v[3],
      })
    end
  end
  return flattened
end

-- list tree flattener. binds contain both anonymous list and potential trees.
M.binds_flattened = function(nest_tree, flattened, bstack)
  local flattened = flattened or {}
  local sep = " | "
  local bstack = bstack or {}
  if acc == nil then
    for _, t in ipairs(nest_tree) do
      if type(t.rhs) == "table" then
        -- so that you can select it and `add_mapping_to_branch`
        -- or `add_new_branch_level_to_branch()`
        table.insert(bstack, t.lhs)
        flattened = M.binds_flattened(t.rhs, flattened, bstack)
      else
        -- so that you can do `add_mapping_to_same_branch()`
        t["type"] = "module_bind_leaf"
        table.insert(flattened, t)
      end
    end
  end
  table.remove(bstack, #bstack)
  return flattened
end

-- M.flatten_ts_nest_tree = function(ts_nest_table)
--   local ts_nest_flat = {}
--   return ts_nest_flat
-- end

return M
