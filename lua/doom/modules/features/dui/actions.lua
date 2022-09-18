local utils = require("doom.utils")
local mod = require("doom.modules.utils")
local log = require("doom.utils.logging")
local nui = require("doom.modules.features.dui.nui")
-- local sh = require("user.modules.features.dui2.shell")

-- TODO: nui themeing and stylez

-- TODO: undo points for all actions!!!!!

-- TODO: refactor everything NUI into util so that it becomes a bit nicer to handle

--  - open/edit (new) module in split / same win is default on <CR>

local actions = {}
local conf_ui = {}

conf_ui.settings = {
  confirm_alternatives = { "yes", "no" },
  section_alternatives = { "user", "features", "langs", "core" },
  component_alternatives = { "settings", "packages", "configs", "cmds", "autocmds", "binds" },
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
local confirm_alternatives = { "yes", "no" }

--
-- MODULE ACTIONS ------------------------------------------------------------
--

actions.m_edit = function(m)
  if m.type == "doom_module_single" then
    local buf = utils.get_buf_handle(m.path .. "init.lua")
    vim.api.nvim_win_set_buf(0, buf)
    -- vim.fn.cursor(er+1,ec)
  end
end

actions.m_rename = function(m)
  nui.nui_input("NEW NAME", function(value)
    if not mod.check_if_module_name_exists(m, value) then
      log.debug("old name: ", m.name, ", new name:", value)
      local ret = mod.root_rename({
        section = m.section,
        module_name = m.name,
        new_name = value,
      })
      if not ret then
        log.info("Renaming was unsuccessful - perhaps no captures were found in `modules.lua`.")
      else

        -- shell_mod_rename_dir(m.section, m.path, new_name)
        -- write modules.lua here? with vim or libuv??
        -- advanced: rename module internal require statements?
      end
    end
  end)
end

actions.m_create = function(sel, line)
  if string.len(line) < 2 then
    log.info("Module names require at least two characters!")
    return
  end

  log.debug("m_create()")

  local function create_module(new_name, for_section)
    local ret = mod.root_new({ section = for_section, new_name = new_name })
    if not ret then
      log.info("Adding new module to `modules.lua` was unsuccessful.")
    else

      -- local path_user_modules = string.format("%s/lua/user/modules", system.doom_root)
      -- local new_module_path = string.format("%s%s%s", path_user_modules, system.sep, new_mname)
      -- local new_module_init_file = string.format("%s%sinit.lua", new_module_path, system.sep)
      -- vim.cmd(string.format("!mkdir -p %s", new_module_path))
      -- vim.cmd(string.format("!touch %s", new_module_init_file))
      -- fs.write_file(
      --   new_module_init_file,
      --   user_utils_modules.get_module_template_from_name(new_mname),
      --   "w+"
      -- )
      -- vim.cmd(string.format(":e %s", new_module_init_file))
    end
  end

  -- TODO: ACCOUNT FOR `ORIGIN` or always create under user and then move modules to core with `m_move`
  --
  -- alternatively ONLY show doom origin if `development` mode is set under settings?
  nui.nui_menu("CONFIRM CREATE", confirm_alternatives, function(value)
    if value.text == "yes" then
      nui.nui_menu("FOR SECTION:", conf_ui.settings.section_alternatives, function(value)
        create_module(line, value.text)
      end)
    end
  end)
end

actions.m_delete = function(m)
  nui.nui_menu("CONFIRM DELETE", confirm_alternatives, function(value)
    if value.text == "yes" then
      -- print("delete module: ", c.selected_module.section .. " > " .. c.selected_module.name)
      log.info("Trying to DELETE module: " .. m.origin .. " > " .. m.section .. " > " .. m.name)

      local ret = mod.root_delete({
        section = m.section,
        module_name = m.name,
      })
      if not ret then
        log.info("Deletion was unsuccessful.")
      else
      end

      -- write_to_root_modules_file(buf)
      -- shell_mod_remove_dir(m.path) -- shell: rm m.path
    end
  end)
end

actions.m_toggle = function(m)
  -- local root_modules = utils.find_config("modules.lua")
  -- local buf = utils.get_buf_handle(root_modules)
  log.info("Toggling module: ")
  local ret = mod.root_toggle({
    section = m.section,
    module_name = m.name,
  })
  if not ret then
    log.info("Toggling module was unsuccessful.")
  else
  end
end

-- this one requires that all of the above works since this is a compound of all of the above.
actions.m_move = function(m)
  --   -- move module into into another section, eg. from user to core...
  --   -- 1. nui menu select ( other sections than self)
  --   -- 2. move module dir
  --   -- 3. transform `modules.lua` -> call `root_sync_modules` command??
end

-- this one is whacky but a fun experiment
actions.m_merge = function(m)
  -- select module A to merge into module B.
  log.debug("M MERGE")
end

actions.m_submit_module_to_upstream = function(m)
  --   TODO: EXPLICIT PROMPT ON WHAT IS GONNA HAPPEN HERE.

  -- create a PR onto `main` for selected module and submit PR.
  -- cherry pick relevant co mmits onto `main`
end

actions.m_breakout_into_standalone_plugin = function(m)
  -- if a plugin grows too large -> break it out into its own repo.
  -- create new plugin dir at path xxx
end

--
-- COMPONENT ACTIONS ---------------------------------------------------------
--

actions.c_add = function(sel)
  log.info("Add component")

  -- TODO: SET STATE.SELECTED_COMPONENT AND MODULE EXPLICITLY
  --
  --    >>> why
  --          1. history!!! > go back / redo last command..
  --          2. readability.

  nui.nui_menu("ADD MODULE COMPONENT:", conf_ui.settings.component_alternatives, function(value)
    local sv = value.text
    local t = {
      selected_module = DOOM_UI_STATE.selected_module,
      selected_component = sel,
      ui_input_comp_type = sv,
      -- ui_input_module = ..
    }
    if sv == "settings" then
      mod.setting_add(t)
    elseif sv == "packages" then
      mod.package_add(t)
    elseif sv == "configs" then
      mod.config_add(t)
    elseif sv == "cmds" then
      mod.cmd_add(t)
    elseif sv == "autocmds" then
      mod.autocmd_add(t)
    elseif sv == "binds" then
      mod.bind_add(t)
    end
  end)
end

-- actions.c_add_same = function(sel) end
-- actions.c_edit_sel = function(sel)
--   log.info("Edit component")
--   local ret = mod.module_apply({
--     action = "component_edit_sel",
--     selected_module = DOOM_UI_STATE.selected_module,
--     selected_component = sel,
--   })
-- end

--
-- SETTINGS
--

actions.c_setting_edit = function(sel)
  log.info("Edit single doom setting.")
  print(vim.inspect(sel))
  -- find settings prop in settings file
  -- enter insert at last position.
  local ret = mod.setting_edit({
    selected_module = DOOM_UI_STATE.selected_module,
    selected_component = sel.value,
  })
  -- if no module is selected then do root settings
end
-- actions.c_setting_replace = function(buf, config) end
-- actions.c_setting_remove = function(buf, config) end

--
-- ADD PACKAGES
--

-- actions.c_pkg_add = function()
--   local ret = mod.module_apply({
--     action = "add_package",
--   })
-- end

actions.c_pkg_edit = function(sel)
  local ret = mod.package_edit({
    selected_module = DOOM_UI_STATE.selected_module,
    selected_component = sel.value,
  })
end
-- actions.c_pkg_fork = function()
--   local ret = mod.module_apply({
--     action = "fork_package",
--   })
-- end
-- actions.c_pkg_clone = function()
--   local ret = mod.module_apply({
--     action = "clone_package",
--   })
-- end
-- actions.c_pkg_remove = function()
--   local ret = mod.module_apply({
--     action = "remove_package",
--   })
-- end

--
-- ADD CONFIGS
--

-- actions.c_config_add = function()
--   local ret = mod.config_add({
--     selected_module = DOOM_UI_STATE.selected_module,
--     selected_component = sel.value,
--   })
-- end

actions.c_cfg_edit = function(sel)
  log.info("Edit single doom pkg config.")
  -- print(vim.inspect(sel))
  local ret = mod.config_edit({
    selected_module = DOOM_UI_STATE.selected_module,
    selected_component = sel.value,
  })
end

actions.c_cfg_remove = function()
  local ret = mod.module_apply({
    action = "remove_package_config",
  })
end

--
-- ADD CMD
--

-- actions.c_cmd_add = function(buf, config)
--   -- requires module to have been selected.
--   local ret = mod.module_apply({
--     action = "add_cmd",
--   })
-- end

actions.c_cmd_edit = function(sel)
  log.info("action: edit cmd")
  -- print(vim.inspect(sel))
  local ret = mod.cmd_edit({
    selected_module = DOOM_UI_STATE.selected_module,
    selected_component = sel.value,
  })
end

actions.c_cmd_remove = function() end
actions.c_cmd_move = function() end

--
-- ADD AUTOCMDS
--

actions.c_autocmd_add = function()
  local ret = mod.module_apply({
    action = "add_autocmd",
  })
end

actions.c_autocmd_edit = function(sel)
  log.info("action: edit autocmd")
  -- print(vim.inspect(sel))
  local ret = mod.autocmd_edit({
    selected_module = DOOM_UI_STATE.selected_module,
    selected_component = sel.value,
  })
end

actions.c_autocmd_remove = function()
  local ret = mod.module_apply({
    action = "remove_autocmd",
  })
end
actions.c_autocmd_move = function() end

--
-- BINDS
--

actions.c_bind_add_after = function(sel)
  -- for regular binds this means insert below,
  -- for leader, this also means insert below
  log.info("action: bind after")
  -- print(vim.inspect(sel))
  local ret = mod.bind_add_after({
    selected_module = DOOM_UI_STATE.selected_module,
    selected_component = sel.value,
  })
end

actions.c_bind_edit = function(sel)
  log.info("Edit single bind.")
  -- print(vim.inspect(sel))
  local ret = mod.bind_edit({
    selected_module = DOOM_UI_STATE.selected_module,
    selected_component = sel.value,
  })
end

actions.c_bind_replace = function()
  local ret = mod.module_apply({
    action = "edit_bind",
  })
end

actions.c_bind_create_from_line = function(sel, line)
  -- find selected leader bind in module file.
  -- enter new binds snippet in the correct selected leader node.
  log.info("action: bind create from line")
  -- print(vim.inspect(sel))
  local ret = mod.bind_create_from_line({
    sel_mod = DOOM_UI_STATE.selected_module,
    sel_cmp = sel.value,
    line = line
  })
end

actions.c_bind_move = function()
  -- 1. use telescope line string to move the bind to a new `lhs`
  -- 2. if you start with a `<ld>`, then we add the new bind to a new leader.
end
--
-- USER CONFIG
--

-- todo: play around with functions for inserting templates and shit into
-- `./config.lua` which is a big playground just for fun to see what we
-- can come up with.
--
-- config test add setting
-- config test add function ..

return actions
