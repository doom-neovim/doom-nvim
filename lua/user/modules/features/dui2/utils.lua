local M = {}

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

M.get_module_components_prepared_for_picker = function()

  local prep = {}

  -- Iterate selected module
  for m_key, m_comp in pairs(doom_ui_state.prev.selection) do
    -- print(k, v)
    if vim.tbl_contains(MODULE_COMPONENTS, m_key) then
      if m_key == "settings" then
        -- print(m_key)
        for _, setting_flat in ipairs(M.settings_flattened(m_comp)) do
          -- i(setting_flat)
          table.insert(prep, setting_flat)
        end
        -- i(prep)
      -- elseif k == "packages" then
      --   for _, package_flat in ipairs(M.packages_flattened(m_comp)) do
      --     table.insert(prep, package_flat)
      --   end
      --
      -- elseif k == "configs" then
      --   for _, config_flat in ipairs(M.configs_flattened(m_comp)) do
      --     table.insert(prep, config_flat)
      --   end
      --
      -- elseif k == "cmds" then
      --   for _, cmd_flat in ipairs(M.cmds_flattened(m_comp)) do
      --     table.insert(prep, cmd_flat)
      --   end
      --
      -- elseif k == "autocmds" then
      --   for _, autocmd_flat in ipairs(M.autocmds_flattened(m_comp)) do
      --     table.insert(prep, autocmd_flat)
      --   end
      --
      -- elseif k == "binds" then
      --     for _, bind_flat in ipairs(M.binds_flattened(m_comp)) do
      --       table.insert(prep, bind_flat)
      --     end

      -- else
      --   table.insert(prep, {
      --     type = m_key,
      --     value = m_comp
      --   })

      end

    end
  end

  return prep
end


-- @return array of
-- {
--  type = string
-- }
M.settings_flattened = function(t_settings, flattened, stack)
  -- print(t_settings == nil)
  local flattened = flattened or {}
  local stack = stack or {}
  for k, v in pairs(t_settings) do
    -- print("------------------------------------------------------", indent(stack))
    -- local ss = string.format([[#%s%s key = (%s, t:%s), v = (t:%s)]], #stack, indent(stack), type(k), k,  type(v))
    if is_sub_setting(stack, k,v) then
      -- print("NEW SUB TABLE ->", string.upper(type(k)) ..":"..k, string.upper(type(v)) ..":"..tostring(v))
      if type(v) ~= "table" then print("!!!!! sub t") end
      table.insert(stack, k)
      flattened = M.settings_flattened(v, flattened, stack)
      -- print("POST SUB TABLE ->", type(k) ..":"..k, type(v)..":"..tostring(v))
    else
      -- print("LEAF ->", string.upper(type(k)) ..":"..k, string.upper(type(v)) ..":".. tostring(v))
      local entry = { type = "module_setting",path_components = k, value = tostring(v) }
      if #stack > 0 then
        local pc = table.concat(stack, ".")
        entry.path_components = pc .. "." .. k
      end
      -- print("ENTRY:", entry.path_components, "=", entry.value)
      table.insert(flattened, entry)
    end
  end
  table.remove(stack, #stack)
  return flattened
end


-- @return array of
-- {
--  type = string,
--  name = string,
--  spec = table,
-- }
M.packages_flattened = function(t_packages)
  local flattened = {}
  if t_packages == nil then return end
  for idx, v in ipairs(t_packages) do
    -- i(v)

   table.insert(flattened, {
      type = "module_package",
      name = idx,
      spec = v
    })
  end
  return flattened
end

-- @return array of
-- {
--  type = string
--  ...
--  ...
-- }
M.configs_flattened = function(t_configs)
  local flattened = {}
  -- i(t_settings)
  -- local stack = stack or {}
  for k, v in pairs(t_configs) do
    -- print("config:", k,v)
    -- if type(v) == "table" then
    --   table.insert(stack, k)
    -- else
   local entry = {}
    entry["type"] = "module_config"
    entry["name"] = k
    entry["config"] = v
    table.insert(flattened, entry)
    -- end
  end
  -- table.remove(stack, #stack)
  return flattened
end


-- @return array of
-- {
--  type = string
--  ...
--  ...
-- }
M.cmds_flattened = function(t_cmds)
  local flattened = {}
  if t_packages == nil then return end
  for idx, v in ipairs(t_cmds) do
    -- i(v)

   table.insert(flattened, {
      type = "module_cmd",
      cmd = v
    })
  end
  return flattened
end

-- @return array of
-- {
--  type = string
--  ...
--  ...
-- }
M.autocmds_flattened = function(t_autocmds)
  local flattened = {}
  if t_packages == nil then return end
  for idx, v in ipairs(t_autocmds) do
    -- i(v)

   table.insert(flattened, {
      type = "module_autocmd",
      autocmd = v
    })
  end
  return flattened
end


-- @return array of
-- {
--  type = string
--  ...
--  ...
-- }
-- TODO: add each branch to flattened and tag as t["type"] = "module_bind_branch"
-- TODO: attach the corresponding branch to each bind
M.binds_flattened = function(nest_tree, flattened, bstack)
  local flattened = {}
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
