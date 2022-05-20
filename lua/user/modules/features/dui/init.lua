local mt =  require("user.modules.features.dui.make_title")
local mr =  require("user.modules.features.dui.make_results")

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions_set = require("telescope.actions.set")
local state = require("telescope.actions.state")
local actions = require("telescope.actions")
local previewers = require("telescope.previewers")
local entry_display = require("telescope.pickers.entry_display")

local doom_ui = {}

-- TODO:
--
--    - sorters
--    - displayers
--    - native fuzzy
--    - properly use the options object
--    - ovrerride actions properly.
--    - refactor the `table-tree-flattener`
--        -> use same for settings trees, and flat package/cmd lists
--    -
--

local function i(x)
  print(vim.inspect(x))
end

local function goback(prompt_bufnr, map)
	  return map("i", "<C-z>", function(prompt_bufnr)
	    require("telescope.actions").close(prompt_bufnr)
	    -- print(doom_ui_state.history[1].title)
	    -- us.prev_hist()
	  end)
end

local function picker_get_state(prompt_bufnr)
  local state = require("telescope.actions.state")
  local line = state.get_current_line(prompt_bufnr)
  local fuzzy = state.get_selected_entry(prompt_bufnr)
  return fuzzy, line
end

local function i(x)
  print(vim.inspect(x))
end

-- TODO: make this dynamic / add display configs to each parts result maker.
function doom_displayer(entry)
  local displayer = entry_display.create {
    separator = "▏",
    items = {
      { width = 10 },
      { width = 20 },
      { width = 20 },
      { width = 20 },
      { width = 20 },
      { width = 20 },
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

-- return entry_makers

local function doom_picker(type, components)
  local title = mt.get_title()
  local results = mr.get_results_for_query()
  -- i(results)
  -- print("picker -> query:", vim.inspect(doom_ui_state.query))
  -- print("picker -> title:", title)
  local opts = require("telescope.themes").get_ivy()
  require("telescope.pickers").new(opts, {
    prompt_title = title,
    finder = require("telescope.finders").new_table({
      results = results,
      entry_maker = doom_displayer
    }),
    sorter = require("telescope.config").values.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)

      actions_set.select:replace(function()
	      local fuzzy, line = picker_get_state(prompt_bufnr)
	      require("telescope.actions").close(prompt_bufnr)
        fuzzy.value.mappings["<CR>"](fuzzy, line)
	    end)

	    map("i", "<C-a>", function()
	      local fuzzy, line = picker_get_state(prompt_bufnr)
	      require("telescope.actions").close(prompt_bufnr)
	      if fuzzy.value.mappings["<C-a>"] ~= nil then
	        fuzzy.value.mappings["<C-a>"](fuzzy, line)
	      end
	    end)

	    goback(prompt_bufnr, map)

      return true
    end

  }):find()

end

-- TODO: read up on telescopes internal history maker.
doom_ui_state = {
    history = {},
    next = function()
      -- if doom_ui_state ~= nil then return end
    -- local old_query = vim.deepcopy(doom_ui_state.query)
    -- table.insert(doom_ui_state.history, 1, store)
    -- local hlen = #doom_ui_state.history
    -- if hlen > 10 then
    --   table.remove(doom_ui_state.history, hlen)
    -- end
	  doom_picker()
  end
  }

local function reset()
  doom_ui_state.query = nil
  doom_ui_state.selected_module = nil
  doom_ui_state.selected_component = nil
end

doom_ui.cmds = {
	{
	  "DoomPickerMain",
	  function()
      reset()
      doom_ui_state.query = {
        type = "main_menu",
      }
      doom_ui_state.next()
	  end
	},
	-- {
	--   "DoomPickerSettings",
	--   function()
	--     reset()
	--     pickers.doom_settings_picker()
	--   end,
	-- },
	--
	-- {
	--   "DoomPickerModuleFull",
	--   function()
	--     reset()
	--     pickers.doom_module_full_picker()
	--   end,
	-- },
	--
	-- {
	--   "DoomPickerModules",
	--   function()
	--     reset()
	--     pickers.doom_picker_all_modules()
	--   end,
	-- },

	-- { "DoomPickerModuleSettings", 		function() reset() pickers.doom_module_settings_picker() end, },
	-- { "DoomPickerModulePackages", 		function() reset() pickers.doom_module_packages_picker() end, },
	-- { "DoomPickerModuleCmds", 	      function() reset() pickers.doom_module_cmds_picker() end, },
	-- { "DoomPickerModuleAutocmds", 		function() reset() pickers.doom_module_autocmds_picker() end, },
	-- { "DoomPickerModuleBindsTable", 	function() reset() pickers.doom_binds_table_picker() end, },
	-- { "DoomPickerModuleBindsBranch", 	function() reset() pickers.doom_binds_branch_picker() end, },
	-- { "DoomPickerModuleBindsLeaf", 		function() reset() pickers.doom_binds_leaf_picker() end, },

	-- todo: all modules + settings, so that you can really access everything
	--    from one fuzzy finder
}

doom_ui.binds = {
  -- { "[n", ":DoomPickerMain<cr>", name = "doom main menu command"},
  -- { "[s", ":DoomPickerSettings<cr>", name = "picker doom settings"},
  -- { "[m", ":DoomPickerModules<cr>", name = "picker doom modules"},
  -- { "[b", ":DoomPickerModuleBinds<cr>", name = "picker doom binds"},
  {
    "<leader>",
    name = "+prefix",
    {
      -- TODO: this should be all mods + settings, so that everything can be reached.
      { "k", [[ :DoomPickerMain<cr> ]], name = "all modules", options = { silent = false }, },
      {
        "n",
        name = "+nnn",
        {
          { "l", [[ :DoomPickerMain<cr> ]], name = "main menu", options = { silent = false }, },
          -- { "s", [[ :DoomPickerSettings<cr> ]], name = "settings", options = { silent = false }, }, -- lol
          -- { "n", [[ :DoomPickerModuleFull<cr> ]], name = "m_full", options = { silent = false }, },
          -- { "S", [[ :DoomPickerModuleSettings<cr> ]], name = "m settings", options = { silent = false }, },
          -- { "p", [[ :DoomPickerModulePackages<cr> ]], name = "m pgks", options = { silent = false }, },
          -- { "c", [[ :DoomPickerModuleCmds<cr> ]], name = "m cmds", options = { silent = false }, },
          -- { "a", [[ :DoomPickerModuleAutocmds<cr> ]], name = "m autocmds", options = { silent = false }, },
          -- { "f", [[ :DoomPickerModuleBindsTable<cr> ]], name = "m binds table", options = { silent = false }, },
          -- { "b", [[ :DoomPickerModuleBindsBranch<cr> ]], name = "m binds branch", options = { silent = false }, },
          -- { "w", [[ :DoomPickerModuleBindsLeaf<cr> ]], name = "m binds leaf", options = { silent = false }, },
        },
      },
    },
  },
}

return doom_ui
