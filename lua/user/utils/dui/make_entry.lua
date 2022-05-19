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
  -- print(entry.origin, vim.inspect(entry.list_display_props))

  local displayer = entry_display.create {
    separator = "▏",
    items = {
      { width = 7 },
      { width = 3 },
      { width = 5 },
      { width = 10 },
      { width = 25 },
      { remaining = true },
    },
  }

  local make_display = function(entry)
    return displayer(entry.value.list_display_props)
  end

	return {
	  value = entry,
	  display = make_display,
	  ordinal = entry.name,
	}
end

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
function entry_makers.display_module_full(entry)
  -- print(entry.value)
  local displayer = entry_display.create {
    separator = "▏",
    items = {
      { width = 10 },
      { width = 30 },
      { width = 30 },
      { remaining = true },
    },
  }

  local make_display = function(entry)
    return displayer(entry.value.list_display_props)
  end

	return {
	  value = entry,
	  display = make_display,
	  ordinal = entry.type,
	}
end
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

function entry_makers.display_single_module(entry) end

function entry_makers.display_all_packages(entry) end
function entry_makers.display_module_packages(entry) end

function entry_makers.display_module_cmds(entry) end
function entry_makers.display_module_autocmds(entry) end

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

--
-- TREESITTER
--

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


return entry_makers
