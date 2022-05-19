local tm = {}


tm.get_title = function()
  local title

  -- print(doom_ui_state.prev.selection.type)

  -- if doom_ui_state.prev.selection.type == "module" then
  --   local postfix = ""
  --
  --   if doom_ui_state.selected_module_idx ~= nil then
  --
	 --    local idx = doom_ui_state.selected_module_idx
  --
	 --    local morig = doom_ui_state.all_modules_flattened[idx].origin
	 --    local mfeat = doom_ui_state.all_modules_flattened[idx].section
	 --    local mname = doom_ui_state.all_modules_flattened[idx].name
	 --    local menab = doom_ui_state.all_modules_flattened[idx].enabled
  --
  --     local on = menab and "enabled" or "disabled"
  --
	 --    postfix = postfix .. "["..morig..":"..mfeat.."] -> " .. mname .. " (" .. on .. ")"
  --
  --     title = "MODULE_FULL: " .. postfix -- make into const
  --   end
  -- end

  if doom_ui_state.query.type == "main_menu" then
    title = ":: MAIN MENU ::"

  elseif doom_ui_state.query.type == "settings" then
  elseif doom_ui_state.query.type == "modules" then

    -- if not components specified -> return all

    -- user
    -- doom

  elseif doom_ui_state.query.type == "module" then

    -- settings
    -- packages
    -- configs
    -- cmds
    -- autocmds
    -- binds

  elseif doom_ui_state.query.type == "component" then

  elseif doom_ui_state.query.type == "all" then

    -- settings
    -- packages
    -- configs
    -- cmds
    -- autocmds
    -- binds

  end

  return title
end



return tm
