local M = {}


-- rename this file to `flatteners.lua` or `make_array.lua`

--
-- TELESCOPE LIST FLATTENERS
--
-- helpers for flattening out all aspects of doom to make them
-- compatible with list finders, such as `telescope-nvim`.

-- LIST OF POSSIBLE DOOM COMPONENTS
--
--    ->  user_settings
--    ->  settings
--    ->  packages
--    ->  configs -> merge with packages.. right?
--    ->  binds
--    ->  cmds
--    ->  autocmds


-- inspect table
local function i(x)
  print(vim.inspect(x))
end

-- helper to make recursive output easier to read
-- @param integer - recursion depth
local function indent(s)
  local res = ""
  for i = 1, #s do res = res .. "- " end res = res .. ">"
  return res
end

-- TODO: mv to util
--
-- @param list or table of tables
local function table_merge(...)
    local tables_to_merge = { ... }
    -- assume the table has been wrapped
    if #tables_to_merge == 1 then
      tables_to_merge = tables_to_merge[1]
    end
    assert(#tables_to_merge > 1, "There should be at least two tables to merge them")
    for k, t in ipairs(tables_to_merge) do
        assert(type(t) == "table", string.format("Expected a table as function parameter %d", k))
    end
    local result = tables_to_merge[1]
    for i = 2, #tables_to_merge do
        local from = tables_to_merge[i]
        for k, v in pairs(from) do
            if type(k) == "number" then
                table.insert(result, v)
            elseif type(k) == "string" then
                if type(v) == "table" then
                    result[k] = result[k] or {}
                    result[k] = table_merge(result[k], v)
                else
                    result[k] = v
                end
            end
        end
    end
    return result
end


-- Helper to flatten and get table keys/indices properly.
--
-- for example it makes sure that recursion only enters tables with keys
-- and no indices, ie. tables containins integer indexed values are treaded
-- as setting leaf values, in order to prevent that list-settings are treated
-- as separate settings. eg, position = { "x", "y", } is treated as one setting.
--
-- only return true if the table is pure string
-- keys and at least one key
-- @param key, val when looping with pairs()
-- @return bool - should we recurse into table or not?
local function is_sub_setting(a, b)
  if type(a) == "number" then
    return false
  end
  if type(b) ~= "table" then
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
    return false
  end
  return true
end

-- EACH ENTRY SHOULD HAVE ENOUGH INFORMATION TO STRUCTURAL FIND AND TRANSFORM
-- THE DATA IN THE CODEBASE.
--
--
-- {
--    type = string,
--    table_path = { "level1", "level2", idx1 }, ie. level1.level2[idx1]
--        for cmds and autocmds, (and some packages), this wil be just { number }
--        since you only need the index to get back to the type in the selected module.
--    table_value =  <anything>,
--        reference to the real value?
--    formatted_value = string,
--    name = string,
--    formatted_name = string,  -- table_path concat + name
--        create function that formats each entry for display?
--    actions = type ?? list
--      list of keybind actions for each doom component, so that you
--      can easilly attach custom operations for each doom type.
--      ideally these should be usable with cursor context as well. ie. add bind to first branch under cursor, second, bind after leaf under cursor.
--    list_display_props = {
--      ..
--      { "display_string", "hl_group" }
--      ..
--      ..
--    }
-- }
--
--  item | item    | item  | .. | legend? |

-- @param table: of each component you require flattened,
--          -> eg. get_flat { "user_settings", "module_settings", "module_packages" } returns { {}, {}, ... }
-- @return list of flattened doom components, use with eg. telescope.
M.doom_get_flat = function(t_requested_components)
  local components_table = {}
  for m_key, m_comp in pairs(doom_ui_state.prev.selection) do
    -- make sure we don't try to access nil
    if vim.tbl_contains(t_requested_components, m_key) then

      -- if settings or user_settings use same

      table.insert(components_table, M[m_key .."_flattened"](m_comp))

    -- else
    --   -- prefix hidden props
    --   table.insert(components_table, {
    --     type = "__" .. m_key,
    --     value = m_comp
    --   })

--    list_display_props = {
--      ..
--      { "display_string", "hl_group" }
--      ..
--      ..
--    }
    end
  end

  --TODO: prevent fail if table empty

  local merge =  table_merge(components_table)
  return merge
end

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

--
-- FLATTENERS
--

-- TODO: mv modules flattener to here


-- xxx

















-- -- TODO: could the same flattener be used for both user settings and module settings? Yes, right?!
-- --
-- -- tree flattener: user settings and module settings,
-- M.user_settings_flattened = function(t_settings, flattened, stack)
--   local flattened = flattened or {}
--   local stack = stack or {}
--
--   for k, v in pairs(t_settings) do
--
--     if is_sub_setting(k,v) then
--       -- recurse down
--       table.insert(stack, k)
--       flattened = M.settings_flattened(v, flattened, stack)
--
--     else
--       -- entry
--       local entry = {
--         type = "module_setting",
--         path_components = k,
--         value = tostring(v),
--         list_display_props = {
--           "SETTING", "", ""
--         }
--       }
--       if #stack > 0 then
--         local pc = table.concat(stack, ".")
--         entry.path_components = pc .. "." .. k
--       end
--       table.insert(flattened, entry)
--
--     end
--   end
--
--   table.remove(stack, #stack)
--   return flattened
-- end

M.settings_flattened = function(t_settings, flattened, stack)
  local flattened = flattened or {}
  local stack = stack or {}

  for k, v in pairs(t_settings) do

    if is_sub_setting(stack, k,v) then
      -- recurse down
      table.insert(stack, k)
      flattened = M.settings_flattened(v, flattened, stack)

    else
      -- ordinal = ,
      -- todo: if leaf setting is table list -> "[[" .. table.concat(v, ", ) .. "]]"
      -- todo: conditional USR/MOD_
      local entry = {
        type = "module_setting",
        data = {
          path_components = nil,
          value = v,
        }
      }

      if #stack > 0 then
        local pc = stack
        table.insert(pc, k)
        entry.data.path_components = pc
      else
        entry.data.path_components = { k }
      end

      entry["list_display_props"] = {
          "SETTING",
          table.concat(entry.data.path_components, "."),
         tostring(entry.data.path_components)
        }

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
        v = { v }
      end

    end

      -- ordinal = ,
    local entry = {
      type = "module_package",
      data = {
        name = k,
        spec = v,
      },
    }

    entry["list_display_props"] = {
      "PKG",
      entry.data.name,
      tostring(entry.data.spec)
    }

    table.insert(flattened, entry)
  end

  return flattened
end

M.configs_flattened = function(t_configs)
  local flattened = {}
  for k, v in pairs(t_configs) do

    local entry = {
      type = "module_config",
      data = {
        name = k,
        value = v,
      },
    }

    entry["list_display_props"] = {
      "CFG",
      entry.data.name,
      tostring(entry.data.value)
    }

    table.insert(flattened, entry)
  end

  return flattened
end

M.cmds_flattened = function(t_cmds)
  local flattened = {}

  if t_cmds == nil then return end

  for k, v in pairs(t_cmds) do

    local entry = {
      type = "module_cmd",
      data = {
        name = v[1],
        cmd = v[2],
      }
    }

    entry["list_display_props"] = {
      "CMD",
      entry.data.name,
      tostring(entry.data.cmd)
    }
    })

    table.insert(flattened, entry)
  end

  return flattened
