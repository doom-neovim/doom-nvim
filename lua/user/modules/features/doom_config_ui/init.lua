-- DOOM
local utils = require("doom.utils")
local fs = require("doom.utils.fs")
local system = require("doom.core.system")

-- USER
-- local user_ts_utils = require("user.utils.ts")
-- local user_utils_ui = require("user.utils.ui")
-- local user_utils_modules = require("user.utils.modules")
-- local binds_parser = require("user.utils.parse_mod_binds")
local user_utils_path = require("user.utils.path")


-- TS
local tsq = require("vim.treesitter.query")
local parsers = require "nvim-treesitter.parsers"

-- TELE
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local entry_display = require("telescope.pickers.entry_display")
local actions_set = require("telescope.actions.set")
local state = require("telescope.actions.state")
local actions = require("telescope.actions")
local previewers = require("telescope.previewers")


local conf_ui = {}


conf_ui.settings = {
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

-- TODO:
--
-- 	- copy in module manager, and packages picker into this one.
--
-- 	1. spawn_picker_on_doom_data_object()
-- 	2. call the correct picker based on c.data.category.
-- 	3. so that the pickers only prepare the picking of the current data
--
--
--
-- HELP:
--
--  	- module actions
--  		I someone to give me feedback so that we write to files correctly.
--  		async/sync/libuv/..??
--  		I am just unsure if I am writing and saving the files
--  		correctly. I believe most things in this module can
--  		be done in more correctly or smoothly. this is just
--  		a proof of concept atm.
--
--  	- i need feedback on everything.
--  		am I inventing any wheels??
--  		i don't understand how to use plenary sometimes so
--  		it would be nice to convert as much as possible to use
--  		plenry plugin.
--
--  	- I need help with picker esthetics and logic.
--  		need to make good entry_makers that give you good
--  		contextual awareness.
--
--  	- connect binds maker with luasnip so that you can
--  		create new mapping and enter luasnippet, and
--  		cycle through good choice nodes.
--
--  	- create nui popup inputs so that you don't have to enter a file
--  		that you want to change. just open a cool popup with syntax
--  		and error sandboxing and stuff? to make the config more
--  		error proof??
--
--  	- move stuff into util functions
-- 		i put everything in the same module so that we can discuss
-- 		what could and should be refactored into utils, core or
-- 		whatever.
--
-- 	- help with creating more commands for creating and
-- 		adding new module compenents
-- 		eg. what would be the fastest way of going from
-- 		thought to adding a new leader binding for module X..
--
-- 	- should we use something other than treesitter?
-- 		i started using treesitter because I wanted to learn
-- 		i don't know if treesitter is the best for this usecase.
--
--
-- 	- go back / history
-- 		i am not getting the go back (<C-z>) command
-- 		to work for navigating back in the picker history.
--
-- 	- improved legend
-- 		so that you are always aware of the possible mappings attached
-- 		to each picker.
-- 		IDEA: it would be cool if we could create a fourth window
-- 		that can be positionned under the preview window where we
-- 		show a tight legend of all possible binds.
-- 		so that you have essentially 4 floating windows per picker
-- 		input | entries | preview | legend
-- 		this could even be made into a PR for telescope later if it
-- 		becomes good so that one can display mappings always.

--
-- CONSTS
--

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

conf_ui.get_query_file = function(lang, query_name)
  return fs.read_file(string.format("%s/queries/%s/%s.scm", system.doom_root, lang, query_name))
end


conf_ui.run_query_on_buf = function(lang, query_name, buf)
  print("buf: ", buf)
  local query_str = conf_ui.get_query_file(lang, query_name)
  local language_tree = vim.treesitter.get_parser(buf, lang)
  local syntax_tree = language_tree:parse()
  local root = syntax_tree[1]:root()
  local q = vim.treesitter.parse_query(lang, query_str)
  return buf, root, q
end


-- if set handle to path or current buffer.
local function get_buf_handle(path)
  local buf
  if path ~= nil then
    -- print("LOAD PATH INTO BUF:", path)
    buf = vim.uri_to_bufnr(vim.uri_from_fname(path))
  else
    buf = vim.api.nvim_get_current_buf()
  end
  return buf
end

local function check_if_module_name_exists(c, new_name)
  print(vim.inspect(c.selected_module))
  local already_exists = false
  for _, v in pairs(c.all_modules_data) do
    if v.section == c.selected_module.section and v.name == new_name then
	print("module already exists!!!")
      already_exists = true
    end
  end
  return already_exists
end


-- RENAME: ts_get_module_components_by_name(buf, mc_name)
--
-- so that you can pass either `binds` or `packages`, or whatever here.
--
--
-- 	definition.binds_table -> rename: module.binds_table
--
-- 	root.settings_table
local function module_get_component_by_name(buf, mc_name)
  local t_matched_captures = {}
  local _, root, qp = conf_ui.run_query_on_buf("lua", "doom_conf_ui", buf)
  for id, node, metadata in qp:iter_captures(root, buf, root:start(), root:end_()) do
    local name = qp.captures[id] -- name of the capture in the query
	if name == mc_name then
      table.insert(t_matched_captures, node)
    -- local type = node:type() -- type of the captured node
    -- local row1, col1, row2, col2 = node:range() -- range of the capture
    -- local nt = tsq.get_node_text(node, buf)
    -- print(name, type, nt, row1+1, col1+1)
	end
   end
   return t_matched_captures
end

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

-- TODO: redo this with plenary.path
conf_ui.path_get_tail = function(p)
  local tail = vim.tbl_map(function(s)
    return s:match("/([_%w]-)$") -- capture only dirname
  end, p)
  return tail
end

conf_ui.single_path_tail = function(s)
  -- local tail = vim.tbl_map(function(s)
    return s:match("/([_%w]-)$") -- capture only dirname
  -- end, p)
  -- return tail
end


conf_ui.get_dir_files_or_both_in_path_location = function(path)
  local scan_dir = require("plenary.scandir").scan_dir
  local scan_dir_opts = { search_pattern = ".", depth = 1, only_dirs = true }
  local t_current_module_paths = scan_dir(path, scan_dir_opts)
  return t_current_module_paths
end


conf_ui.get_formated_path = function(path_components)
  local concat = table.concat(path_components, system.sep)
  return string.format("%s%s%s", system.doom_root, system.sep, concat)
end


conf_ui.get_modules_path = function(section_name)
  local pc = {}
  if section_name == "core" then
    pc = { "lua", "doom", "modules", "core" }
  elseif section_name == "features" then
    pc = { "lua", "doom", "modules", "features" }
  elseif section_name == "langs" then
    pc = { "lua", "doom", "modules", "langs" }
  elseif section_name == "user" then
    pc = { "lua", "user", "modules" }
  end
  local fp = conf_ui.get_formated_path(pc)
  -- print(fp)
  return fp
end


conf_ui.get_module_meta_data = function()
  local t = {}

  local sections = { "core", "features", "langs", "user" }

  for _, sec in pairs(sections) do
    local mp = conf_ui.get_modules_path(sec)
    local t_paths = conf_ui.get_dir_files_or_both_in_path_location(mp)
    vim.inspect(t_paths)
    for _, p in pairs(t_paths) do
      local tail = conf_ui.single_path_tail(p)
      table.insert(t, {
        path = p,
        name = tail,
        section = sec,
      })
    end
  end

  return t
end



-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

--
-- NUI
--

local function nui_input(title, callback)
  local Input = require("nui.input")
  local event = require("nui.utils.autocmd").event
  local input = Input(conf_ui.settings.popup, {
    prompt = title .. "> ",
    default_value = "",
    on_close = function()
      print("Input closed!")
    end,
    on_submit = function(value)
      callback(value)
    end,
    on_change = function(value)
      print("Value changed: ", value)
    end,
  })
  input:mount()
  input:on(event.BufLeave, function()
    input:unmount()
  end)
end

local function menu_set_title(title)
  local opts = conf_ui.settings.menu
  opts.border.text.top = title
  return opts
end

local function nui_menu(title, alternatives, callback)
  local Menu = require("nui.menu")
  local event = require("nui.utils.autocmd").event

  local lines = {
    Menu.separator("Menu Group", {
      char = "-",
      text_align = "right",
    }),
  }

  for i, v in ipairs(alternatives) do
    table.insert(lines, Menu.item(v))
  end

  local menu = Menu(menu_set_title(title), {
    lines = lines,
    max_width = 20,
    keymap = {
      focus_next = { "j", "<Down>", "<Tab>" },
      focus_prev = { "k", "<Up>", "<S-Tab>" },
      close = { "<Esc>", "<C-c>" },
      submit = { "<CR>", "<Space>" },
    },
    on_close = function()
      print("CLOSED")
    end,
    on_submit = function(item)
      callback(item)
    end,
  })

  -- mount the component
  menu:mount()

  -- close menu when cursor leaves buffer
  menu:on(event.BufLeave, menu.menu_props.on_close, { once = true })
end


-----------------------------------------------------------------------------
-----------------------------------------------------------------------------



--
-- MODULE ACTIONS
--


local function m_edit(c)
  if c.selected_module ~= nil then
    vim.cmd(string.format(":e %s%s%s", c.selected_module.path, system.sep, "init.lua"))
  end
end

local function m_rename(c)
  nui_input("NEW NAME", function(value)
    if not check_if_module_name_exists(c, value) then
      print("old name: ", c.selected_module.name, ", new name:", value)
--       local new_name = value
--
--       local buf, _ = transform_root_mod_file(m, function(buf, node, capt, node_text)
--         local sr, sc, er, ec = node:range()
--         if capt == "modules.enabled" then
--           local offset = 1
--           local exact_match = string.match(node_text, m.name)
--           if exact_match then
--             vim.api.nvim_buf_set_text(
--               buf,
--               sr,
--               sc + offset,
--               sr,
--               sc + offset + string.len(m.name),
--               { value }
--             )
--           end
--         elseif capt == "modules.disabled" then
--           local offset = 4
--           local exact_match = string.match(node_text, m.name)
--           if exact_match then
--             vim.api.nvim_buf_set_text(
--               buf,
--               sr,
--               sc + offset,
--               sr,
--               sc + offset + string.len(m.name),
--               { value }
--             )
--           end
--         end
--       end)
--
--       write_to_root_modules_file(buf)
--       shell_mod_rename_dir(m.section, m.path, new_name)
    end
  end)
end

local function m_create(c)
  local new_name
  local for_section

  nui_menu("CONFIRM CREATE", conf_ui.settings.confirm_alternatives, function(value)
    if value.text == "yes" then
      new_name = c.new_module_name
      nui_menu("FOR SECTION:", conf_ui.settings.section_alternatives, function(value)
        for_section = value.text
        print("create mod >> new name:", for_section .. " > " .. new_name)
--         if not check_if_module_name_exists(c, { section = nil }, value) then
--           local buf, smll = transform_root_mod_file({ section = value.text })
--           -- print("smll: ", smll)
--           new_name = vim.trim(new_name, " ")
--           vim.api.nvim_buf_set_lines(buf, smll, smll, true, { '"' .. new_name .. '",' })
--           write_to_root_modules_file(buf)
--           shell_mod_new(for_section, new_name)
        -- end
      end)
    end
  end)
end

-- TODO: what happens if you try to remove a module that has been disabled ?? account for disabled in modules.lua
--
local function m_delete(c)
  nui_menu("CONFIRM DELETE", conf_ui.settings.confirm_alternatives, function(value)
    if value.text == "yes" then
	print("delete module: ", c.selected_module.section .. " > " .. c.selected_module.name)
--       local buf, _ = transform_root_mod_file(m, function(buf, node, capt, node_text)
--         local sr, sc, er, ec = node:range()
--         if capt == "modules.enabled" then
--           -- local offset = 1
--           local exact_match = string.match(node_text, m.name)
--           if exact_match then
--             vim.api.nvim_buf_set_text(buf, sr, sc, er, ec + 1, { "" })
--           end
--         elseif capt == "modules.disabled" then
--           -- local offset = 4
--           local exact_match = string.match(node_text, m.name)
--           if exact_match then
--             vim.api.nvim_buf_set_text(buf, sr, sc, er, ec + 1, { "" })
--           end
--         end
--       end)
--
--       write_to_root_modules_file(buf)
--       shell_mod_remove_dir(m.path) -- shell: rm m.path
    end
  end)
end

local function m_toggle(c)
  print("toggle: ", c.selected_module.name)
--   local buf, _ = transform_root_mod_file(m, function(buf, node, capt, node_text)
--     local sr, sc, er, ec = node:range()
--     if string.match(node_text, m.name) then
--       if capt == "modules.enabled" then
--         vim.api.nvim_buf_set_text(buf, sr, sc, er, ec, { "-- " .. node_text })
--       elseif capt == "modules.disabled" then
--         vim.api.nvim_buf_set_text(buf, sr, sc, er, ec, { node_text:sub(4) })
--       end
--     end
--   end)
--   write_to_root_modules_file(buf)
end

local function m_move(buf, config)
--   -- move module into into (features/langs)
--   -- 1. nui menu select ( other sections than self)
--   -- 2. move module dir
--   -- 3. transform `modules.lua`
end

local function m_merge(buf, config)
--   -- 1. new prompt for B
--   -- 2. select which module to pull into A
--   -- 3. do...
end

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

--
-- MODULE COMPONENT PARSERS
--

-- this is a stupid function name....
--
-- this recursively walks through nest tables and returns necessary info and ts nodes.
conf_ui.parse_nest_tables_meta_data = function(buf, node, accumulated,level)
  if accumulated == nil then
    accumulated = {
      level = 0,
    }
  else
    accumulated.level = level + 1
  end
  accumulated["container"] = node
  -- print(level, "--------------------------------------------")
  if node:type() == nil or node:type() ~= "table_constructor" then
    return false
  end
  local cnt = 1 -- child counter
  local special_cnt = 0
  local second_table
  local second_table_idx
  local second_table_cnt = 0
  local rhs
  local name_found
  local mode_found
  local opts_found
  local desc_found
  for n in node:iter_children() do
    if n:named() then
    local the_node = n:named_child(0) -- table constructor
    local the_type = the_node:type(0)
    if cnt == 1 then
      if the_type == "table_constructor" then
        -- accumulated["children"] = {}
        local child_table = {
		doom_category = "binds_table"
	}
        for child in node:iter_children() do
          if child:named() then
            if child:type() == "field" then
              table.insert(child_table,
                conf_ui.parse_nest_tables_meta_data(buf, child:named_child(0), {}, accumulated.level)
                )
            end
          end
        end
        table.insert(accumulated, child_table)
        return accumulated
      else
        accumulated["prefix"] = the_node
	accumulated["doom_category"] = "binds_leaf"
        local nt = tsq.get_node_text(the_node, buf)
	accumulated["prefix_text"] = nt
        special_cnt = special_cnt + 1
      end
    end
    if cnt ~= 1 then
      if the_type == "table_constructor" then
        second_table = the_node
        second_table_idx = special_cnt
        second_table_cnt = second_table_cnt + 1
      end
    end
    if cnt == 2 and (the_type == "string" or the_type == "function_definition" or the_type == "dot_index_expression")then
        rhs = the_node
    end
    local c2 = n:named_child(0)
    if c2:type() == "identifier" then
      local nt = tsq.get_node_text(c2, buf)
      if nt == "name" then
        accumulated["name"] = c2
        name_found = true
        special_cnt = special_cnt + 1
      elseif nt == "mode" then
        accumulated["mode"] = c2
        mode_found = true
        special_cnt = special_cnt + 1
      elseif nt == "description" then
        accumulated["description"] = c2
        desc_found = true
        special_cnt = special_cnt + 1
      elseif nt == "options" then
        accumulated["options"] = c2
        opts_found = true
        special_cnt = special_cnt + 1
      else
        rhs = the_node
      end
    end
    cnt = cnt + 1
    end
  end
  if accumulated.name == nil and special_cnt >= 3 then
    accumulated["name"] = node:named_child(2)
  end
  if accumulated.description == nil and special_cnt >= 4 then
    accumulated["description"] = node:named_child(3)
  end
  if accumulated.rhs == nil and second_table then
    rhs = second_table
    accumulated["doom_category"] = "binds_branch"
  end
  accumulated["rhs"] = rhs
  if accumulated.rhs:type() == "table_constructor" then
    accumulated["rhs"] = conf_ui.parse_nest_tables_meta_data(buf, accumulated.rhs, {}, level)
  end
  return accumulated
end

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

--
-- PICKER HELPERS
--

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

-- if data is a eg. a leaf table we need to wrap
-- all fields in a table because telescope only
-- uses subtables for results. no actual key/val pairs!
local function tableify_data_for_results()
end


-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

-- todo:
--
-- 	in each picker write c to c.picker_history
-- 	so that we can always go back in the picker history
-- 	if # == 0 then close

--
-- PICKER -> DOOM MODULES
--

conf_ui.doom_modules = function(c)


  local function mappings_prepare(prompt_bufnr, c)
	local fuzzy, line = picker_get_state(prompt_bufnr)
	require("telescope.actions").close(prompt_bufnr)
	table.insert(c.history, c)
	c.data = nil -- why??
	return c, fuzzy, line
  end
  local t_mappings = {
	{ "<cr>:EDIT", "i", "<CR>", function(prompt_bufnr)
        	local c, fuzzy, line = mappings_prepare(prompt_bufnr, c)
		c["selected_module"] = fuzzy.value
		m_edit(c) end},
	{"^r:RENAME", "i", "<C-r>", function(prompt_bufnr)
		local c, fuzzy, line = picker_get_state(prompt_bufnr,c)
		c["selected_module"] = fuzzy.value
		m_rename(c)
	      end},
	{"^e:CREATE","i", "<C-e>", function(prompt_bufnr)
		local c, fuzzy, line = picker_get_state(prompt_bufnr,c)
		c["new_module_name"] = line
		m_create(c)
	      end},
	{"^u:DELETE","i", "<C-u>", function(prompt_bufnr)
		local c, fuzzy, line = picker_get_state(prompt_bufnr,c)
		c["selected_module"] = fuzzy.value
		m_delete(c)
	      end},
	{"^t:TOGGLE","i", "<C-t>", function(prompt_bufnr)
		local c, fuzzy, line = picker_get_state(prompt_bufnr,c)
		c["selected_module"] = fuzzy.value
		m_toggle(c)
	      end},
	{"^z:GOBACK","i", "<C-z>", function(prompt_bufnr)
		local c, fuzzy, line = picker_get_state(prompt_bufnr,c)
	      end},
	{"^b:BINDS","i", "<C-b>", function(prompt_bufnr)
		local c, fuzzy, line = mappings_prepare(prompt_bufnr,c)
		c["selected_module"] = fuzzy.value
		-- print("xxxxx")
		-- print(vim.inspect(c.selected_module))
		conf_ui.doom_binds_table(c)
	      end}
	}

  -- local tlegend = " [<cr>:edit,<c-(e:create,r:rename,t:toggle,u:remove)]"
local tlegend = "["
      for _,m in pairs(t_mappings) do
	tlegend = tlegend .. m[1] ..","
      end
	tlegend = tlegend.. "]"


  local function create_maps()
  end

  if c == nil then
    c = {
      data = conf_ui.get_module_meta_data(),
      all_modules_data = conf_ui.get_module_meta_data(),
      buf_ref = nil,
      history = {},
      opts = {
	title = "Doom Modules"
      }
    }
  end

  -- print(vim.inspect(c.data))

  -- local opts = opts or require("telescope.themes").get_cursor()
  local doom_modules_theme = require("telescope.themes").get_dropdown()

  require("telescope.pickers").new(doom_modules_theme, {
    prompt_title = "Doom Modules Manager" .. tlegend,
    finder = require("telescope.finders").new_table({
      results = c.data,
      entry_maker = function(entry)
	  local function make_display(t)
	    return t.section .." > " .. t.name
	  end
	  return {
	    value = entry,
	    display = function(tbl) return make_display(tbl.value) end,
	    ordinal = entry.name,
	  }
	end,
    }),
    sorter = require("telescope.config").values.generic_sorter(opts),
    attach_mappings = function(_, map)
      for _,m in pairs(t_mappings) do
	map(m[2], m[3], m[4])
      end
      return true
    end,
  }):find()
end

--
-- PICKER -> DOOM MAIN MENU
--

-- TODO: make the most useful base picker where you can get an overview
-- of all available categories that you can enter and browse.
--

conf_ui.doom_picker_main_menu = function(c)
  local function mappings_prepare(prompt_bufnr)
	local fuzzy, line = picker_get_state(prompt_bufnr)
	require("telescope.actions").close(prompt_bufnr)
	return fuzzy, line
  end
  local doom_menu_title = "DOOM > MAIN MENU"
  local doom_menu_items = {
		{ "open config", function() vim.cmd(("e %s"):format(require("doom.core.config").source)) end },
  		{ "edit settings",function() conf_ui.doom_picker_root_settings() end },
  		{ "browse modules",  function() conf_ui.doom_modules() end },
  		{ "binds    (todo..)",function() end },
  		{ "autocmds (todo..)", function() end },
  		{ "cmds     (todo..)", function() end },
  		{ "packages (todo..)", function() end },
  		{ "jobs 	  (todo..)",function() end },
  }

  -- get_dropdown | get_cursor | get_ivy
  local doom_menu_theme = require("telescope.themes").get_dropdown()

 --  local t_mappings = {
	-- { "<cr>:EDIT", "i", "<CR>", function(prompt_bufnr)
 --        	local c, fuzzy, line = mappings_prepare(prompt_bufnr, c)
	-- 	c["selected_module"] = fuzzy.value
	-- 	m_edit(c) end},
	-- }

  -- TODO: connect modules browser
	--
	-- use the same mappings loop to create good
	-- stuff

  opts = opts or require("telescope.themes").get_ivy()

  require("telescope.pickers").new(doom_menu_theme, {
    prompt_title = doom_menu_title,
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
      return true
    end
  }):find()

end

--
-- PICKER -> DOOM SETTINGS
--

-- expects there to be a `settings.lua` file in
-- doom root dir that returns only the settings table of
-- the doom global table.
--
-- rename this to a generic `table_picker`,
-- 	so that any table can be recursively pickyfied.
conf_ui.doom_picker_root_settings = function(c)

  if c == nil then c = {} end
  if c.settings_table == nil then
	c["settings_table"] = {}

	c["picker_depth"] = 1
        c["buf_ref"] = get_buf_handle(utils.find_config("settings.lua"))
	local ts_settings_table = module_get_component_by_name(c.buf_ref, "doom_root.settings_table")
	local child = ts_settings_table[1]:named_child(0)
	local gc2 = child:named_child(1)
	-- filter out comments.
 	-- pass the table to the picker.
        for n in gc2:iter_children() do
          if n:named() then
	    local the_node = n
	    local the_type = n:type(1)
	    if the_type ~= "comment" then
		table.insert(c.settings_table, n)
            end
	  end
        end
  end

  if c.picker_depth and c.picker_depth > 1 then
	local passed_table = c.settings_table
	c.settings_table = {}
	-- print(vim.inspect(c))
        for n in passed_table:iter_children() do
          if n:named() then
	    local the_node = n
	    local the_type = n:type()
	    if the_type ~= "comment" then
		table.insert(c.settings_table, n)
		-- print(type)
            end
	  end
        end
  end

  opts = opts or require("telescope.themes").get_ivy()
  -- local opts = require("telescope.themes").get_dropdown()

  require("telescope.pickers").new(opts, {
    prompt_title = "create user module",
    finder = require("telescope.finders").new_table({
      results = c.settings_table,
      entry_maker = function(entry)
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
	end,
    }),
    sorter = require("telescope.config").values.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
        actions_set.select:replace(function()
          local fuzzy = selection(prompt_bufnr)
	  -- print(vim.inspect(fuzzy.value:type()))
 	  local node = fuzzy.value
          require("telescope.actions").close(prompt_bufnr)
	  local f1 = node:named_child(0)

	  local f2 = node:named_child(1)
	  local f2x = ntext(f2, c.buf_ref)
	  if f2:type() == "table_constructor" then
		  f2x = " >>> { ... }"
		  c.picker_depth = c.picker_depth + 1
		  c.settings_table = f2
		  conf_ui.doom_picker_root_settings(c)
	  else
		  print(ntext(f1, c.buf_ref) .. " -> " .. f2x)
	   	  local sr,sc,er,ec = f1:range()
	  	  vim.api.nvim_win_set_buf(0, c.buf_ref)
	  	  vim.fn.cursor(er+1,ec)
	  end
        end)
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
conf_ui.doom_picker_module_settings = function(c)
 --  if c == nil then c = {} end
 --  if c.settings_table == nil then
	-- c["settings_table"] = {}
	--
	-- c["picker_depth"] = 1
 --        c["buf_ref"] = get_buf_handle(utils.find_config("settings.lua"))
	-- local ts_settings_table = module_get_component_by_name(c.buf_ref, "doom_root.settings_table")
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

conf_ui.doom_module_packages = function(config)
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
    }),
    sorter = require("telescope.config").values.generic_sorter(opts),
    attach_mappings = function(_, map)
      map("i", "<CR>", pass_entry_to_callback)
      map("n", "<CR>", pass_entry_to_callback)
      return true
    end,
  }):find()
