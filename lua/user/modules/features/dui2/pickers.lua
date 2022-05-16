local utils = require("doom.utils")
local fs = require("doom.utils.fs")
local system = require("doom.core.system")

-- dui
local dui_ts = require("user.modules.features.dui2.ts")
local dui_em = require("user.modules.features.dui2.make_entry")

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

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

local bind_params = {
  "prefix",
  "name",
  "rhs",
  "description",
  "mode",
  -- "options",
}


--
-- PICKER HELPERS
--
local function ensure_doom_ui_state()
  if doom_ui_state ~= nil then return end

  -- 1. get doom modules extended
  -- 2. flatten_doom_modules()
  --

  -- inside a picker -> assign data to current
  -- in actions -> refer to history[#history] to get the selection.

  doom_ui_state = {
    -- doom_global_extended,
    all_modules_flattened = nil,
    current = {
      title = nil, -- eg. settings, modules, binds_table, binds_branch
      results_prepared = nil,
      buf_ref = nil,
      picker = nil,
      selection = nil,
      line_str = nil,
      index_selected = nil,
    },
    prev = {
      title = nil,
      buf_ref = nil,
    },
    history = {},
    ts = {
      root_settings = {
        table_root = nil,
        buf = nil,
      },
      root_modules = {

      },
      module = {
        selected = nil,
        buf = nil,
      }
    }
  }

end

local function doom_ui_state_reset()
  doom_ui_state = nil
end

local function doom_ui_state_reset_modules()
  local doom_modules_extended = utils.get_modules_flat_with_meta_data()
    doom_ui_state.all_modules_flattened = utils.get_modules_flattened(doom_modules_extended)
end

local function next(picker)
  print("func -> next()")
  doom_ui_state.prev = doom_ui_state.current

  table.insert(doom_ui_state.history, 1, doom_ui_state.current)
  local hlen = #doom_ui_state.history

  if hlen > 10 then
    table.remove(doom_ui_state.history, hlen)
  end
  if picker ~= nil then picker() end
end

-- restore state and shift history
local function prev()
  local prev = table.remove(doom_ui_state.history, 1)
  -- print(vim.inspect(prev))
  if prev ~= nil then
    doom_ui_state.current = prev
    doom_ui_state.current.picker()
  end
end

local function goback(prompt_bufnr, map)
	  return map("i", "<C-z>", function(prompt_bufnr)
	    require("telescope.actions").close(prompt_bufnr)
	    prev()
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

--
-- PICKERS
--

-- @param filter
P.doom_modules_picker = function(c)
  ensure_doom_ui_state()
  doom_ui_state_reset_modules()
  doom_ui_state.current.title = "ALL MODULES"
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
		    m_edit()
		  end
		},
	  { "^r:RENAME", "i", "<C-r>",
	    function(prompt_bufnr)
        local fuzzy, line = mappings_prepare(prompt_bufnr)
		    doom_ui_state.current.selection = fuzzy.value
		    m_rename()
	    end
	  },
	  {"^e:CREATE","i", "<C-e>",
	    function(prompt_bufnr)
        local fuzzy, line = mappings_prepare(prompt_bufnr)
		    doom_ui_state.current.selection = fuzzy.value
		    m_create()
	    end
	  },
	  {"^u:DELETE","i", "<C-u>",
	    function(prompt_bufnr)
        local fuzzy, line = mappings_prepare(prompt_bufnr)
		    doom_ui_state.current.selection = fuzzy.value
		    m_delete()
	    end
	  },
	  {"^t:TOGGLE","i", "<C-t>",
	    function(prompt_bufnr)
        local fuzzy, line = mappings_prepare(prompt_bufnr)
		    doom_ui_state.current.selection = fuzzy.value
		    m_toggle()
	    end
	  },
	  {"^b:BINDS","i", "<C-b>",
	    function(prompt_bufnr)
        local fuzzy, line = mappings_prepare(prompt_bufnr)
		    doom_ui_state.current.selection = fuzzy.value
		    next(P.doom_binds_table_picker)
	    end
	  },
	}

  local function create_maps()
  end

  local function ts_table_picker_prepare(t)
  end

  local doom_modules_theme = require("telescope.themes").get_dropdown()

  -- print(vim.inspect(doom_ui_state.all_modules_flattened))

  require("telescope.pickers").new(doom_modules_theme, {
    prompt_title = doom_ui_state.current.title,
    finder = require("telescope.finders").new_table({
      results = doom_ui_state.all_modules_flattened,
      entry_maker = dui_em.display_all_modules
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
  ensure_doom_ui_state()
  doom_ui_state.current.title = "MAIN MENU"
  doom_ui_state.current.picker = P.doom_main_menu_picker
  local function mappings_prepare(prompt_bufnr)
	  local fuzzy, line = picker_get_state(prompt_bufnr)
	  require("telescope.actions").close(prompt_bufnr)
	  return fuzzy, line
  end

  local doom_menu_items = {
		{ "open config", function() vim.cmd(("e %s"):format(require("doom.core.config").source)) end },
  		{ "edit settings",function() next(P.doom_settings_picker) end },
  		{ "browse modules",  function() next(P.doom_modules_picker) end },
  		{ "binds    (todo..)",function() end },
  		{ "autocmds (todo..)", function() end },
  		{ "cmds     (todo..)", function() end },
  		{ "packages (todo..)", function() end },
  		{ "jobs 	  (todo..)",function() end },
  }

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

-- expects there to be a `settings.lua` file in
-- doom root dir that returns only the settings table of
-- the doom global table.
--
-- rename this to a generic `table_picker`,
-- 	so that any table can be recursively pickyfied.
P.doom_settings_picker = function()
  ensure_doom_ui_state()
  -- @param table_constructor
  local function ts_table_picker_prepare(t)
    local prep = {}
    for n in t:iter_children() do
      if n:named() and n:type(1) ~= "comment" then
		    table.insert(prep, n)
	    end
    end
    return prep
  end

  doom_ui_state.current.title = "USER SETTINGS" -- make into const

  if doom_ui_state.prev.buf_ref == nil or doom_ui_state.prev.title ~= "USER SETTINGS" then
    doom_ui_state.current.buf_ref = utils.get_buf_handle(utils.find_config("settings.lua"))
	  doom_ui_state.current.results_prepared = ts_table_picker_prepare(dui_ts.ts_get_doom_captures(
	    doom_ui_state.current.buf_ref, "doom_root.settings_table")[1]
	  )
  else
    doom_ui_state.current.buf_ref = doom_ui_state.prev.buf_ref
	  doom_ui_state.current.results_prepared = ts_table_picker_prepare(doom_ui_state.prev.selection)
  end

  opts = require("telescope.themes").get_dropdown()

  require("telescope.pickers").new(opts, {
    prompt_title = doom_ui_state.current.title,
    finder = require("telescope.finders").new_table({
      results = doom_ui_state.current.results_prepared,
      entry_maker = dui_em.display_doom_settings
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
          next(P.doom_settings_picker)
	      else
	   	      local sr,sc,er,ec = field_key:range()
	  	      vim.api.nvim_win_set_buf(0, doom_ui_state.current.buf_ref)
	  	      vim.fn.cursor(er+1,ec)
	      end
      end)
      goback(prompt_bufnr, map)

	    -- map("i", "<C-z>", function(prompt_bufnr)
	    --   require("telescope.actions").close(prompt_bufnr)
	    --   prev()
	    -- end)
      return true
    end,
  }):find()

end

-- TODO: make sure that we have a query that returns the
-- root pattern so that I can parse the tree.

--
-- PICKER -> MODULE SETTINGS
--

-- use same kind of table picker. this is a good opportunity
-- to refactor the table settings picker
P.doom_module_settings_picker = function(c)
 --  if c == nil then c = {} end
 --  if c.settings_table == nil then
	-- c["settings_table"] = {}
	--
	-- c["picker_depth"] = 1
 --        c["buf_ref"] = utils.get_buf_handle(utils.find_config("settings.lua"))
	-- local ts_settings_table = dui_ts.ts_get_doom_captures(c.buf_ref, "doom_root.settings_table")
	-- local child = ts_settings_table[1]:named_child(0)
	-- local gc2 = child:named_child(1)
	-- -- filter out comments.
 -- 	-- pass the table to the picker.
 --        for n in gc2:iter_children() do
 --          if n:named() then
	--     local the_node = n
	--     local the_type = n:type(1)
	--     if the_type ~= "comment" then
	-- 	table.insert(c.settings_table, n)
 --            end
	--   end
 --        end
 --  end
end

-- make query

--
-- PICKER -> MODULE PACKAGES (specs and config/setups)
--

P.doom_module_packages_picker = function(config)
  local function pass_entry_to_callback(prompt_buf)
    local state = require("telescope.actions.state")
    local fuzzy_selection = state.get_selected_entry(prompt_bufnr)
    require("telescope.actions").close(prompt_buf)
    config.callback(config.entries_mapped[fuzzy_selection.value], config.bufnr)
  end

  opts = opts or require("telescope.themes").get_cursor()
  require("telescope.pickers").new(opts, {
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

--
-- PICKER -> MODULE CMDS
--

P.doom_module_cmds_picker = function(c)
 --  if c == nil then c = {} end
 --  if c.settings_table == nil then
	-- c["settings_table"] = {}
	--
	-- c["picker_depth"] = 1
 --        c["buf_ref"] = utils.get_buf_handle(utils.find_config("settings.lua"))
	-- local ts_settings_table = dui_ts.ts_get_doom_captures(c.buf_ref, "doom_root.settings_table")
	-- local child = ts_settings_table[1]:named_child(0)
	-- local gc2 = child:named_child(1)
	-- -- filter out comments.
 -- 	-- pass the table to the picker.
 --        for n in gc2:iter_children() do
 --          if n:named() then
	--     local the_node = n
	--     local the_type = n:type(1)
	--     if the_type ~= "comment" then
	-- 	table.insert(c.settings_table, n)
 --            end
	--   end
 --        end
 --  end
end

--
-- PICKER -> MODULE AUTOCMDS
--

P.doom_module_autocmds_picker = function(c)
 --  if c == nil then c = {} end
 --  if c.settings_table == nil then
	-- c["settings_table"] = {}
	--
	-- c["picker_depth"] = 1
 --        c["buf_ref"] = utils.get_buf_handle(utils.find_config("settings.lua"))
	-- local ts_settings_table = dui_ts.ts_get_doom_captures(c.buf_ref, "doom_root.settings_table")
	-- local child = ts_settings_table[1]:named_child(0)
	-- local gc2 = child:named_child(1)
	-- -- filter out comments.
 -- 	-- pass the table to the picker.
 --        for n in gc2:iter_children() do
 --          if n:named() then
	--     local the_node = n
	--     local the_type = n:type(1)
	--     if the_type ~= "comment" then
	-- 	table.insert(c.settings_table, n)
 --            end
	--   end
 --        end
 --  end
end

--
-- PICKER -> ALL MAPPINGS ACROSS ALL MODULES
--

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
-- ...
-- ...

--
-- PICKER -> MAPPINGS BASE TABLE
--

-- expects c.data to be array of (branch|leaf) mapping nest objects
P.doom_binds_table_picker = function(c)


  -- first picker in sequence
  if c == nil then
    c = {
      buf_ref = nil,
      history = {},
      opts = {}
    }
  else
    -- print("binds table prev config ------")
    -- print(vim.inspect(c))
    -- print("end --------------------------")
  end



  if c.opts ~= nil then
    c.opts["title"] = "Doom Binds Table"
  end

  if c.buf_ref == nil then
    local p
    if c.selected_module ~= nil then
	p = c.selected_module.path .. "/init.lua"
    end
    c.buf_ref = utils.get_buf_handle(p)
  end

    -- print(vim.inspect(c))

  if c.data == nil then
    local t_nest_table_nodes = dui_ts.ts_get_doom_captures(c.buf_ref, "doom_module.binds_table")
    local nestdata =  P.parse_nest_tables_meta_data(c.buf_ref, t_nest_table_nodes[1])

    -- print("num nest: ", #t_nest_table_nodes, c.selected_module.path)
    c["data"] = nestdata[1]
  end

  opts = c.opts or {} -- if the user didn't specify options
  local doom_binds_table_theme = require("telescope.themes").get_dropdown()

  local function goback(prompt_bufnr, map)
	    return map("i", "<C-z>", function(prompt_bufnr)
	      require("telescope.actions").close(prompt_bufnr)
	      prev()
	    end)
  end

  pickers.new(doom_binds_table_theme, {
    title = c.opts.title,
    finder = finders.new_table({
      results = c.data,
      entry_maker = display_binds_table,
    }),
    sorter = opts.sorter or conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)

      goback(prompt_bufnr, map)
	    -- map("i", "<C-z>", function(prompt_bufnr)
	    --   require("telescope.actions").close(prompt_bufnr)
	    --   prev()
	    -- end)

      -- REFACTOR: into ts_binds_table_mappings()
        actions_set.select:replace(function()
          local fuzzy = selection(prompt_bufnr)
          actions.close(prompt_bufnr)

	        local new_c = c
	        new_c.data = fuzzy.value

	      -- how can c be leaf data here?
	        -- print("######",vim.inspect(c))

	        table.insert(new_c.history, {
		      prev_picker = P.doom_binds_table_picker,

	        })

	        -- print(vim.inspect(fuzzy.value))
	        if c.data.doom_category == "binds_branch" then
	          P.doom_binds_branch_picker(new_c)
	        elseif c.data.doom_category == "binds_leaf" then
	          P.doom_binds_leaf_picker(new_c)
	        else
	          -- print("stop")
	        end
        end)

	      goback(prompt_bufnr, map)

        return true
      end,
    previewer = previewers.new_buffer_previewer({
	  define_preview = function() return vim.inspect(c.data) end,
	})
  }):find()
end

--
-- PICKER -> MAPPINGS LEAF ------
--

P.doom_binds_leaf_picker = function(c)


  if c == nil then
  end
  local pc = c.history[#c.history].prev_config
  print("xxxx")
  print(vim.inspect(pc))

  opts = c.opts or {} -- if the user didn't specify options


  local prep_results = {}
  for k, v in pairs(c.data) do
    if vim.tbl_contains(bind_params, k) then
  	table.insert(prep_results,{
  	  key = k,
  	  value = v
  	})
    end
  end


  pickers.new(opts, {
    title = opts.title,
    finder = finders.new_table({
      results = prep_results,
      entry_maker = display_binds_leaf, -- child of results
    }),
    sorter = opts.sorter or conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
        actions_set.select:replace(function()
          local fuzzy = selection(prompt_bufnr)
          actions.close(prompt_bufnr)
	        -- print("-->>",vim.inspect(fuzzy.value))
	        local sr,sc,er,ec = fuzzy.value.value:range()

	        local new_c = c

	        table.insert(new_c.history, {
		      prev_picker = P.doom_binds_leaf_picker,
		      prev_config = c
	        })
	        -- pass data including path and ts node
 	        -- so that we can open the file and set the cursor.
	        -- move_cursor_position()

	        -- NOTE: SETS CORRESPONDING BUF AND CURSOR
	        vim.api.nvim_win_set_buf(0, c.buf_ref)
	        vim.fn.cursor(er+1,ec)

        end)

         -- go back
         map("i", "<C-z>", function(prompt_bufnr)
           require("telescope.actions").close(prompt_bufnr)
	         if #c.history > 0 then
	           local pp = c.history[#c.history].prev_picker
	           local pc = c.history[#c.history].prev_config
		          print("???")
		          print(vim.inspect(pc))
	           pp(pc)
	         end
         end)

        return true
      end,
    previewer = previewers.new_buffer_previewer({
	  define_preview = function() return vim.inspect(c.data) end,
	})
  }):find()
end

--
-- PICKER -> MAPPINGS BRANCH
--

P.doom_binds_branch_picker = function(c)

  if c == nil then
  end

  local prep_results = {}
  for k, v in pairs(c.data) do
    if vim.tbl_contains(bind_params, k) then
  	table.insert(prep_results,{
  	  key = k,
  	  value = v
  	})
    end
  end

  opts = c.opts or {} -- if the user didn't specify options
  pickers.new(opts, {
    title = opts.title,
    finder = finders.new_table({
      results = prep_results,
      entry_maker = display_binds_branch, -- child of results
    }),
    sorter = opts.sorter or conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
        actions_set.select:replace(function()
          local fuzzy = selection(prompt_bufnr)
          actions.close(prompt_bufnr)
          if type(fuzzy.value.value) == "table" then
	  	      -- print(vim.inspect(fuzzy.value.value))
 		      local new_c = c
	  	      new_c.data = fuzzy.value.value[1]
		        table.insert(new_c.history, {
			      prev_picker = P.doom_binds_branch_picker,
			      prev_config = c
		        })
	  	      P.doom_binds_table_picker(new_c)
	        else
	  	      local sr,sc,er,ec = fuzzy.value.value:range()
	  	      vim.fn.cursor(er+1,ec)
	        end
              end)

               -- go back
               map("i", "<C-z>", function(prompt_bufnr)
                 require("telescope.actions").close(prompt_bufnr)
	         if #c.history > 0 then
	           local  pp = c.history[#c.history].prev_picker
	           local  pc = c.history[#c.history].prev_config
	           -- table.remove(c.history, #c.history) -- not necessary i think
	           pp(pc)
	         end
         end)

        return true
      end,
    previewer = previewers.new_buffer_previewer({
	  define_preview = function() return "-----" end,
	})
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

return P