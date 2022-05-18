local ts = require("user.modules.features.dui2.ts")

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
	local function make_display(t)
	  local res = ""
	  local idx = doom_ui_state.selected_module_idx
	  local sec = doom_ui_state.all_modules_flattened[idx].section
	  local name = doom_ui_state.all_modules_flattened[idx].name
	  -- i(t)

	  if t.type == "module_bind_leaf" then
      res = "BIND: " .. t.lhs .. " -> " .. t.rhs .. " // name: " .. t.name

	  elseif t.type == "module_setting" then
	    -- print("SETTING......")
	    -- i(t)
	    -- i(typet.path_components)

	    res = "SETTING: " .. t.path_components .. " -> "

	    print(type(t.value))

	    if type(t.value) == "table" then
	      res = res .. "{}"
	    elseif type(t.value) == "function" then
	      res = res .. tostring(t.value)
	    else
	      res = res .. t.value
	    end

	    print("res:", res)

	  elseif t.type == "module_package" then
      res = "PACKAGE: " .. t.name --.. " -> " .. t.value.rhs .. " // name: " .. t.value.name

    -- else
    --   res = t.type .. " > " .. tostring(t.key)
	  end

	  return res
	end
	return {
	  value = entry,
	  display = function(tbl) return make_display(tbl.value) end,
	  ordinal = entry.type,
	}
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
