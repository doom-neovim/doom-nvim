-- DOOM
local utils = require("doom.utils")
local fs = require("doom.utils.fs")
local system = require("doom.core.system")


-- DOOM_UI
local pickers = require("user.modules.features.doom_ui.pickers")
local sh = require("user.modules.features.doom_ui.shell")

-- TREESITTER
local tsq = require("vim.treesitter.query")
local parsers = require "nvim-treesitter.parsers"

-- TELESCOPE
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local entry_display = require("telescope.pickers.entry_display")
local actions_set = require("telescope.actions.set")
local state = require("telescope.actions.state")
local actions = require("telescope.actions")
local previewers = require("telescope.previewers")


local doom_ui = {}


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

--
-- CONSTS
--

local ROOT_MODULES = utils.find_config("modules.lua")

local bind_params = {
  "prefix",
  "name",
  "rhs",
  "description",
  "mode",
  -- "options",
}

--
-- HELPERS
--

local function ntext(n,b) return tsq.get_node_text(n, b) end


-- also with architext it would probably become easier to capture nodes later.
-- actually it would probably be easier to use smaller functions for queryint patterns
-- and capturing tables later, as long as you keep stuff in tables it should be
-- quite easy to make small queries for capturing nodes and shit. and this would mean
-- that you could replace the whole recursive ts tree. and just utilize the
-- in build tree which is of course much better since the other way would be more maintenance.
--

--
-- PARSE `MODULES.LUA` AND UPDATE MODULE.
--

-- I BELIEVE THAT THIS FUNCTION ALSO EXPECTS THE (TABLE_CONSTRUCTOR) NODE
-- AS INPUT.
local function transform_root_mod_file(m, cb)

  local buf = utils.get_buf_handle(ROOT_MODULES)

  local query_str = doom_ui.get_query_file("lua", "doom_root_modules")
  local language_tree = vim.treesitter.get_parser(buf, "lua")
  local syntax_tree = language_tree:parse()
  local root = syntax_tree[1]:root()
  local qp = vim.treesitter.parse_query("lua", query_str)

  local sm_ll = 0 -- section module last line

  if qp ~= nil then
    for id, node, metadata in qp:iter_captures(root, buf, root:start(), root:end_()) do
      local cname = qp.captures[id] -- name of the capture in the query
      local node_text = ntext(node, buf)
      -- local p = node:parent()
      local ps = (node:parent()):prev_sibling()
      if ps ~= nil then
        local pss = ps:prev_sibling()
        if pss ~= nil then
          local section_text = ntext(pss, buf)
          if m.section == section_text then
            sm_ll, _, _, _ = node:range()
            if cb ~= nil then
              cb(buf, node, cname, node_text)
            end
          end
        end
      end
    end
  end
  -- vim.api.nvim_win_set_buf(0, buf)
  return buf, sm_ll + 1
end

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

pickers.cmds = {
	{ "DoomPickerMain", 		          function() pickers.doom_main_menu_picker() end, },
	{ "DoomPickerSettings", 		      function() pickers.doom_settings_picker() end, },
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
