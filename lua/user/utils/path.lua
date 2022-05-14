local system = require("doom.core.system")
local utils = require("doom.utils")
local is_module_enabled = utils.is_module_enabled

local M = {}

-- TODO: redo this with plenary.path
M.path_get_tail = function(p)
  local tail = vim.tbl_map(function(s)
    return s:match("/([_%w]-)$") -- capture only dirname
  end, p)
  return tail
end

M.single_path_tail = function(s)
  -- local tail = vim.tbl_map(function(s)
    return s:match("/([_%w]-)$") -- capture only dirname
  -- end, p)
  -- return tail
end

-- REFACTOR:
--
-- add param `doom_dir_string` so that one can more easilly select from which diry ou want modules.
-- user/features/langs/core
-- if _include_core ??
--
-- make it more easy to pipe specific paths or whatever into telescope.

M.get_formated_path = function(path_components)
  local concat = table.concat(path_components, system.sep)
  return string.format("%s%s%s", system.doom_root, system.sep, concat)
end

M.get_modules_path = function(section_name)
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
  local fp = M.get_formated_path(pc)
  -- print(fp)
  return fp
end

M.get_doom_path = function(...) end

M.get_doom_features_modules_dir = function()
  M.get_doom_path("doom", "modules", "features")
end
M.get_doom_langs_modules_dir = function() end
M.get_user_modules_dir = function() end

M.user_modules_dir = function()
  return string.format(
    "%s%slua%suser%smodules",
    system.doom_root,
    system.sep,
    system.sep,
    system.sep
  )
end

M.get_dir_files_or_both_in_path_location = function(path)
  local scan_dir = require("plenary.scandir").scan_dir
  local scan_dir_opts = { search_pattern = ".", depth = 1, only_dirs = true }
  local t_current_module_paths = scan_dir(path, scan_dir_opts)
  return t_current_module_paths
end

M.get_user_mod_paths = function()
  return M.get_dir_files_or_both_in_path_location(M.user_modules_dir())
end

M.get_user_mod_names = function()
  return M.path_get_tail(M.get_user_mod_paths())
end

-- TODO: finish this
M.get_module_meta_data = function()
  local t = {}

  local sections = { "core", "features", "langs", "user" }

  for _, sec in pairs(sections) do
    local mp = M.get_modules_path(sec)
    local t_paths = M.get_dir_files_or_both_in_path_location(mp)
    vim.inspect(t_paths)
    for _, p in pairs(t_paths) do
      local tail = M.single_path_tail(p)
      table.insert(t, {
        path = p,
        name = tail,
        section = sec,
      })
    end
  end

  return t
end

return M
