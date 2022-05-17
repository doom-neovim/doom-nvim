local utils = require("doom.utils")
-- local fs = require("doom.utils.fs")
-- local system = require("doom.core.system")

-- dui
local us = require("user.modules.features.dui2.uistate")
local ts = require("user.modules.features.dui2.ts")
local em = require("user.modules.features.dui2.make_entry")
local ax = require("user.modules.features.dui2.actions")
local tst = require("user.modules.features.dui2.ts_traverse")
local pu = require("user.modules.features.dui2.utils")

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
	    us.prev_hist()
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

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

--
-- PICKERS
--

-- @param filter
P.doom_modules_picker = function(c)
  us.ensure_doom_ui_state()
  us.doom_ui_state_reset_modules()
  doom_ui_state.current.title = "ALL MODULES"
  doom_ui_state.current.picker = P.doom_modules_picker

  local function mappings_prepare(prompt_bufnr)
	  local fuzzy, line = picker_get_state(prompt_bufnr)
	  require("telescope.actions").close(prompt_bufnr)
	  return fuzzy, line
  end

  local t_mappings = {
	  { "<cr>:EDIT", "i", "<CR>",
	    function(prompt_bufnr)
        local fuzzy, line = mappings_prepare(prompt_bufnr)
		    doom_ui_state.current.selection = fuzzy.value
		    ax.m_edit(doom_ui_state.current.selection)
		  end
		},
	  { "^a:DISPLAY", "i", "<C-a>",
	    function(prompt_bufnr)
        local fuzzy, line = mappings_prepare(prompt_bufnr)

        -- i(fuzzy)

		    doom_ui_state.selected_module_idx = fuzzy.index
		    doom_ui_state.current.selection = fuzzy.value
		    us.next(P.doom_module_full_picker)
	    end
	  },
	  { "^r:RENAME", "i", "<C-r>",
	    function(prompt_bufnr)
        local fuzzy, line = mappings_prepare(prompt_bufnr)
		    doom_ui_state.current.selection = fuzzy.value
		    ax.m_rename()
	    end
	  },
	  {"^e:CREATE","i", "<C-e>",
	    function(prompt_bufnr)
        local fuzzy, line = mappings_prepare(prompt_bufnr)
		    doom_ui_state.current.selection = fuzzy.value
		    ax.m_create()
	    end
	  },
	  {"^u:DELETE","i", "<C-u>",
	    function(prompt_bufnr)
        local fuzzy, line = mappings_prepare(prompt_bufnr)
		    doom_ui_state.current.selection = fuzzy.value
		    ax.m_delete()
	    end
	  },
	  {"^t:TOGGLE","i", "<C-t>",
	    function(prompt_bufnr)
        local fuzzy, line = mappings_prepare(prompt_bufnr)
		    doom_ui_state.current.selection = fuzzy.value
		    ax.m_toggle()
	    end
	  },
	  {"^b:BINDS","i", "<C-b>",
	    function(prompt_bufnr)
        local fuzzy, line = mappings_prepare(prompt_bufnr)
		    doom_ui_state.current.selection = fuzzy.value
		    us.next(P.doom_binds_table_picker)
	    end
	  },
	}

  local function create_maps()
  end

  local function ts_table_picker_prepare(t)
  end

  local doom_modules_theme = require("telescope.themes").get_dropdown()

  -- type = "module" for all modules.
  doom_ui_state.results_prepared = doom_ui_state.all_modules_flattened

  require("telescope.pickers").new(doom_modules_theme, {
    prompt_title = doom_ui_state.current.title,
    finder = require("telescope.finders").new_table({
      results = doom_ui_state.results_prepared,
      entry_maker = em.display_all_modules
    }),
    sorter = require("telescope.config").values.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)

      for _,m in pairs(t_mappings) do
	      map(m[2], m[3], m[4])
	      goback(prompt_bufnr, map)
      end
      return true
    end,
  }):find()
end

