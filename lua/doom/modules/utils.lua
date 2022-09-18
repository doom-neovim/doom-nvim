local log = require("doom.utils.logging")
local utils = require("doom.utils")
local spec = require("doom.core.spec")
local tree = require("doom.utils.tree")
local tscan = require("doom.utils.tree").traverse_table
local templ = require("doom.utils.templates")
local ts = require("doom.utils.ts")
local b = require("doom.utils.buf")
local dq = require("doom.utils.queries")
local tsq = require("vim.treesitter.query")
local ntu = require("nvim-treesitter.ts_utils")

-- TODO: add good debug logs and messages

------------------------------------------------------------------

local compute_insertion_point = function() end

local rmf = utils.find_config("modules.lua")

local mod_glob_path = function(origin)
  return string.format("%s/lua/%s/modules/**/init.lua", vim.fn.stdpath("config"), origin)
end

local function m_glob(cat)
  if vim.tbl_contains(spec.origins, cat) then
    return vim.split(vim.fn.glob(mod_glob_path(cat)), "\n")
  end
end

local function ts_text(node, buf)
  return tsq.get_node_text(node, buf)
end

local function contains_node(outer, inner) end

local function get_replacement_range(strings, comments, module_name, buf)
  if strings[1] then
    return {
      strings[1].range[1],
      strings[1].range[2] + 1,
      strings[1].range[3],
      strings[1].range[4] - 1,
    },
      true
  else
    for _, node in ipairs(comments) do
      local match_str = '--%s-"' .. module_name .. '",'

      -- find position of module name in the comment
      if string.match(node.text, match_str) then
        local start_pos = string.find(node.text, module_name)
        local end_pos = start_pos + string.len(module_name)
        local indentation = node.range[2] - 1
        local name_real_start = indentation + start_pos
        local name_real_end = indentation + end_pos
        return { node.range[1], name_real_start, node.range[3], name_real_end },
          false,
          node.range[2]
      end
    end
  end
end

-- TODO: IMPLEMENT
local function check_base_table(type)
  print("check base table")
  if type == "settings" then
  elseif type == "packages" then
  elseif type == "configs" then
  elseif type == "cmds" then
  elseif type == "autocmds" then
  elseif type == "binds" then
  end
end
-- local validate = function(opts)
--   -- DOESN'T DO MUCH AT THE MOMENT. DUNNO IF THIS IS NECESSARY ATM.
--   --
--   -- todo: check what types of components a module contain so that we
--   -- can make conditionals based on this. Eg.
--   if not opts.action then
--     return false
--   end
--   return true
-- end

