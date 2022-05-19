local entry_display = require("telescope.pickers.entry_display")

local ts = require("user.utils.dui.ts")

local function i(x)
  print(vim.inspect(x))
end


local entry_makers = {}

-- MODULE META PARAMS EXAMPLE
--
-- enabled = false,
-- name = "plugins_local_reloader",
-- origin = "user",
-- path = "/Users/hjalmarjakobsson/.config/nvim/lua/user/modules/features/plugins_local_reloader/",
-- section = "features",
-- type = "module"

--
-- ENTRY MAKERS
--

function entry_makers.display_all_modules(entry)
	local function make_display(t)

	  -- i(t)

	  -- TODO: move all of this into the modules flattener.

	  local res = ""

    local on = "x"
    local org

    if not t.enabled then on = "_" end

    if t.origin == "user" then
      org = "u"
    else
      org = "d"
    end

    -- res = string.format([[ ]],
    -- )

	  return t.origin .. " ["..on.."] : " .. t.section .." -> " .. t.name
	end

	return {
	  value = entry,
	  display = function(tbl) return make_display(tbl.value) end,
	  ordinal = entry.name,
	}
end

function entry_makers.display_doom_settings(entry)
	-- print((entry:named_child(1)):type())
	local formatted = ""
	-- print(vim.inspect(node))
	local f1 = entry:named_child(0)
	local f2 = entry:named_child(1)
  local f1x = ts.ntext(f1, doom_ui_state.current.buf_ref)
	local f2x = ts.ntext(f2, doom_ui_state.current.buf_ref)
	local f2ccnt = f2:named_child_count()
	if f2:type() == "table_constructor" then
	  f2x = " >>> { #"..f2ccnt.." }"
	end
	formatted = formatted .. f1x .. " -> " .. f2x

	local function e() end

	local function d(node)
	  -- print(formatted)
		return formatted
	end

	local function o() end
	return {
	  value = entry,
	  display = formatted,
	  -- display = function(tbl) return d(tbl.value) end,
	  ordinal = f1x,
	}
end

function entry_makers.display_module_full(entry)
	-- print(doom_ui_state.all_modules_flattened[selected_module_idx].title)

  local displayer = entry_display.create {
    separator = "▏",
    items = {
      { width = 14 },
      { width = 18 },
      { width = 20 },
      { remaining = true },
    },
  }

	local function formatter()
	end

	local function make_display(entry)
	  local res = ""
	  local idx = doom_ui_state.selected_module_idx
	  local sec = doom_ui_state.all_modules_flattened[idx].section
	  local name = doom_ui_state.all_modules_flattened[idx].name

	  -- i(entry)

	  if entry.type == "module_setting" then
	    res = "SETTING: " .. entry.data.path_components .. " -> " .. entry.data.value

	  elseif entry.type == "module_config" then
	    res = "CONFIG: " .. entry.data.name .. " -> " .. tostring(entry.data.value)

	  elseif entry.type == "module_package" then
      res = "PACKAGE: " .. entry.data.name .. " -> " .. tostring(entry.data.spec)

	  elseif entry.type == "module_cmd" then
      res = "CMD: " .. entry.data.name .. " -> " .. tostring(entry.data.cmd)

	  elseif entry.type == "module_autocmd" then
      if entry.data.is_func then
        res = "AUTOCMD: " .. entry.data.func
      else
        res = "AUTOCMD: " .. entry.data.event .. " | " .. entry.data.pattern .. " | " .. tostring(entry.data.action)
      end

	  elseif entry.type == "module_bind_leaf" then
      res = "BIND: " .. entry.data.lhs .. " -> " .. entry.data.rhs .. " // name: " .. entry.data.name

    -- else
    --   res = string.upper(entry.type) .. " -> " .. tostring(

	  end

	  -- print(res)

	  return res
	end

  -- local make_display = function(entry)
  --   return displayer entry.list_display_props
  -- end


	return {
	  value = entry,
	  display = function(tbl) return make_display(tbl.value) end,
	  ordinal = entry.type,
	}
  -- return function(entry)
  --   if entry == "" then
  --     return nil
  --   end
  --   -- local mod, file = string.match(entry, "(..).*%s[->%s]?(.+)")
  --
  --   return {
  --     value = entry,
  --     -- status = mod,
  --     ordinal = entry.type,
  --     display = make_display,
  --     -- path = Path:new({ opts.cwd, file }):absolute(),
  --   }
  -- end
end

function entry_makers.display_single_module(entry) end

function entry_makers.display_all_packages(entry) end
function entry_makers.display_module_packages(entry) end

function entry_makers.display_module_cmds(entry) end
function entry_makers.display_module_autocmds(entry) end

function entry_makers.display_binds_table(entry)
	-- print(vim.inspect(entry))
	  local function make_display(t)
	    local s = t.level .. " / " .. ts.ntext(t.prefix, doom_ui_state.current.buf_ref) .. " / "
	    -- print(s)
	    return s
	  end
	  return {
	    value = entry,
	    display = function(tbl) return make_display(tbl.value) end,
	    ordinal = entry.prefix,
	  }
end

function entry_makers.display_binds_leaf(entry)
	  return {
	    value = entry,
	    display = function(tbl)
	      return tbl.value.key
	    end,
	    ordinal = entry,
	  }
end

function entry_makers.display_binds_branch(entry)
	  return {
	    value = entry,
	    display = function(tbl)
	      return tbl.value.key
	    end,
	    ordinal = entry,
	  }
end

return entry_makers
