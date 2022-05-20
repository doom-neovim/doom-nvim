local entry_display = require("telescope.pickers.entry_display")

-- local ts = require("user.utils.dui.ts")

local function i(x)
  print(vim.inspect(x))
end

local entry_makers = {}

function entry_makers.doom_displayer(entry)
  -- print(entry.value)
  local displayer = entry_display.create {
    separator = "▏",
    items = {
      -- todo: make this dynamic
      { width = 10 },
      { width = 20 },
      { width = 20 },
      { width = 20 },
      { width = 20 },
      { width = 20 },
      { remaining = true },
    },
  }

  -- i(entry)

  local make_display = function(entry)
    -- i(entry)
    return displayer(entry.value.list_display_props)
  end

	return {
	  value = entry,
	  display = make_display,
	  ordinal = entry.type,
	}
end

return entry_makers
