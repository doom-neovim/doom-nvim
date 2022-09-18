local utils = require("doom.utils")
local fs = require("doom.utils.fs")
local system = require("doom.core.system")

-- REFACTOR: `DOOM/UTILS/SHELL.LUA`

local pu = require("doom.modules.features.dui.templates")

local shell = {}

-- TODO: use libuv for all i/o > mv into utils/fs


-- refator: when I pass the new module objects I don't need
-- to call utils here
shell.module_dir_new(for_section, new_name)
  -- local mp = user_utils_path.get_modules_path(for_section)
  local nmp = string.format("%s%s%s", mp, system.sep, new_name)
  local nmpi = string.format("%s%sinit.lua", nmp, system.sep)
  local mkdir = string.format("!mkdir -p %s", nmp)
  vim.cmd(mkdir)
  local touch = string.format("!touch %s", nmpi)
  vim.cmd(touch)
  fs.write_file(nmpi, pu.gen_temp_from_mod_name(new_name), "w+")
  vim.defer_fn(function()
    vim.cmd(string.format(":e %s", nmpi))
  end, 200)
end

shell.module_dir_rename(for_section, old_dir, new_name)
  -- local mp = user_utils_path.get_modules_path(for_section)
  local nmp = string.format("%s%s%s", mp, system.sep, new_name)
  local cmd = string.format("!mv %s %s", old_dir, nmp)
  vim.cmd(cmd)
end

shell.module_dir_rm(rm_path)
  print("rm path:", rm_path)
  local rm = string.format("!rm -r %s", rm_path)
  vim.cmd(rm)
end


return shell