end

--
-- PICKER -> MODULE CMDS
--

conf_ui.doom_picker_module_cmds = function(c)
 --  if c == nil then c = {} end
 --  if c.settings_table == nil then
	-- c["settings_table"] = {}
	--
	-- c["picker_depth"] = 1
 --        c["buf_ref"] = get_buf_handle(utils.find_config("settings.lua"))
	-- local ts_settings_table = module_get_component_by_name(c.buf_ref, "doom_root.settings_table")
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

conf_ui.doom_picker_module_autocmds = function(c)
 --  if c == nil then c = {} end
 --  if c.settings_table == nil then
	-- c["settings_table"] = {}
	--
	-- c["picker_depth"] = 1
 --        c["buf_ref"] = get_buf_handle(utils.find_config("settings.lua"))
	-- local ts_settings_table = module_get_component_by_name(c.buf_ref, "doom_root.settings_table")
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
-- one big table so that i can pass the data to `doom_binds_table`
--
-- 1. get all binds from the gloval doom table
-- 2. make picker, attach module path to each mapping.
-- 3. load selected mapping->path into buf
-- 4. find the selected mapping
-- 5. go to position.
-- would it be possible to make a picker where you put pretty much everything into one big
-- flat table that we can make a good entry_maker on so that you can fileter every single
-- config setting in a single picker? that would be pretty cool.
conf_ui.doom_picker_all_packages = function(c)
	-- table settings picker to navigate the specs.
	-- connect module data to each module somehow.
	-- actually this could be attached to all amodules during
	-- load time.