end

M.autocmds_flattened = function(t_autocmds)
  local flattened = {}
  if t_autocmds == nil then return end

  if type(t_autocmds) == "function" then
    table.insert(flattened, {
      type = "module_autocmd",
      data = {
        event = nil,
        pattern = nil,
        action = nil,
        is_func = true,
        func = t_autocmds,
      },
      -- ordinal = ,
      list_display_props = {
        "AUTOCMD", "", ""
      }
    })

  else
    for k, v in pairs(t_autocmds) do
      table.insert(flattened, {
        type = "module_autocmd",
        data = {
          event = v[1],
          pattern = v[2],
          action = v[3],
        },
        list_display_props = {
          "AUTOCMD", "", ""
        }
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

        -- -- TODO: insert an entry for each new branch here ??
        -- -- so that you can do `add_mapping_to_same_branch()` ???
        -- local entry = {
        --   type = "module_bind_leaf",
        --   name = k,
        --   value = v,
        --   list_display_props = {
        --     "BIND", "", ""
        --   }
        -- }
        -- entry = table_merge(entry, t)

        table.insert(flattened, entry)

        table.insert(bstack, t.lhs)
        flattened = M.binds_flattened(t.rhs, flattened, bstack)
      else

        -- so that you can do `add_mapping_to_same_branch()` ???
        local entry = {
          type = "module_bind_leaf",
          data = t,
          -- ordinal = ,
          list_display_props = {
            "BIND", "", ""
          }
        }

        table.insert(flattened, entry)
      end
    end
  end
  table.remove(bstack, #bstack)
  return flattened
end

return M
