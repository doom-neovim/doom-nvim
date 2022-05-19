local utils = require("doom.utils")
-- local fs = require("doom.utils.fs")
-- local system = require("doom.core.system")

-- dui
local me =  require("user.utils.dui.make_entry")
local mt =  require("user.utils.dui.make_title")
local mr =  require("user.utils.dui.make_results")

-- TELESCOPE
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
-- local entry_display = require("telescope.pickers.entry_display")
local actions_set = require("telescope.actions.set")
local state = require("telescope.actions.state")
local actions = require("telescope.actions")
local previewers = require("telescope.previewers")


local P = {}

local function i(x)
  print(vim.inspect(x))
end

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

-- TODO:
--
--    - ensure all result objects has type paramter

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

local MODULE_COMPONENTS = {
  "name",
  "enabled",
  "settings",
  "packages",
  "configs",
  "binds",
  "cmds",
  "autocmds",
  -- "options",
}

local BIND_COMPONENTS = {
  "prefix",
  "name",
  "rhs",
  "description",
  "mode",
  -- "options",
}

local function goback(prompt_bufnr, map)
	  return map("i", "<C-z>", function(prompt_bufnr)
	    require("telescope.actions").close(prompt_bufnr)
	    -- print(doom_ui_state.history[1].title)
	    -- us.prev_hist()
	  end)
end



local function line(buf)
  return state.get_current_line(buf)
end

local function selection(buf)
  return state.get_selected_entry(buf)
end

local function picker_get_state(prompt_bufnr)
  local state = require("telescope.actions.state")
  local line = state.get_current_line(prompt_bufnr)
  local fuzzy = state.get_selected_entry(prompt_bufnr)
  return fuzzy, line
end


-- local entry = {
--   type = "module_package",
--   data = {
--     table_path = k,
--     spec = spec,
--   },
--   list_display_props = {
--     {"PKG"},
--     {repo_name},
--     {pkg_name}
--   }
-- }


-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

--
-- PICKERS > MAIN MENU
--