end
conf_ui.doom_picker_everything = function(c) end
conf_ui.doom_picker_all_binds = function(c) end
conf_ui.doom_picker_all_autocmds = function(c) end
-- ...
-- ...

--
-- PICKER -> MAPPINGS BASE TABLE
--

-- expects c.data to be array of (branch|leaf) mapping nest objects
conf_ui.doom_binds_table = function(c)


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
    c.buf_ref = get_buf_handle(p)
  end

    -- print(vim.inspect(c))

  if c.data == nil then
    local t_nest_table_nodes = module_get_component_by_name(c.buf_ref, "doom_module.binds_table")
    local nestdata =  conf_ui.parse_nest_tables_meta_data(c.buf_ref, t_nest_table_nodes[1])

    -- print("num nest: ", #t_nest_table_nodes, c.selected_module.path)
    c["data"] = nestdata[1]
  end

  opts = c.opts or {} -- if the user didn't specify options
  local doom_binds_table_theme = require("telescope.themes").get_dropdown()

  pickers.new(doom_binds_table_theme, {
    title = c.opts.title,
    finder = finders.new_table({
      results = c.data,
      entry_maker = function(entry)
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
	end,
    }),
    sorter = opts.sorter or conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
        actions_set.select:replace(function()
          local fuzzy = selection(prompt_bufnr)
          actions.close(prompt_bufnr)

	  local new_c = c
	  new_c.data = fuzzy.value

	-- how can c be leaf data here?
	  -- print("######",vim.inspect(c))

	  table.insert(new_c.history, {
		prev_picker = conf_ui.doom_binds_table,

	  })

	  -- print(vim.inspect(fuzzy.value))
	  if c.data.doom_category == "binds_branch" then
	    conf_ui.doom_binds_branch(new_c)
	  elseif c.data.doom_category == "binds_leaf" then
	    conf_ui.doom_binds_leaf(new_c)
	  else
	    -- print("stop")
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
	  define_preview = function() return vim.inspect(c.data) end,
	})
  }):find()
