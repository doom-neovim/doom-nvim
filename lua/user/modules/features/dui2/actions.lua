-- local utils = require("doom.utils")
-- local fs = require("doom.utils.fs")
local system = require("doom.core.system")

-- local sh = require("user.modules.features.dui2.shell")
local nui = require("user.modules.features.dui2.nui")

local actions = {}

local confirm_alternatives = { "yes", "no" }


actions.m_edit = function(m)
  if m.type == "module" then
    vim.cmd(string.format(":e %s%s%s", m.path, system.sep, "init.lua"))
  end
end

actions.m_rename = function(m)
  nui.nui_input("NEW NAME", function(value)
    if not check_if_module_name_exists(c, value) then
      print("old name: ", m.name, ", new name:", value)
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

actions.m_create = function(m)
  local new_name
  local for_section

  nui.nui_menu("CONFIRM CREATE", confirm_alternatives, function(value)
    if value.text == "yes" then
      new_name = c.new_module_name
      nui.nui_menu("FOR SECTION:", conf_ui.settings.section_alternatives, function(value)
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
actions.m_delete = function(c)
  nui.nui_menu("CONFIRM DELETE", confirm_alternatives, function(value)
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

actions.m_toggle = function(c)
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

actions.m_move = function(buf, config)
--   -- move module into into (features/langs)
--   -- 1. nui menu select ( other sections than self)
--   -- 2. move module dir
--   -- 3. transform `modules.lua`
end

actions.m_merge = function(buf, config)
--   -- 1. new prompt for B
--   -- 2. select which module to pull into A
--   -- 3. do...
end

return actions
