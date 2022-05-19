local ax =  require("user.modules.features.dui.actions")
local ut =  require("user.modules.features.dui.utils")

local M = {}

local MODULE_ORIGINS = {
    "user",
    "doom",
}

local MODULE_CATEGORIES = {
    "core",
    "features",
    "langs",
}

local MODULE_PARTS = {
    "settings",
    "packages",
    "configs",
    "binds",
    "cmds",
    "autocmds",
}

M.get_results_for_query = function(type, components)

  local results = {}

  -- inspect_ui_state()

    -- TODO: filters -> investigate

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
      for mk, m_part in pairs(doom_ui_state.selected_module) do
        for _, qp in ipairs(doom_ui_state.query.parts or MODULE_PARTS) do
          if mk == qp then
            for _, entry in pairs(M[mk.."_flattened"](m_part)) do
              table.insert(results, entry)
            end
          end
        end
      end

  elseif doom_ui_state.query.type == "component" then

  elseif doom_ui_state.query.type == "all" then

  end


  return results
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
        ["<CR>"] = function(fuzzy, line)
          doom_ui_state.query = {
            type = "modules",
            -- origins = {},
            -- categories = {},
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
         -- i(fuzzy)
		      doom_ui_state.selected_module = fuzzy.value
		      ax.m_edit(fuzzy.value)
		    end,
		    ["<C-a>"] = function(fuzzy, line)
          doom_ui_state.query = {
            type = "module",
            -- components = {}
          }
		      doom_ui_state.selected_module = fuzzy.value
          doom_ui_state.next()
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

    if ut.is_sub_setting(k,v) then
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
  end
  table.remove(bstack, #bstack)
  return flattened
end

return M
