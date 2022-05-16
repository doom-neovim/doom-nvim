local entry_makers = {}


--
-- ENTRY MAKERS
--

local function display_all_modules_list(entry)
	local function make_display(t)
	  return t.section .." > " .. t.name
	end
	return {
	  value = entry,
	  display = function(tbl) return make_display(tbl.value) end,
	  ordinal = entry.name,
	}
end

local function display_doom_settings(entry)
	    -- print((entry:named_child(1)):type())
	    local function e() end
	    local function d(node)
		local f1 = node:named_child(0)
		local f2 = node:named_child(1)
		local f2x = ntext(f2, c.buf_ref)
		local f2ccnt = f2:named_child_count()
		if f2:type() == "table_constructor" then f2x = " >>> { #"..f2ccnt.." }" end
		return (ntext(f1, c.buf_ref) .. " -> " .. f2x)
	    end
	    local function o() end
	  return {
	    value = entry,
	    display = function(tbl) return d(tbl.value) end,
	    ordinal = function(tbl) return d(tbl.value) end,
	  }
end

local function display_single_module(entry) end

local function display_all_packages(entry) end
local function display_module_packages(entry) end

local function display_module_cmds(entry) end
local function display_module_autocmds(entry) end

local function display_binds_table(entry)
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

local function display_binds_leaf(entry)
	  return {
	    value = entry,
	    display = function(tbl)
	      return tbl.value.key
	    end,
	    ordinal = entry,
	  }
end

local function display_binds_branch(entry)
	  return {
	    value = entry,
	    display = function(tbl)
	      return tbl.value.key
	    end,
	    ordinal = entry,
	  }
end

return entry_makers