P.doom_picker = function(type, components)


  local title = mt.get_title()
  local results = mr.get_results_for_query()

  -- i(results)
  -- print("picker -> query:", vim.inspect(doom_ui_state.query))
  -- print("picker -> title:", title)

  local opts = require("telescope.themes").get_ivy()
  require("telescope.pickers").new(opts, {

    prompt_title = title,

    finder = require("telescope.finders").new_table({

      results = results, -- rename/refact this func

      entry_maker = me.doom_displayer

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

--
-- PICKER > USER SETTINGS
--

P.doom_picker_settings_user = function()
  -- us.ensure_doom_ui_state()
  doom_ui_state.current.picker = P.doom_picker_settings_user
  doom_ui_state.current.title = "USER_SETTINGS" -- make into const
  -- move this to main menu ??
	doom_ui_state.prev.selection = {
    data = doom.settings,
    type = "doom_user_settings"
	}
  -- doom_ui_state.current.buf_ref = utils.get_buf_handle(utils.find_config("settings.lua"))
  doom_ui_state.current.results_prepared = mr.doom_get_flat({ "user_settings" })

  opts = require("telescope.themes").get_dropdown()
  require("telescope.pickers").new(opts, {
    prompt_title = doom_ui_state.current.title,
    finder = require("telescope.finders").new_table({
      results = doom_ui_state.current.results_prepared,
      entry_maker = me.display_doom_settings
    }),
    sorter = require("telescope.config").values.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
      goback(prompt_bufnr, map)
      return true
    end,
  }):find()

end


--
-- PICKERS > ALL <category>
--

-- @param filter
P.doom_picker_all_modules = function(c)
  -- us.ensure_doom_ui_state()
  -- us.doom_ui_state_reset_modules()
  doom_ui_state.current.title = "ALL MODULES"
  doom_ui_state.current.picker = P.doom_picker_all_modules

 --  local t_mappings = {
	--  --  { "<cr>:EDIT", "i", "<CR>",
	--  --    function(prompt_bufnr)
	--  --      local fuzzy, line = picker_get_state(prompt_bufnr)
	--  --      require("telescope.actions").close(prompt_bufnr)
	-- 	--     doom_ui_state.current.selection = fuzzy.value
	-- 	--     ax.m_edit(doom_ui_state.current.selection)
	-- 	--   end
	-- 	-- },
	--   { "^a:DISPLAY", "i", "<C-a>",
	--     function(prompt_bufnr)
	--       local fuzzy, line = picker_get_state(prompt_bufnr)
	--       require("telescope.actions").close(prompt_bufnr)
	-- 	    doom_ui_state.selected_module_idx = fuzzy.index
	-- 	    doom_ui_state.current.selection = fuzzy.value
	-- 	    us.next(P.doom_picker_single_module_full)
	--     end
	--   },
	--   { "^r:RENAME", "i", "<C-r>",
	--     function(prompt_bufnr)
	--       local fuzzy, line = picker_get_state(prompt_bufnr)
	--       require("telescope.actions").close(prompt_bufnr)
	-- 	    doom_ui_state.current.selection = fuzzy.value
	-- 	    ax.m_rename()
	--     end
	--   },
	--   {"^e:CREATE","i", "<C-e>",
	--     function(prompt_bufnr)
	--       local fuzzy, line = picker_get_state(prompt_bufnr)
	--       require("telescope.actions").close(prompt_bufnr)
	-- 	    doom_ui_state.current.selection = fuzzy.value
	-- 	    ax.m_create()
	--     end
	--   },
	--   {"^u:DELETE","i", "<C-u>",
	--     function(prompt_bufnr)
	--       local fuzzy, line = picker_get_state(prompt_bufnr)
	--       require("telescope.actions").close(prompt_bufnr)
	-- 	    doom_ui_state.current.selection = fuzzy.value
	-- 	    ax.m_delete()
	--     end
	--   },
	--   {"^t:TOGGLE","i", "<C-t>",
	--     function(prompt_bufnr)
	--       local fuzzy, line = picker_get_state(prompt_bufnr)
	--       require("telescope.actions").close(prompt_bufnr)
	-- 	    doom_ui_state.current.selection = fuzzy.value
	-- 	    ax.m_toggle()
	--     end
	--   },
	--   {"^b:BINDS","i", "<C-b>",
	--     function(prompt_bufnr)
	--       local fuzzy, line = picker_get_state(prompt_bufnr)
	--       require("telescope.actions").close(prompt_bufnr)
	-- 	    doom_ui_state.current.selection = fuzzy.value
	-- 	    us.next(P.doom_binds_table_picker)
	--     end
	--   },
	-- }

  local doom_modules_theme = require("telescope.themes").get_dropdown()

  -- doom_ui_state.current.results_prepared = pu.doom_get_flat({ "modules" })
  doom_ui_state.results_prepared = doom_ui_state.all_modules_flattened

  require("telescope.pickers").new(doom_modules_theme, {
    prompt_title = doom_ui_state.current.title,
    finder = require("telescope.finders").new_table({
      results = doom_ui_state.results_prepared,
      entry_maker = me.display_all_modules
    }),
    sorter = require("telescope.config").values.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)

      -- <CR>
      actions_set.select:replace(function()
	      local fuzzy, line = picker_get_state(prompt_bufnr)
	      require("telescope.actions").close(prompt_bufnr)
        fuzzy.value.mappings["<CR>"](fuzzy, line)
	    end)

	    map("i", "<C-a>", function()
	      local fuzzy, line = picker_get_state(prompt_bufnr)
	      require("telescope.actions").close(prompt_bufnr)
	      i(fuzzy)
	      fuzzy.value.mappings["<C-a>"](fuzzy, line)
	    end)

      -- <C-z>
	    goback(prompt_bufnr, map)

      return true
    end,
  }):find()
end


P.doom_picker_all_module_settings = function() end
P.doom_picker_all_module_packages = function() end
P.doom_picker_all_module_binds = function() end
P.doom_picker_all_module_cmds = function() end
P.doom_picker_all_module_autocmds = function() end
P.doom_picker_all_module_binds = function() end
-- P.doom_picker_everything = function() end -- just for fun. becomes huge list...

--
-- PICKERS > SINGLE MODULE
--

P.doom_picker_single_module_full = function()
  -- us.ensure_doom_ui_state()
  -- us.doom_ui_state_reset_modules()
  doom_ui_state.current.picker = P.doom_picker_single_module_full


  -- move this chunk into flattener func.??
  local postfix = ""
  if doom_ui_state.selected_module_idx ~= nil then
	  local idx = doom_ui_state.selected_module_idx
	  local morig = doom_ui_state.all_modules_flattened[idx].origin
	  local mfeat = doom_ui_state.all_modules_flattened[idx].section
	  local mname = doom_ui_state.all_modules_flattened[idx].name
	  local menab = doom_ui_state.all_modules_flattened[idx].enabled
    local on = menab and "enabled" or "disabled"
	  postfix = postfix .. "["..morig..":"..mfeat.."] -> " .. mname .. " (" .. on .. ")"
  end
  doom_ui_state.current.title = "MODULE_FULL: " .. postfix -- make into const


  doom_ui_state.current.results_prepared = pu.doom_get_flat({
    "settings",
    "packages",
    "configs",
    "binds",
    "cmds",
    "autocmds",
  })

  opts = require("telescope.themes").get_ivy()
  require("telescope.pickers").new(opts, {
    prompt_title = doom_ui_state.current.title,
    finder = require("telescope.finders").new_table({
      results = doom_ui_state.current.results_prepared,
      entry_maker = me.display_module_full,
    }),
    sorter = require("telescope.config").values.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
	    goback(prompt_bufnr, map)
      return true
    end,
   --  previewer = previewers.new_buffer_previewer({
	  --   define_preview = function() return "xxxxxxxxxx" end,
	  -- })
  }):find()

end

P.doom_picker_single_module_settings = function(c) end

-- P.doom_picker_single_module_packages = function()
--   -- us.ensure_doom_ui_state()
--   doom_ui_state.current.picker = P.doom_picker_single_module_packages
--   doom_ui_state.current.title = "MODULE PACKAGES" -- make into const
--   opts = opts or require("telescope.themes").get_cursor()
--   require("telescope.pickers").new(opts, {
--     prompt_title = "create user module",
--     finder = require("telescope.finders").new_table({
--       results = config.entries,
--       entry_maker = display_module_packages,
--     }),
--     sorter = require("telescope.config").values.generic_sorter(opts),
--     attach_mappings = function(prompt_bufnr, map)
-- 	    goback(prompt_bufnr, map)
--       return true
--     end,
--   }):find()
-- end

P.doom_picker_single_module_configs = function() end
P.doom_picker_single_module_cmds = function() end
P.doom_picker_single_module_autocmds = function() end
P.doom_picker_single_module_binds = function() end

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

--
-- PICKERS > TREESITTER (deprecated)
--

P.doom_picker_settings_user = function()
  us.ensure_doom_ui_state()

  -- @param table_constructor
  -- refactor into ts table_construct_get_sub_fields(???)
  local function ts_table_picker_prepare(t)
    local prep = {}
    for n in t:iter_children() do
      if n:named() and n:type(1) ~= "comment" then
        table.insert(prep, n)
	    end
    end
    return prep
  end

  -- replace `_` in entry_maker with ` `
  doom_ui_state.current.title = "USER_SETTINGS" -- make into const

  doom_ui_state.current.picker = P.doom_settings_picker

  if doom_ui_state.prev.buf_ref == nil or doom_ui_state.prev.title ~= "USER SETTINGS" then
    doom_ui_state.current.buf_ref = utils.get_buf_handle(utils.find_config("settings.lua"))
	  doom_ui_state.current.results_prepared = ts_table_picker_prepare(ts.ts_get_doom_captures(
	    doom_ui_state.current.buf_ref, "doom_root.settings_table")[1]
	  )
  else
    doom_ui_state.current.buf_ref = doom_ui_state.prev.buf_ref
	  doom_ui_state.current.results_prepared = ts_table_picker_prepare(doom_ui_state.prev.selection)
  end

  -- for each results -> add type = "settings_field"

  opts = require("telescope.themes").get_dropdown()

  require("telescope.pickers").new(opts, {
    prompt_title = doom_ui_state.current.title,
    finder = require("telescope.finders").new_table({
      results = doom_ui_state.current.results_prepared,
      entry_maker = me.display_doom_settings
    }),
    sorter = require("telescope.config").values.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)

      actions_set.select:replace(function()
        local node = selection(prompt_bufnr).value
        require("telescope.actions").close(prompt_bufnr)
	      local field_key = node:named_child(0)
	      local field_value = node:named_child(1)
	      if field_value:type() == "table_constructor" then
		      doom_ui_state.current.selection = field_value
          us.next(P.doom_settings_picker)
	      else
	   	      local sr,sc,er,ec = field_key:range()
	  	      vim.api.nvim_win_set_buf(0, doom_ui_state.current.buf_ref)
	  	      vim.fn.cursor(er+1,ec)
	      end
      end)
      goback(prompt_bufnr, map)

      return true
    end,
  }):find()

end

--
-- P.doom_binds_table_picker_treesitter = function()
--   us.ensure_doom_ui_state()
--   doom_ui_state.current.title = "BINDS TABLE"
--   doom_ui_state.current.picker = P.doom_binds_table_picker
--
--   -- if doom_ui_state.prev ~= nil then
--   --   print(vim.inspect(doom_ui_state.prev.selection))
--   -- end
--
--   -- TODO: attach the nest data to the module.
--   --
--   -- 1. find which module we are working on.
--   -- 2. extend the module with the nest binds data.
--
--   if doom_ui_state.current.buf_ref == nil then
--     local p
--     if doom_ui_state.prev.selection.type == "module" then
-- 	    p = doom_ui_state.prev.selection.path .. "/init.lua"
--     end
--     doom_ui_state.current.buf_ref = utils.get_buf_handle(p)
--   end
--
--   if doom_ui_state.prev.selection.type == nil
--     or doom_ui_state.prev.selection.type ~= "binds_table"
--     or doom_ui_state.prev.selection.type ~= "binds_branch"
--     or doom_ui_state.prev.selection.type ~= "binds_leaf"
--   then
--     local t_nest_table_nodes = ts.ts_get_doom_captures(doom_ui_state.current.buf_ref, "doom_module.binds_table")
--     local nestdata =  tst.parse_nest_tables_meta_data(doom_ui_state.current.buf_ref, t_nest_table_nodes[1])
--     doom_ui_state.current.results_prepared = nestdata[1]
--   else
--     doom_ui_state.current.results_prepared = doom_ui_state.prev.selection
--   end
--
--   local opts = opts or require("telescope.themes").get_dropdown()
--
--   pickers.new(opts, {
--     title = doom_ui_state.current.title,
--     finder = finders.new_table({
--       results = doom_ui_state.current.results_prepared,
--       entry_maker = me.display_binds_table,
--     }),
--     sorter = opts.sorter or conf.generic_sorter(opts),
--     attach_mappings = function(prompt_bufnr, map)
--
--       actions_set.select:replace(function()
--         local fuzzy = selection(prompt_bufnr)
--         actions.close(prompt_bufnr)
--
-- 	      doom_ui_state.current.selection = fuzzy.value
--
-- 	      if fuzzy.value.type == "binds_branch" then
-- 	        us.next(P.doom_binds_branch_picker)
-- 	      elseif fuzzy.value.type == "binds_leaf" then
-- 	        us.next(P.doom_binds_leaf_picker)
-- 	      else
-- 	      end
--
--       end)
--
-- 	    goback(prompt_bufnr, map)
--
--       return true
--     end,
--  --    previewer = previewers.new_buffer_previewer({
-- 	--   define_preview = function() return vim.inspect(c.data) end,
-- 	-- })
--   }):find()
-- end
--
-- P.doom_binds_leaf_picker_treesitter = function(c)
--   us.ensure_doom_ui_state()
--   doom_ui_state.current.title = "BINDS LEAF"
--   doom_ui_state.current.picker = P.doom_binds_leaf_picker
--   if doom_ui_state.prev.selection.type ~= "binds_leaf" then
--     return
--   end
--
--   local prep_results = {}
--   for k, v in pairs(doom_ui_state.prev.selection) do
--     if vim.tbl_contains(BIND_COMPONENTS, k) then
--   	table.insert(prep_results,{
--   	  key = k,
--   	  value = v
--   	})
--     end
--   end
--
--   doom_ui_state.current.results_prepared = prep_results
--
--   local opts = opts or require("telescope.themes").get_dropdown()
--
--   pickers.new(opts, {
--     title = doom_ui_state.current.title,
--     finder = finders.new_table({
--       results = doom_ui_state.current.results_prepared,
--       entry_maker = me.display_binds_leaf, -- child of results
--     }),
--     sorter = opts.sorter or conf.generic_sorter(opts),
--     attach_mappings = function(prompt_bufnr, map)
--         actions_set.select:replace(function()
--           local fuzzy = selection(prompt_bufnr)
--           actions.close(prompt_bufnr)
-- 	        local sr,sc,er,ec = fuzzy.value.value:range()
-- 	        -- doom_ui_state.current.selection = ??
-- 	        vim.api.nvim_win_set_buf(0, doom_ui_state.current.buf_ref)
-- 	        vim.fn.cursor(er+1,ec)
--         end)
--         goback(prompt_bufnr, map)
--         return true
--       end,
--  --    previewer = previewers.new_buffer_previewer({
-- 	--   define_preview = function() return vim.inspect(c.data) end,
-- 	-- })
--   }):find()
-- end
--
-- P.doom_binds_branch_picker_treesitter = function(c)
--   us.ensure_doom_ui_state()
--   doom_ui_state.current.title = "BINDS BRANCH"
--   doom_ui_state.current.picker = P.doom_binds_branch_picker
--   if doom_ui_state.prev.selection.type ~= "binds_branch" then
--     return
--   end
--
--   local prep_results = {}
--   for k, v in pairs(doom_ui_state.prev.selection) do
--     if vim.tbl_contains(BIND_COMPONENTS, k) then
--   	table.insert(prep_results,{
--   	  key = k,
--   	  value = v
--   	})
--     end
--   end
--
--   doom_ui_state.current.results_prepared = prep_results
--
--   local opts = opts or require("telescope.themes").get_dropdown()
--
--   pickers.new(opts, {
--     title = doom_ui_state.current.title,
--     finder = finders.new_table({
--       results = doom_ui_state.current.results_prepared,
--       entry_maker = mme.display_binds_branch, -- child of results
--     }),
--     sorter = opts.sorter or conf.generic_sorter(opts),
--     attach_mappings = function(prompt_bufnr, map)
--         actions_set.select:replace(function()
--           local fuzzy = selection(prompt_bufnr)
--           actions.close(prompt_bufnr)
--           if type(fuzzy.value.value) == "table" then
-- 	          doom_ui_state.current.selection = fuzzy.value.value
-- 	  	      us.next(P.doom_binds_table_picker)
-- 	        else
-- 	  	      local sr,sc,er,ec = fuzzy.value.value:range()
-- 	  	      vim.fn.cursor(er+1,ec)
-- 	        end
--         end)
--         goback(prompt_bufnr, map)
--         return true
--       end,
--  --    previewer = previewers.new_buffer_previewer({
-- 	--   define_preview = function() return "-----" end,
-- 	-- })
--   }):find()
-- end

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

return P
