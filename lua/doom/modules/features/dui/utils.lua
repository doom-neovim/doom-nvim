-- rename this file to `flatteners.lua` or `make_array.lua`

--
-- TELESCOPE LIST FLATTENERS
--
-- helpers for flattening out all aspects of doom to make them
-- compatible with list finders, such as `telescope-nvim`.

-- LIST OF POSSIBLE DOOM COMPONENTS
--
--    ->  user_settings
--
--    ->  module
--
--    ->  settings
--    ->  packages
--    ->  configs -> merge with packages.. right?
--    ->  binds
--    ->  cmds
--    ->  autocmds

local M = {}

-- inspect table
local function i(x)
  print(vim.inspect(x))
end

-- -- helper to make recursive output easier to read
-- -- @param integer - recursion depth
-- local function indent(s)
--   local res = ""
--   for _ = 1, #s do res = res .. "- " end res = res .. ">"
--   return res
-- end

-- TODO: mv to util
--
-- @param list or table of tables
M.table_merge = function(...)
    local tables_to_merge = { ... }

    -- assume the table has been wrapped
    if #tables_to_merge == 1 then
      tables_to_merge = tables_to_merge[1]
    end

    -- while (#tables_to_merge == 1) do
    --   tables_to_merge = tables_to_merge[1]
    -- end

  -- i(tables_to_merge)

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
M.is_sub_setting = function(a, b)

  if type(a) == "number" then
    -- print(":: number:", a)
    return false
  end

  if type(b) ~= "table" then
    -- print(":: number:", b)
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

  -- DOOM_UI_STATE = {
  --   -- doom_global_extended,
  --   all_modules_flattened = nil,
  --   selected_module_idx = nil,
  --   current = {
  --     title = nil, -- eg. settings, modules, binds_table, binds_branch
  --     results_prepared = nil,
  --     buf_ref = nil,
  --     picker = nil,
  --     selection = { item = nil, type = nil },
  --     line_str = nil,
  --     index_selected = nil,
  --   },
  --   history = {},
  -- }

M.inspect_ui_state = function()
    print("--------------------------------------------")
    print("PREVIOUS:", vim.inspect(DOOM_UI_STATE.prev))
    print("CURRENT:", vim.inspect(DOOM_UI_STATE.current))

    -- for k, v in pairs(DOOM_UI_STATE) do
    --   if k == "current" then
    --     for a, b in pairs(v) do
    --        print("  curr:", a, b)
    --     end
    --   elseif  k == "prev" then
    --     for a, b in pairs(v) do
    --        print("  prev:", a, b)
    --     end
    --   else
    --     print(k, v)
    --   end
    -- end
  print("###")
end

return M
