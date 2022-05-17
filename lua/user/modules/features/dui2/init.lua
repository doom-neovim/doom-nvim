local pickers = require("user.modules.features.dui2.pickers")

local doom_ui = {}

-- most of this should be moved into the nui module itself, so that we have
-- only relevant info here.


-- doom_ui.packages = {
--    https://github.com/nvim-telescope/telescope-ui-select.nvim
-- }

local function reset()
  doom_ui_state = nil
end

doom_ui.cmds = {
	{ "DoomPickerMain", 		          function() reset() pickers.doom_main_menu_picker() end, },
	{
	  "DoomPickerSettings",
	  function()
	    reset()
	    pickers.doom_settings_picker()
	  end,
	},

	{ "DoomPickerModuleFull", 		    function() reset() pickers.doom_module_full_picker() end, },

	{ "DoomPickerModules", 		        function() reset() pickers.doom_modules_picker() end, },
	{ "DoomPickerModuleSettings", 		function() reset() pickers.doom_module_settings_picker() end, },
	{ "DoomPickerModulePackages", 		function() reset() pickers.doom_module_packages_picker() end, },
	{ "DoomPickerModuleCmds", 	      function() reset() pickers.doom_module_cmds_picker() end, },
	{ "DoomPickerModuleAutocmds", 		function() reset() pickers.doom_module_autocmds_picker() end, },
	{ "DoomPickerModuleBindsTable", 	function() reset() pickers.doom_binds_table_picker() end, },
	{ "DoomPickerModuleBindsBranch", 	function() reset() pickers.doom_binds_branch_picker() end, },
	{ "DoomPickerModuleBindsLeaf", 		function() reset() pickers.doom_binds_leaf_picker() end, },
}

doom_ui.binds = {
  { "[n", ":DoomPickerMain<cr>", name = "doom main menu command"},
  { "[s", ":DoomPickerSettings<cr>", name = "picker doom settings"},
  { "[m", ":DoomPickerModules<cr>", name = "picker doom modules"},
  { "[b", ":DoomPickerModuleBinds<cr>", name = "picker doom binds"},
  {
    "<leader>",
    name = "+prefix",
    {
      {
        "n",
        name = "+nnn",
        {
          { "l", [[ :DoomPickerMain<cr> ]], name = "main menu", options = { silent = false }, },
          { "s", [[ :DoomPickerSettings<cr> ]], name = "settings", options = { silent = false }, }, -- lol

          { "n", [[ :DoomPickerModuleFull<cr> ]], name = "m_full", options = { silent = false }, },

          { "d", [[ :DoomPickerModules<cr> ]], name = "all modules", options = { silent = false }, },
          { "S", [[ :DoomPickerModuleSettings<cr> ]], name = "m settings", options = { silent = false }, },
          { "p", [[ :DoomPickerModulePackages<cr> ]], name = "m pgks", options = { silent = false }, },
          { "c", [[ :DoomPickerModuleCmds<cr> ]], name = "m cmds", options = { silent = false }, },
          { "a", [[ :DoomPickerModuleAutocmds<cr> ]], name = "m autocmds", options = { silent = false }, },
          { "f", [[ :DoomPickerModuleBindsTable<cr> ]], name = "m binds table", options = { silent = false }, },
          { "b", [[ :DoomPickerModuleBindsBranch<cr> ]], name = "m binds branch", options = { silent = false }, },
          { "w", [[ :DoomPickerModuleBindsLeaf<cr> ]], name = "m binds leaf", options = { silent = false }, },
        },
      },
    },
  },
}

return doom_ui