P.doom_main_menu_picker = function(c)
  us.ensure_doom_ui_state()
  doom_ui_state.current.title = "MAIN MENU"
  doom_ui_state.current.picker = P.doom_main_menu_picker

  local function mappings_prepare(prompt_bufnr)
	  local fuzzy, line = picker_get_state(prompt_bufnr)
	  require("telescope.actions").close(prompt_bufnr)
	  return fuzzy, line
  end

  local doom_menu_items = {
		{ "open config", function() vim.cmd(("e %s"):format(require("doom.core.config").source)) end },
  		{ "edit settings",function() us.next(P.doom_settings_picker) end },
  		{ "browse modules",  function() us.next(P.doom_modules_picker) end },
  		{ "binds    (todo..)",function() end },
  		{ "autocmds (todo..)", function() end },
  		{ "cmds     (todo..)", function() end },
  		{ "packages (todo..)", function() end },
  		{ "jobs 	  (todo..)",function() end },
  }

  -- add type tag
  for _, v in ipairs(doom_menu_items) do
    doom_menu_items["type"] = "main_menu"
  end

  doom_ui_state.current.results_prepared = doom_menu_items

  local doom_menu_theme = require("telescope.themes").get_dropdown()
  opts = opts or require("telescope.themes").get_ivy()

  require("telescope.pickers").new(doom_menu_theme, {
    prompt_title = doom_ui_state.current.title,
    finder = require("telescope.finders").new_table({
      results = doom_menu_items,
      entry_maker = function(entry)
	      local function make_display(t)
	        local s = t.level .. " / " .. tsq.get_node_text(t.prefix,c.buf_ref) .. " / "
	        -- print(s)
	        return s
	      end
	      return {
	        value = entry,
	        display = entry[1],
	        ordinal = entry[1],
	      }
	    end,
    }),
    sorter = require("telescope.config").values.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
        actions_set.select:replace(function()
	        local fuzzy, line = picker_get_state(prompt_bufnr)
	        require("telescope.actions").close(prompt_bufnr)
	        for _,m in pairs(doom_menu_items) do if m[1] == fuzzy.value[1] then m[2]() end end

	      end)
	      goback(prompt_bufnr, map)
      return true
    end
  }):find()

end

-- REFACTOR: GENERING TABLE PICKER
P.doom_settings_picker = function()
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
      entry_maker = em.display_doom_settings
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

-- create binding for this in the modules picker.
P.doom_module_full_picker = function()
  us.ensure_doom_ui_state()
  us.doom_ui_state_reset_modules()


  local postfix = ""
  if doom_ui_state.selected_module_idx ~= nil then
	  local idx = doom_ui_state.selected_module_idx

	  local morig = doom_ui_state.all_modules_flattened[idx].origin
	  local mfeat = doom_ui_state.all_modules_flattened[idx].section
	  local mname = doom_ui_state.all_modules_flattened[idx].name
	  local menab = doom_ui_state.all_modules_flattened[idx].enabled

	  postfix = postfix .. morig .. ">" .. mfeat .. ">" .. mname .. " (enabled=" .. tostring(menab) .. ")"
  end

  doom_ui_state.current.title = "MODULE_FULL " .. postfix -- make into const




  doom_ui_state.current.picker = P.doom_module_full_picker

  -- try current buffer? or prev
  -- if prev module then
  --
  -- else
  --    if current buf path exists in all modules list?
  --    assign currently selected module index/ID.
  -- end

  -- assign currently selected module. index!!!
  --    create title based on the selected module > so that we can show `MODULE: doom > feat > lsp (disabled)`

  local prep = {}


  -- move this to

  for k, v in pairs(doom_ui_state.prev.selection) do
    -- print(k, v)

    if vim.tbl_contains(MODULE_COMPONENTS, k) then

      -- TODO: monitor state in the preview window??
      --
      -- TODO: the work `key` should be replaced by `type`
      --
      -- also each entry has to have enough information
      --
      --
      -- {
      --    type = string,
      --    ...
      --    ... flattened params..
      --    ..
      --    .
      -- }


      if k == "settings" then -- TODO: requires flattening
        for a, b in pairs(v) do
          table.insert(prep, { key = "module_setting", value = { key = a, value = b } })
        end

      elseif k == "packages" then -- TODO: could use a flattening func that accounts for plain strings and anonymous tables.
        for pname, pkg in pairs(v) do
          -- i(pkg)
          table.insert(prep, { key = "module_package", value = pkg })
        end

      elseif k == "configs" then -- TODO: flatten -> account for table / func
        for cn, cfg in pairs(v) do
          -- i(cfg)
          -- table.insert(prep, { key = "module_config", value = pkg })
        end

      elseif k == "cmds" then -- TODO: put all entries in keys?
        for _, cmd in pairs(v) do
          i(cmd)
          -- table.insert(prep, { key = "module_cmd", value = pkg })
        end

      elseif k == "autocmds" then -- TODO: same as cmds
        for _, autocmd in pairs(v) do
          i(autocmd)
      --     table.insert(prep, { key = "module_package", value = pkg })
        end

      elseif k == "binds" then -- TODO: improve displayer; make sure all necessary keys are in the entry table.
          for _, bind_flat in ipairs(pu.binds_flattened(v)) do

            -- REMOVE: i should just pass the flat bind
            table.insert(prep, { key = bind_flat.type, value = bind_flat })
          end


      else
        table.insert(prep, {
          key = k,
          value = v
        })
      end

    end
  end

  -- i(prep)

  doom_ui_state.current.results_prepared = prep

	-- print("full module prep res ->", vim.inspect(doom_ui_state.current.results_prepared))

  opts = require("telescope.themes").get_ivy()

  require("telescope.pickers").new(opts, {

    prompt_title = doom_ui_state.current.title,

    finder = require("telescope.finders").new_table({
      results = doom_ui_state.current.results_prepared,
      entry_maker = em.display_module_full,
    }),
    sorter = require("telescope.config").values.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
      -- map("i", "<CR>", pass_entry_to_callback)
      -- map("n", "<CR>", pass_entry_to_callback)
	    goback(prompt_bufnr, map)
      return true
    end,
   --  previewer = previewers.new_buffer_previewer({
	  --   define_preview = function() return "xxxxxxxxxx" end,
	  -- })
  }):find()