-- todo
--
--    - insert before/after
--
local function act_on_capture(captures, buf)
  -- TODO: USE THIS FUNCTION IN NVIM-TREESITTER.
  --
  --  PR: add the ability to pass a buf handle
  --
  -- goto_node(node, goto_end, avoid_set_jump)~
  -- Sets cursor to the position of `node` in the current windows.

  if #captures > 0 then
    if doom.settings.doom_ui.use == "templates" then
      -- insert template
    elseif doom.settings.doom_ui.use == "luasnip" then
      -- init luasnippet
    else
      -- only move cursor
      b.set_cursor_to_buf(buf, captures[#captures].range)
    end
  end
end

local function get_settings_file(mod_path)
  if mod_path then
    return mod_path .. "init.lua"
  else
    return utils.find_config("settings.lua")
  end
end

local function has_leader(mpath, capture)
  print("has leader c:", capture)
  local leader, buf = ts.get_captures(mpath, dq.leader_t, capture or "leader_field")
  return leader, buf
end

local function is_branch(ts_branch_field, buf)
  local br_lhs = ts.child_n(ts_branch_field, { 0, 0, 0 }) -- (branch_field:named_child(0)):named_child(0)
  local br_name = ts.child_n(ts_branch_field, { 0, 1, 1 }) -- (branch_field:named_child(1)):named_child(1)
  return (br_lhs:type() == "string" and ts_text(br_name, buf):match('^"+'))
end

local function is_leader_lhs_match(field, lhs, buf)
  local br_lhs = ts.child_n(field, { 0, 0, 0 }) -- (branch_field:named_child(0)):named_child(0)
  if br_lhs then
    -- print("is_leader_lhs_match:", ts_text(br_lhs, buf), "==", '"' .. lhs .. '"')
    local check = '"' .. lhs .. '"'
    return ts_text(br_lhs, buf) == check
  end
  return false
end

-- expects the leader table field
-- assumes no duplicate branches...
--
-- if no child leaders return leader field
--    also now lhs_str == ""
local function find_deepest_leader_for_string(buf, leader_table_field, lhs_str)
  local field = leader_table_field

  while true do
    local found = false
    local binds_tc = ts.child_n(field, { 0, 2, 0 }) -- (branch_field:named_child(0)):named_child(0)
    local binds_tc_children = ntu.get_named_children(binds_tc)
    local first_char = lhs_str:sub(1, 1)
    for k, child_field in pairs(binds_tc_children) do
      if is_leader_lhs_match(child_field, first_char, buf) then
        found = true
        field = child_field
      end
    end
    if not found then -- or lhs_str == "" then
      break
    end
    lhs_str = lhs_str:sub(2, -1)
  end
  return field, lhs_str
end

local function build_new_bind()
  print("build new bind")
  -- BUILD NEW LEADER
  --
  --
  --      create helper func
  --
  --      generate dummy branch names
  --          +AAA, +BBB, +CCC, ...
end

-- expect bind enclosing field node
--
-- no actually if we rewrite this with a while loop it doesn't matter
-- what you pass in.
--
-- want = "bind|branch"
--
local function get_bind_tree_parent(ts_bind_field, buf)
  -- if parent == "<leader>" ??

  -- FIND FIRST BIND OR BRANCH FIELD

  -- three releval options to check for:
  --
  --    binds field
  --
  --    branch field
  --
  --    leader field




  local branch_field = ts.parent_n(ts_bind_field, 4)
  if is_branch(branch_field, buf) then
    return branch_field
  end
end

-- returns the last binds child table in a branch
local function get_all_bind_sub_tables(ts_branch_field, buf)
  local binds_tc = ts.child_n(ts_branch_field, { 0, 2, 0 }) -- (branch_field:named_child(0)):named_child(0)
  local t_binds = {}
  -- i could use nvu get_named_children() here as well
  for n in binds_tc:iter_children() do
    if n:named() then
      local br_lhs = ts.child_n(branch_field, { 0, 0, 0 }) -- (branch_field:named_child(0)):named_child(0)
      local br_name = ts.child_n(branch_field, { 0, 1, 1 }) -- (branch_field:named_child(1)):named_child(1)

      if not is_branch(n, buf) then
        table.insert(t_binds, n)
      end
    end
  end
  return t_binds
end

local function get_all_branch_sub_tables(branch) end

---------
-- get_all_sibling_binds

local function get_all_sibling_binds(bind, buf)
  local branch_parent = get_bind_tree_parent(bind, buf)
  return get_all_bind_sub_tables(branch_parent, buf)
end

local function get_branch_node_under_cursor()

end
-- local get_text = function(node, bufnr)
-- end

local mod_util = {}

mod_util.modules_refactor = function()
  -- eg. if you have
  -- mod_x.configs["arst"] = function() end
  --
  -- transform this into a regular table where all functions
  -- are kept inside of it??
end

-- run this to make sure that all modules are exposed in the
-- root file.
mod_util.sync_modules_to_root_file = function()
  -- reuse funcs from module CRUD here to
  -- insert modules.
end

mod_util.module_move_all_component_function_into_table = function()
  -- if you have
  -- mod.xx["xx"]  = func
  --  move this into mod.xx = { ["xx"] = func, ["yy"] = ....}
end

mod_util.validate_and_prettify_modules = function()
  -- A. check that components are structured in the correct order.
  -- B. make sure that there are very clear `comment_frames` that
  --      make it easy to follow where you are and which module you are
  --      looking at.
  -- C. Insert missing components if necessary.
end

-- todo: branch check origin/section/category
mod_util.check_if_module_name_exists = function(m, new_name)
  -- local orig = type(m) == "string" and m or m.section
  -- local sec = type(m) == "string" and m or m.section
  local results = tscan({
    tree = require("doom.modules.utils").extend(),
    filter = "doom_module_single", -- what makes a node in the tree
    leaf = function(_, _, v)
      -- todo: if m == string then do
      --
      if m.section == v.section and v.name == new_name then
        log.debug("dui/actions check_if_module_exists: true")
        return true
      end
    end,
  })
  return false
end

mod_util.root_new = function(opts)
  local tables, buf = ts.get_captures(rmf, dq.root_section(opts.section), "section_table")
  local ntu = #tables
  b.insert_line(buf, tables[ntu].range[3], '    "' .. opts.new_name .. '",')
end

mod_util.root_rename = function(opts)
  local strings = ts.get_captures(rmf, dq.root_mod(opts.module_name, opts.section), "module_string")
  local comments, buf = ts.get_captures(rmf, dq.root_comments(opts.section), "section_comment")
  local range, enabled, comment_start = get_replacement_range(
    strings,
    comments,
    opts.module_name,
    buf
  )
  b.set_text(buf, range, opts.new_name)
end

mod_util.root_delete = function(opts)
  local strings = ts.get_captures(rmf, dq.root_mod(opts.module_name, opts.section), "module_string")
  local comments, buf = ts.get_captures(rmf, dq.root_comments(opts.section), "section_comment")
  local range, enabled, comment_start = get_replacement_range(strings, comments, selected_mod, buf)
  vim.api.nvim_buf_set_lines(buf, range[1], range[1] + 1, 0, {})
end

mod_util.root_toggle = function(opts)
  local strings = ts.get_captures(rmf, dq.root_mod(opts.module_name, opts.section), "module_string")
  local comments, buf = ts.get_captures(rmf, dq.root_comments(opts.section), "section_comment")
  local range, enabled, comment_start = get_replacement_range(
    strings,
    comments,
    opts.module_name,
    buf
  )

  if enabled then
    b.insert_text_at(buf, range[1], range[2] - 1, "-- ")
  else
    range[2] = comment_start
    b.set_text(buf, range, '"' .. opts.module_name)
  end
end

--
-- SETTINGS
--

mod_util.setting_add = function(opts)
  act_on_capture(
    ts.get_captures(
      get_settings_file(opts.selected_module),
      dq.mod_tbl(opts.ui_input_comp_type),
      "rhs"
    )
  )
end

mod_util.setting_edit = function(opts)
  local sc = opts.selected_component
  act_on_capture(
    ts.get_captures(
      get_settings_file(opts.selected_module),
      dq.mod_tbl(sc.component_type),
      "rhs",
      dq.field(sc.data.table_path[#sc.data.table_path], sc.data.table_value),
      "value"
    )
  )
end

mod_util.setting_add_to_selection_level = function()
  -- allows you to select a sub table entry and add a new entry to
  -- the same sub table
end

mod_util.setting_move = function(opts) end

mod_util.setting_remove = function(opts) end

mod_util.setting_replace = function(opts) end

--
-- PACKAGES
--

mod_util.package_add = function(opts)
  act_on_capture(
    ts.get_captures(
      opts.selected_module.path .. "init.lua",
      dq.mod_tbl(opts.selected_component.component_type),
      "rhs"
    )
  )
end

mod_util.package_edit = function(opts)
  act_on_capture(
    ts.get_captures(
      opts.selected_module.path .. "init.lua",
      dq.mod_tbl(opts.selected_component.component_type),
      "rhs",
      dq.pkg_table(opts.selected_component.data.table_path, opts.selected_component.data.spec[1]),
      "pkg_table"
    )
  )
end

mod_util.package_move = function(opts) end
mod_util.package_remove = function(opts) end
mod_util.package_clone = function(opts) end
mod_util.package_fork = function(opts) end
mod_util.package_toggle_local = function(opts) end
mod_util.package_use_specific_upstream = function(opts) end

mod_util.create_new_module_from = function()
  -- package string / section
  -- or other compones.
  -- spawn new module and enter it etc.
end

--
-- CONFIGS
--

-- 1. check if config table exists
-- 2. add table after
--        - settings
--      and before
--        - standalone config functions > need to check if these exist
--              also check if the target pkg already has a standalone func.
--        - before cmds/autocmds/binds
--
mod_util.config_add = function(opts)
  local captures, buf = ts.get_captures(
    opts.selected_module.path .. "init.lua",
    dq.config_func(),
    "rhs"
  )
  act_on_capture(captures, buf)
end

mod_util.config_edit = function(opts)
  act_on_capture(
    ts.get_captures(
      opts.selected_module.path .. "init.lua",
      dq.config_func(opts.selected_component.data),
      "rhs"
    )
  )
end

mod_util.config_remove = function(opts) end
mod_util.config_replace = function(opts) end

--
-- CMDS
--

mod_util.cmd_add = function(opts)
  -- print(vim.inspect(opts.selected_component))
  act_on_capture(
    ts.get_captures(
      opts.selected_module.path .. "init.lua",
      dq.mod_tbl(opts.selected_component.component_type),
      "rhs"
    )
  )
end

mod_util.cmd_edit = function(opts)
  act_on_capture(
    ts.get_captures(
      dq.mod_tbl(opts.selected_module.path .. "init.lua", opts.selected_component.component_type),
      "rhs",
      dq.cmd_table(opts.selected_component.data),
      "action"
    )
  )
end

mod_util.cmd_remove = function(opts) end
mod_util.cmd_replace = function(opts) end
mod_util.cmd_move = function(opts) end

--
-- AUTOCMDS
--

mod_util.autocmd_add = function(opts)
  act_on_capture(
    ts.get_captures(
      opts.selected_module.path .. "init.lua",
      dq.mod_tbl(opts.ui_input_comp_type),
      "rhs"
    )
  )
end

mod_util.autocmd_edit = function(opts)
  act_on_capture(
    ts.get_captures(
      opts.selected_module.path .. "init.lua",
      dq.mod_tbl(opts.ui_input_comp_type),
      "rhs",
      dq.autocmd_table(opts.selected_component.data),
      "action"
    )
  )
end

mod_util.autocmd_remove = function(opts) end
mod_util.autocmd_replace = function(opts) end
mod_util.autocmd_move = function(opts) end

--
-- BINDS
--

mod_util.bind_add = function(opts)
  local t, buf = ts.get_captures(
    opts.selected_module.path .. "init.lua",
    dq.mod_tbl(opts.selected_component.component_type),
    "rhs"
  )

  local leader = has_leader(opts.selected_module.path_init)
  if #leader > 0 then
    act_on_capture(leader, buf)
  else
    act_on_capture(t, buf)
  end
end

mod_util.bind_add_after = function(opts)
  -- TELESCOPE  -> then get the bind under cursor with queries
  -- REGULAR    -> get bind / enclosing with nvim treesitter cursor helpers.
  local binds_tbl, bind, buf = ts.get_captures(
    opts.selected_module.path_init,
    dq.mod_tbl(opts.selected_component.component_type),
    "rhs",
    dq.binds_table(opts.selected_component.data),
    "bind_field"
  )
  local leader_tbl = has_leader(opts.selected_module.path_init, "leader_table")
  print("after; path_init:", opts.selected_module.path_init)
  -- print("leader_tbl:", vim.inspect(leader_tbl))
  -- print("bind:", vim.inspect(bind))
  local new_leader = ntu.is_parent(leader_tbl[1].node, bind[1].node) -- Nodes
  local captures = new_leader and get_all_sibling_binds(bind[1].node, buf) or bind

  print("new_leader:", new_leader)
  -- act_on_capture(captures, buf)
end

mod_util.bind_edit = function(opts)
  -- print(vim.inspect(opts.selected_component))
  act_on_capture(
    ts.get_captures(
      opts.selected_module.path .. "init.lua",
      dq.mod_tbl(opts.selected_component.component_type),
      "rhs",
      dq.binds_table(opts.selected_component.data),
      "rhs"
    )
  )
end

mod_util.bind_add_to_selection_level = function(opts) end

mod_util.bind_add_to_level = function(opts) end

mod_util.bind_remove = function(opts) end

mod_util.bind_replace = function(opts) end

mod_util.bind_move = function(opts) end

mod_util.bind_create_from_line = function(opts)
  local binds_table, buf = ts.get_captures(opts.sel_mod.path_init, dq.mod_tbl(opts.sel_cmp), "rhs")

  check_base_table("binds")

  local line = opts.line
  local match_leader = line:match("^%s*")
  local first_char = line:find("%w")
  print("fc:", first_char)
  local lhs_str = line:sub(first_char, -1)

  print("match leader:", match_leader)
  print("lhs_str: [" .. lhs_str .. "]")

  local leader = has_leader(opts.sel_mod.path_init, "leader_field")

  -- i(leader)

  local leader_tbl, branch_target
  if leader[1] then
    leader_tbl = leader[1].node
    branch_target_field, new_lhs_subtracted = find_deepest_leader_for_string(
      buf,
      leader_tbl,
      lhs_str
    )
  end

  if new_lhs_subtracted == "" then
    log.error("Create leader from line: leader `" .. lhs_str .. "` already exists.")
  end

  print("after: ", branch_target_field, new_lhs_subtracted)

  local bind_new_compiled_str = build_new_bind(new_lhs_subtracted)

  if #leader > 0 then
    if match_leader then
      print("1. leader exists;   append new leader")
      -- branch_target add new leader
    else
      print("2. leader exists;   insert new bind")
    end
  else
    if match_leader then
      print("3. create new leader table + bind")
      -- create leader table + new bind
      -- insert
    else
      print("4. no leader; insert new bind last")
    end
  end
end

mod_util.bind_move_leader = function(opts)
  -- make it more easy to manage binds
end

mod_util.bind_add_to_same = function(opts) end

mod_util.bind_make_leader = function(opts)
  -- create a loop that generates the leader.
  --
  -- leader_max_length
end

mod_util.bind_merge_leader = function(opts) end

--
-- GET EXTENDED MODULES WITH META DATA

local function get_mod_tbl_path_from_string(p)
  local org = p:match("lua/([_%w]-)/modules/")
  local ss = "lua/" .. org .. "/modules/"
  local sec_start = p:find(ss)
  local section_dirs = p:sub(sec_start + string.len(ss), p:find("/init%.lua$") - 1)
  local sec_t = vim.fn.split(section_dirs, "/")
  local name = table.remove(sec_t, #sec_t)
  return org, sec_t, name
end

mod_util.extend = function(filter)
  local all = utils.tbl_merge(m_glob("doom"), m_glob("user"))
  local m_all = { doom = {}, user = {} }
  for _, p in ipairs(all) do
    local org, sec, name = get_mod_tbl_path_from_string(p)
    tree.attach_table_path(m_all[org], { sec[1], name }, {
      type = "doom_module_single", -- todo: how is type used?
      enabled = false,
      name = name,
      section = sec[1], -- only `sec` later
      origin = org,
      path = string.sub(p, 1, -9), -- only the dir path
      path_init = p,
    })
  end
  tree.traverse_table({
    tree = require("doom.core.modules").enabled_modules,
    leaf = function(stack, _, v)
      local pc, path_concat = tree.flatten_stack(stack, v, ".")
      for _, path in ipairs(spec.search_paths(path_concat)) do
        local origin = path:sub(1, 4)
        local m = tree.attach_table_path(m_all[origin], pc)
        if m then
          m.enabled = true
          for i, j in pairs(tree.attach_table_path(doom.modules, pc)) do
            m[i] = j
          end
        end
      end
    end,
  })

  -- TODO: filter hasn't been adapted to recursive pattern yet. only pass through
  local function apply_filters(mods)
    -- AND type(filter) == "table"
    if filter and type(filter) == "table" then
      if filter.origins then
        for o, origin in pairs(mods) do
          if vim.tbl_contains(filter.origins, o) then
            table.remove(mods, o) -- filter origins
          else
            for s, section in pairs(origin) do
              if not vim.tbl_contains(filter.sections, s) then
                table.remove(mods[o], s) -- filter sections
              else
                for m, _ in pairs(section) do
                  if m.enabled ~= filter.enabled or not vim.tbl_contains(filter.names, m) then
                    table.remove(mods[o][s], m) -- filter modules by name
                  end
                end
              end
            end
          end
        end
      end
    end
    return mods
  end

  return apply_filters(m_all)
end

return mod_util
