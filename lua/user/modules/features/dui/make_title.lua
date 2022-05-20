local tm = {}

-- Dynamically generate titles so that you know exactly what parts of doom
-- that you are operating on.

tm.get_title = function()
  local title

  if doom_ui_state.query.type == "main_menu" then
    title = ":: MAIN MENU ::"

  elseif doom_ui_state.query.type == "settings" then
    title = ":: USER SETTINGS ::"

  elseif doom_ui_state.query.type == "modules" then
    title = ":: MODULES LIST ::"

    -- TODO: MODULES LIST (ORIGINS/CATEGORIES)

  elseif doom_ui_state.query.type == "module" then
    local postfix = ""
	  local morig = doom_ui_state.selected_module.origin
	  local mfeat = doom_ui_state.selected_module.section
	  local mname = doom_ui_state.selected_module.name
	  local menab = doom_ui_state.selected_module.enabled
    local on = menab and "enabled" or "disabled"
	  postfix = postfix .. "["..morig..":"..mfeat.."] -> " .. mname .. " (" .. on .. ")"
    title = "MODULE_FULL: " .. postfix -- make into const

  elseif doom_ui_state.query.type == "component" then
    -- TODO: MODULES LIST (/CATEGORIES)

  elseif doom_ui_state.query.type == "all" then
    -- TODO: MODULES LIST (/CATEGORIES)

  end

  return title
end



return tm