end

P.doom_module_settings_picker = function(c) end


P.doom_module_packages_picker = function()
  us.ensure_doom_ui_state()
  doom_ui_state.current.title = "MODULE PACKAGES" -- make into const

  doom_ui_state.current.picker = P.doom_settings_picker


  local function pass_entry_to_callback(prompt_buf)
    local state = require("telescope.actions.state")
    local fuzzy_selection = state.get_selected_entry(prompt_bufnr)
    require("telescope.actions").close(prompt_buf)
    config.callback(config.entries_mapped[fuzzy_selection.value], config.bufnr)
  end

  opts = opts or require("telescope.themes").get_cursor()
  require("telescope.pickers").new(opts, {

    -- TODO: dynamic title based on state
    prompt_title = "create user module",

    finder = require("telescope.finders").new_table({
      results = config.entries,
      entry_maker = display_module_packages,
    }),
    sorter = require("telescope.config").values.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
      map("i", "<CR>", pass_entry_to_callback)
      map("n", "<CR>", pass_entry_to_callback)
	    goback(prompt_bufnr, map)
      return true
    end,
  }):find()
end

P.doom_module_cmds_picker = function() end

P.doom_module_autocmds_picker = function() end

-- i also need to merge all tables that I can find in a module into
-- this shouldn't be too difficult.
-- one big table so that i can pass the data to `doom_binds_table_picker`
--
-- 1. get all binds from the gloval doom table
-- 2. make picker, attach module path to each mapping.
-- 3. load selected mapping->path into buf
-- 4. find the selected mapping
-- 5. go to position.
-- would it be possible to make a picker where you put pretty much everything into one big
-- flat table that we can make a good entry_maker on so that you can fileter every single
-- config setting in a single picker? that would be pretty cool.

P.doom_picker_all_packages = function(c)
	-- table settings picker to navigate the specs.
	-- connect module data to each module somehow.
	-- actually this could be attached to all amodules during
	-- load time.
end
P.doom_picker_everything = function(c) end
P.doom_picker_all_binds = function(c) end
P.doom_picker_all_autocmds = function(c) end

P.doom_binds_table_picker = function()
  us.ensure_doom_ui_state()
  doom_ui_state.current.title = "BINDS TABLE"
  doom_ui_state.current.picker = P.doom_binds_table_picker

  -- if doom_ui_state.prev ~= nil then
  --   print(vim.inspect(doom_ui_state.prev.selection))
  -- end

  -- TODO: attach the nest data to the module.
  --
  -- 1. find which module we are working on.
  -- 2. extend the module with the nest binds data.

  if doom_ui_state.current.buf_ref == nil then
    local p
    if doom_ui_state.prev.selection.type == "module" then
	    p = doom_ui_state.prev.selection.path .. "/init.lua"
    end
    doom_ui_state.current.buf_ref = utils.get_buf_handle(p)
  end

  if doom_ui_state.prev.selection.type == nil
    or doom_ui_state.prev.selection.type ~= "binds_table"
    or doom_ui_state.prev.selection.type ~= "binds_branch"
    or doom_ui_state.prev.selection.type ~= "binds_leaf"
  then
    local t_nest_table_nodes = ts.ts_get_doom_captures(doom_ui_state.current.buf_ref, "doom_module.binds_table")
    local nestdata =  tst.parse_nest_tables_meta_data(doom_ui_state.current.buf_ref, t_nest_table_nodes[1])
    doom_ui_state.current.results_prepared = nestdata[1]
  else
    doom_ui_state.current.results_prepared = doom_ui_state.prev.selection
  end

  local opts = opts or require("telescope.themes").get_dropdown()

  pickers.new(opts, {
    title = doom_ui_state.current.title,
    finder = finders.new_table({
      results = doom_ui_state.current.results_prepared,
      entry_maker = em.display_binds_table,
    }),
    sorter = opts.sorter or conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)

      actions_set.select:replace(function()
        local fuzzy = selection(prompt_bufnr)
        actions.close(prompt_bufnr)

	      doom_ui_state.current.selection = fuzzy.value

	      if fuzzy.value.type == "binds_branch" then
	        us.next(P.doom_binds_branch_picker)
	      elseif fuzzy.value.type == "binds_leaf" then
	        us.next(P.doom_binds_leaf_picker)
	      else
	      end

      end)

	    goback(prompt_bufnr, map)

      return true
    end,
 --    previewer = previewers.new_buffer_previewer({
	--   define_preview = function() return vim.inspect(c.data) end,
	-- })
  }):find()
