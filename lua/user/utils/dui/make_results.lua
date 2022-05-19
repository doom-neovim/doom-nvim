-- local us =  require("user.utils.dui.uistate")
local ax =  require("user.utils.dui.actions")
-- local us =  require("user.utils.dui.uistate")


-- local pickers = require("user.utils.dui.pickers")


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
--
--    ->  module
--
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
local function table_merge(...)
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
local function is_sub_setting(a, b)

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

  -- doom_ui_state = {
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

local function inspect_ui_state()
    print("--------------------------------------------")
    print("PREVIOUS:", vim.inspect(doom_ui_state.prev))
    print("CURRENT:", vim.inspect(doom_ui_state.current))

    -- for k, v in pairs(doom_ui_state) do
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

local MODULE_ORIGINS = {
    "user",
    "doom",
}

local MODULE_CATEGORIES = {
    "core",
    "features",
    "langs",
}


local MODULE_COMPONENTS = {
    "settings",
    "packages",
    "configs",
    "binds",
    "cmds",
    "autocmds",
}

--
-- GET DOOM COMPONENTS BY TYPE
--


-- @param table: of each component you require flattened,
--          -> eg. get_flat { "user_settings", "module_settings", "module_packages" } returns { {}, {}, ... }
-- @return list of flattened doom components, use with eg. telescope.
M.get_results_for_query = function(type, components)

  local results = {}

  -- inspect_ui_state()

    -- TODO: filters

  -- doom_picker("main_menu")
  -- doom_picker("settings")
  -- doom_picker("modules", "all"|"user"|"doom")
  -- doom_picker("module", "settings"|...|"binds")
  -- doom_picker("component")
  -- doom_picker("all", "settings"|...|"binds")

  if doom_ui_state.query.type == "main_menu" then
    for _, entry in ipairs(M.main_menu_flattened()) do
      table.insert(results, entry)
    end

  elseif doom_ui_state.query.type == "settings" then
    for _, entry in ipairs(M.settings_flattened(doom.settings)) do
      table.insert(results, entry)
    end

  elseif doom_ui_state.query.type == "modules" then
    for _, entry in pairs(M.get_modules_flattened()) do
      table.insert(results, entry)
    end

  elseif doom_ui_state.query.type == "module" then

    -- -- requires module selection!
    -- for _, cmp in pairs(doom_ui_stat.query.components or MODULE_COMPONENTS) do
    --   table.insert(components_table, M[cmp .."_flattened"](m_comp))
    -- end

  elseif doom_ui_state.query.type == "component" then

  elseif doom_ui_state.query.type == "all" then

  end


  -- if doom_ui_state.current.selection.type == "doom_main_menu" then
  --   table.insert(components_table, M.main_menu_flattened())
  --
  -- elseif doom_ui_state.current.selection.type == "module" then
  --   for m_key, m_comp in pairs(doom_ui_state.current.selection) do
  --     if vim.tbl_contains(t_requested_components, m_key) then
  --       table.insert(components_table, M[m_key .."_flattened"](m_comp))
  --     end
  --   end
  --
  -- end

  return results

  -- --TODO: prevent fail if table empty
  -- if #results == 0 or results == nil then
  --   return nil
  --
  -- -- elseif #results == 1 then
  -- --   return results
  --
  -- else
  --   return table_merge(results)
  --
  -- end

end

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

-- FLATTENER -> MAIN MENU

M.main_menu_flattened = function()
  local doom_menu_items = {
		{
      list_display_props = {
        {"open user config"},
      },
      mappings = {
        ["<CR>"] = function()
          vim.cmd(("e %s"):format(require("doom.core.config").source))
        end,
      }
		},
  	{
      list_display_props = {
        {"browse user settings"},
      },
      mappings = {
        ["<CR>"] = function(fuzzy,line, cb)
          doom_ui_state.query = {
            type = "settings",
          }
          doom_ui_state.next()
  		  end,
      }
  	},
  	{
      list_display_props = {
        {"browse all modules"},
      },
      mappings = {
        ["<CR>"] = function(fuzzy, line, cb)
          doom_ui_state.query = {
            type = "modules",
          }
          doom_ui_state.next()
        end,
      }
  	},
  	{
      list_display_props = {
        {"browse all binds"},
      },
      mappings = {
        ["<CR>"] =function() end,
      }

  	},
  	{
      list_display_props = {
        {"browse all autocmds"},
      },
      mappings = {
        ["<CR>"] = function() end,
      }
  	},
  	{
      list_display_props = {
        {"browse all cmds"},
      },
      mappings = {
        ["<CR>"] = function() end,
      }
  	},
  	{
      list_display_props = {
        {"browse all packages"},
      },
      mappings = {
        ["<CR>"] = function() end,
      }
  	},
  	{
      list_display_props = {
        {"browse all jobs"},
      },
      mappings = {
        ["<CR>"] = function() end,
      }
  	},
  }

  for k, v in pairs(doom_menu_items) do
    table.insert(v.list_display_props, 1, {"MAIN"})
    v["type"] = "doom_main_menu"
    -- i(v)
  end

  -- i(doom_menu_items)

  return doom_menu_items
end

--
-- FLATTENER -> MODULES
--

-- returns tree -> should be renamed
M.get_modules_extended = function()
  local config_path = vim.fn.stdpath("config")

  local function glob_modules(cat)
    if cat ~= "doom" and cat ~= "user" then return end
    local glob = config_path .. "/lua/"..cat.."/modules/*/*/"
    return vim.split(vim.fn.glob(glob), "\n")
  end
  local function get_all_module_paths()
    local glob_doom_modules = glob_modules("doom")
    local glob_user_modules = glob_modules("user")
    local all = glob_doom_modules
    for _, p in ipairs(glob_user_modules) do
      table.insert(all, p)
    end
    return all
  end

  local all_m = get_all_module_paths()

  local prep_all_m = { doom = {}, user = {} }

  for _, p in ipairs(all_m) do
    local m_origin, m_section, m_name =  p:match("/([_%w]-)/modules/([_%w]-)/([_%w]-)/$") -- capture only dirname
    if prep_all_m[m_origin][m_section] == nil then
      prep_all_m[m_origin][m_section] = {}
    end


    prep_all_m[m_origin][m_section][m_name] = {
      type = "module",
      enabled = false,
      name = m_name,
      section = m_section,
      origin = m_origin,
      path = p,
      list_display_props = {
        "MODULE", " ", m_origin, m_section, m_name
      },
      mappings = {
        ["<CR>"] = function(fuzzy, line)
		      doom_ui_state.current.selection = fuzzy.value
		      ax.m_edit(doom_ui_state.current.selection)
		    end,
		    ["<C-a>"] = function(fuzzy, line, cb)
		      doom_ui_state.selected_module_idx = fuzzy.index
		      doom_ui_state.current.selection = fuzzy.value
  		    if cb ~= nil then cb() end
	      end
      }
    }
  end

  local enabled_modules = require("doom.core.modules").enabled_modules
  local all_modules = vim.tbl_deep_extend("keep", {
    core = {
      'doom',
      'nest',
      'treesitter',
      'reloader',
    }
  },enabled_modules)



  for section_name, section_modules in pairs(all_modules) do
    for _, module_name in pairs(section_modules) do
      local search_paths = {
        ("user.modules.%s.%s"):format(section_name, module_name),
        ("doom.modules.%s.%s"):format(section_name, module_name)
      }
      for _, path in ipairs(search_paths) do
        local origin = path:sub(1,4)

        if prep_all_m[origin][section_name] ~= nil then
          if prep_all_m[origin][section_name][module_name] ~= nil then
            prep_all_m[origin][section_name][module_name].enabled = true
            prep_all_m[origin][section_name][module_name].list_display_props[2] = "x"
            for k, v in pairs(doom[section_name][module_name]) do
              prep_all_m[origin][section_name][module_name][k] = v
            end
            break;
          end
        end
      end
    end
  end

 return prep_all_m
end

-- returns flattened array
M.get_modules_flattened = function()
  local flattened = {}
  for _, origin in pairs(M.get_modules_extended()) do
    for _, section in pairs(origin) do
      for _, module in pairs(section) do
        table.insert(flattened, module)
      end
    end
  end
  return flattened
end


--
-- SETTINGS (USER/MODULE)
--

M.settings_flattened = function(t_settings, flattened, stack)
  local flattened = flattened or {}
  local stack = stack or {}

  for k, v in pairs(t_settings) do

    if is_sub_setting(k,v) then
      -- recurse down
      -- if type(k) == "number" then print("!!!!!!!!!!!!") end

      -- print("SUB -> ", type(k), k, v)
      -- print([[ recurse: (%s:%s), (%s:%s)]], type(k), k, type(v), v)

      table.insert(stack, k)
      flattened = M.settings_flattened(v, flattened, stack)

    else

      -- collect table_path back to setting in original table
      local pc
      if #stack > 0 then
        pc = vim.deepcopy(stack)
        table.insert(pc, k)
      else
        pc = { k }
      end

      -- REFACTOR: concat table_path
      -- format each setting
      local pc_display = table.concat(pc, ".")
      local v_display
      if type(v) == "table" then
        local str = ""
        for _, x in pairs(v) do
          if type(x) == "table" then
            str = str .. ", " .. "subt"
          else
            str = str .. ", " .. x
          end
        end
        v_display = str -- table.concat(v, ", ")
      else
        v_display = tostring(v)
      end

      local entry = {
        type = "module_setting",
        data = {
          table_path = pc,
          table_value = v,
        },
        list_display_props = {
          {"SETTING"},
          {pc_display},
          {v_display}
        },
        mappings = {
          ["<CR>"] = function(fuzzy,line, cb)
            i(fuzzy)
            -- doom_ui_state.query = {
            --   type = "settings",
            -- }
            -- doom_ui_state.next()
  		    end
        }
      }
      table.insert(flattened, entry)

    end
  end

  table.remove(stack, #stack)

  return flattened
end

--
-- PACKAGES
--

M.packages_flattened = function(t_packages)
  if t_packages == nil then return end
  local flattened = {}

  for k, v in pairs(t_packages) do

    local spec = v
    if type(k) == "number" then
      if type(v) == "string" then
        spec = { v }
      end
    end

    local repo_name, pkg_name = spec[1]:match("(.*)/([%w%-%.%_]*)$")

    local entry = {
      type = "module_package",
      data = {
        table_path = k,
        spec = spec,
      },
      list_display_props = {
        {"PKG"},
        {repo_name},
        {pkg_name}
      }
    }

    table.insert(flattened, entry)
  end

  return flattened
end

--
-- CONFIGS
--


M.configs_flattened = function(t_configs)
  local flattened = {}
  for k, v in pairs(t_configs) do

    local entry = {
      type = "module_config",
      data = {
        table_path = k,
        table_value = v,
      },
      list_display_props = {
        {"CFG"},
        {tostring(k)},
        {tostring(v)}
      }
    }

    table.insert(flattened, entry)
  end

  return flattened
end

--
-- CMDS
--

M.cmds_flattened = function(t_cmds)
  local flattened = {}

  if t_cmds == nil then return end

  for k, v in pairs(t_cmds) do

    -- i need to attach k here as well, to table_path

    local entry = {
      type = "module_cmd",
      data = {
        name = v[1],
        cmd = v[2],
      },
      list_display_props = {
        {"CMD"},
        {tostring(v[1])},
        {tostring(v[2])}
      }
    }

    table.insert(flattened, entry)
  end

  return flattened
end

--
-- AUTOCMDS
--

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
      list_display_props = {
        {"AUTOCMD"}, {"isfunc"}, {tostring(t_autocmds)}
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
           {"AUTOCMD"}, {v[1]}, {v[2]}, {tostring(v[3])}
        }
      })
    end

  end

  return flattened
end

--
-- BINDS
--

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

        -- i(t)

        -- so that you can do `add_mapping_to_same_branch()` ???
        local entry = {
          type = "module_bind_leaf",
          data = t,
          list_display_props = {
            { "BIND" }, { t.lhs }, {t.name}, {t.rhs} -- {t[1], t[2], tostring(t.options)
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
