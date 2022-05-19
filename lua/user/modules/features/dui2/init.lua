-- local pu =  require("user.utils.dui.utils")
local us =  require("user.utils.dui.uistate")

local pickers = require("user.utils.dui.pickers")

local doom_ui = {}

local function i(x)
  print(vim.inspect(x))
end

-- local uistate = {}
--
-- function uistate.ensure_doom_ui_state()

  doom_ui_state = {
    -- doom_global_extended,
    -- all_modules_flattened = nil,
    -- selected_module_idx = nil, -- is this necessary?
    -- selected_module = nil,
    -- selected_component = nil,
    -- buf_ref = nil,


    -- current = {
    --   title = nil, -- remove and do in picker
    --   results_prepared = nil, -- remove and do in picker
    --   picker = nil, -- remove
    --   selection = { item = nil, type = nil },
    --   line_str = nil,
    --   index_selected = nil,
    -- },

    history = {},
    next = function()
      -- -- for later with history
      -- if doom_ui_state ~= nil then return end

    -- local old_query = vim.deepcopy(doom_ui_state.query)
    --
    -- table.insert(doom_ui_state.history, 1, store)
    -- local hlen = #doom_ui_state.history
    -- if hlen > 10 then
    --   table.remove(doom_ui_state.history, hlen)
    -- end

	  pickers.doom_picker()
  end
  }

local function reset()
  doom_ui_state.query = nil
  doom_ui_state.selected_module = nil
  doom_ui_state.selected_component = nil
end

-- end
--
-- function uistate.reset_selections()
--   doom_ui_state.selected_module = nil
--   doom_ui_state.current = nil
-- end
--
-- function uistate.doom_ui_state_reset()
--   doom_ui_state = nil
-- end
--
-- -- function uistate.doom_ui_state_reset_modules()
-- --     doom_ui_state.all_modules_flattened = pu.get_modules_flattened()
-- -- end
--
--
-- function uistate.prev_hist()
--   local res = table.remove(doom_ui_state.history, 1)
--   if res ~= nil then
--     doom_ui_state.prev = res
--     doom_ui_state.prev.picker()
--   end
-- end
--
-- local function reset()
--   doom_ui_state = nil
-- end





local function main()
  reset()

  doom_ui_state.query = {
    type = "main_menu",
  }
  doom_ui_state.next()
end


doom_ui.cmds = {
	{
	  "DoomPickerMain",
	  function()
      main()
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
      { "k", [[ :DoomPickerModules<cr> ]], name = "all modules", options = { silent = false }, },
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