end

P.doom_binds_leaf_picker = function(c)
  us.ensure_doom_ui_state()
  doom_ui_state.current.title = "BINDS LEAF"
  doom_ui_state.current.picker = P.doom_binds_leaf_picker
  if doom_ui_state.prev.selection.type ~= "binds_leaf" then
    return
  end

  local prep_results = {}
  for k, v in pairs(doom_ui_state.prev.selection) do
    if vim.tbl_contains(BIND_COMPONENTS, k) then
  	table.insert(prep_results,{
  	  key = k,
  	  value = v
  	})
    end
  end

  doom_ui_state.current.results_prepared = prep_results

  local opts = opts or require("telescope.themes").get_dropdown()

  pickers.new(opts, {
    title = doom_ui_state.current.title,
    finder = finders.new_table({
      results = doom_ui_state.current.results_prepared,
      entry_maker = em.display_binds_leaf, -- child of results
    }),
    sorter = opts.sorter or conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
        actions_set.select:replace(function()
          local fuzzy = selection(prompt_bufnr)
          actions.close(prompt_bufnr)
	        local sr,sc,er,ec = fuzzy.value.value:range()
	        -- doom_ui_state.current.selection = ??
	        vim.api.nvim_win_set_buf(0, doom_ui_state.current.buf_ref)
	        vim.fn.cursor(er+1,ec)
        end)
        goback(prompt_bufnr, map)
        return true
      end,
 --    previewer = previewers.new_buffer_previewer({
	--   define_preview = function() return vim.inspect(c.data) end,
	-- })
  }):find()
end

P.doom_binds_branch_picker = function(c)
  us.ensure_doom_ui_state()
  doom_ui_state.current.title = "BINDS BRANCH"
  doom_ui_state.current.picker = P.doom_binds_branch_picker
  if doom_ui_state.prev.selection.type ~= "binds_branch" then
    return
  end

  local prep_results = {}
  for k, v in pairs(doom_ui_state.prev.selection) do
    if vim.tbl_contains(BIND_COMPONENTS, k) then
  	table.insert(prep_results,{
  	  key = k,
  	  value = v
  	})
    end
  end

  doom_ui_state.current.results_prepared = prep_results

  local opts = opts or require("telescope.themes").get_dropdown()

  pickers.new(opts, {
    title = doom_ui_state.current.title,
    finder = finders.new_table({
      results = doom_ui_state.current.results_prepared,
      entry_maker = em.display_binds_branch, -- child of results
    }),
    sorter = opts.sorter or conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
        actions_set.select:replace(function()
          local fuzzy = selection(prompt_bufnr)
          actions.close(prompt_bufnr)
          if type(fuzzy.value.value) == "table" then
	          doom_ui_state.current.selection = fuzzy.value.value
	  	      us.next(P.doom_binds_table_picker)
	        else
	  	      local sr,sc,er,ec = fuzzy.value.value:range()
	  	      vim.fn.cursor(er+1,ec)
	        end
        end)
        goback(prompt_bufnr, map)
        return true
      end,
 --    previewer = previewers.new_buffer_previewer({
	--   define_preview = function() return "-----" end,
	-- })
  }):find()
end

P.doom_global_picker_test = function()
  -- here try passing the whole doom table to a picker and see how it would work to
  -- traverse the tree, and only make treesitter queries when you reach a leaf that
  -- you actually want to modify. this way it could be much easier to manage the
  -- doom config.
  -- it should also be possible to pass any node of the tree to the picker and expand from there.
  --
  --
end

local test = {}
test.binds = {
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

return P
