local ts = require("user.modules.features.dui2.ts")

local entry_makers = {}


--
-- ENTRY MAKERS
--

function entry_makers.display_all_modules(entry)
	local function make_display(t)
	  return t.section .." > " .. t.name
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

function entry_makers.display_single_module(entry) end

function entry_makers.display_all_packages(entry) end
function entry_makers.display_module_packages(entry) end

function entry_makers.display_module_cmds(entry) end
function entry_makers.display_module_autocmds(entry) end

function entry_makers.display_binds_table(entry)
	-- print(vim.inspect(entry))
	  local function make_display(t)
	    local s = t.level .. " / " .. tsq.get_node_text(t.prefix,c.buf_ref) .. " / "
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