end

--
-- PICKER -> MAPPINGS LEAF ------
--

conf_ui.doom_binds_leaf = function(c)


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
      entry_maker = function(entry)
	  return {
	    value = entry,
	    display = function(tbl)
	      return tbl.value.key
	    end,
	    ordinal = entry,
	  }
	end, -- child of results
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
		prev_picker = conf_ui.doom_binds_leaf,
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

conf_ui.doom_binds_branch = function(c)

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
      entry_maker = function(entry)
	  return {
	    value = entry,
	    display = function(tbl)
	      return tbl.value.key
	    end,
	    ordinal = entry,
	  }
	end, -- child of results
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
			prev_picker = conf_ui.doom_binds_branch,
			prev_config = c
		  })
	  	conf_ui.doom_binds_table(new_c)
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

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

conf_ui.cmds = {
	{ "DoomUIMain", 		function() conf_ui.doom_picker_main_menu() end, },
	{ "DoomUISettings", 		function() conf_ui.doom_picker_root_settings() end, },
	{ "DoomUIModules", 		function() conf_ui.doom_modules() end, },
	{ "DoomUIModuleBinds", 		function() conf_ui.doom_binds_table() end, },
}

conf_ui.binds = {
  { "[n", ":DoomUIMain<cr>", name = "doom main menu command"},
  { "[s", ":DoomUISettings<cr>", name = "picker doom settings"},
  { "[m", ":DoomUIModules<cr>", name = "picker doom modules"},
  { "[b", ":DoomUIModuleBinds<cr>", name = "picker doom binds"},
  {
    "<leader>",
    name = "+prefix",
    {
      {
        "D",
        name = "+doom",
        {
          { "F", [[ :DoomUIMain<cr> ]], name = "Doom Picker", options = { silent = false }, },
        },
      },
    },
  },
}

return conf_ui
