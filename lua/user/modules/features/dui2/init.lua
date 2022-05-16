local pickers = require("user.modules.features.dui2.pickers")

local doom_ui = {}

-- most of this should be moved into the nui module itself, so that we have
-- only relevant info here.
doom_ui.settings = {
  confirm_alternatives = { "yes", "no" },
  section_alternatives = { "user", "features", "langs", "core" },
  popup = {
    relative = "cursor",
    position = {
      row = 1,
      col = 0,
    },
    size = 20,
    border = {
      style = "rounded",
      text = {
        top = "[Input]",
        top_align = "left",
      },
    },
    win_options = {
      winhighlight = "Normal:Normal",
    },
  },
  menu = {
    position = "20%",
    size = {
      width = 20,
      height = 2,
    },
    relative = "editor",
    border = {
      style = "single",
      text = {
        top = "Choose Something",
        top_align = "center",
      },
    },
    win_options = {
      winblend = 10,
      winhighlight = "Normal:Normal",
    },
  },
}

-- doom_ui.packages = {
--    https://github.com/nvim-telescope/telescope-ui-select.nvim
-- }

local function reset()
  doom_ui_state = nil
end

doom_ui.cmds = {
	{ "DoomPickerMain", 		          function() pickers.doom_main_menu_picker() end, },
	{
	  "DoomPickerSettings",
	  function()
	    reset()
	    pickers.doom_settings_picker()
	  end,
	},
	{ "DoomPickerModules", 		        function() pickers.doom_modules_picker() end, },
	{ "DoomPickerModuleSettings", 		function() pickers.doom_module_settings_picker() end, },
	{ "DoomPickerModulePackages", 		function() pickers.doom_module_packages_picker() end, },
	{ "DoomPickerModuleCmds", 	      function() pickers.doom_module_cmds_picker() end, },
	{ "DoomPickerModuleAutocmds", 		function() pickers.doom_module_autocmds_picker() end, },
	{ "DoomPickerModuleBindsTable", 	function() pickers.doom_binds_table_picker() end, },
	{ "DoomPickerModuleBindsBranch", 	function() pickers.doom_binds_branch_picker() end, },
	{ "DoomPickerModuleBindsLeaf", 		function() pickers.doom_binds_leaf_picker() end, },
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
