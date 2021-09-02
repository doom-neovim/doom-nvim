---[[---------------------------------------]]---
--         utils - Doom Nvim utilities         --
--              Author: NTBBloodbath           --
--              License: GPLv2                 --
---[[---------------------------------------]]---

local M = {}
local system = require("doom.core.system")

-------------------- HELPERS --------------------
-- Doom Nvim version
M.doom_version = "3.1.1"

-- file_exists checks if the given file exists
-- @tparam string path The path to the file
-- @return boolean
M.file_exists = function(path)
  local fd = vim.loop.fs_open(path, "r", 438)
  if fd then
    vim.loop.fs_close(fd)
    return true
  end

  return false
end

-- Mappings wrapper, extracted from
-- https://github.com/ojroques/dotfiles/blob/master/nvim/init.lua#L8-L12
-- https://github.com/lazytanuki/nvim-mapper#prevent-issues-when-module-is-not-installed
local function is_module_available(name)
  if package.loaded[name] then
    return true
  else
    for _, searcher in ipairs(package.searchers or package.loaders) do
      local loader = searcher(name)
      if type(loader) == "function" then
        package.preload[name] = loader
        return true
      end
    end
    return false
  end
end

if is_module_available("nvim-mapper") then
  local mapper = require("nvim-mapper")

  M.map = function(mode, lhs, rhs, opts, category, unique_identifier, description)
    mapper.map(mode, lhs, rhs, opts, category, unique_identifier, description)
  end
  M.map_buf = function(bufnr, mode, lhs, rhs, opts, category, unique_identifier, description)
    mapper.map_buf(bufnr, mode, lhs, rhs, opts, category, unique_identifier, description)
  end
  M.map_virtual = function(mode, lhs, rhs, opts, category, unique_identifier, description)
    mapper.map_virtual(mode, lhs, rhs, opts, category, unique_identifier, description)
  end
  M.map_buf_virtual = function(mode, lhs, rhs, opts, category, unique_identifier, description)
    mapper.map_buf_virtual(mode, lhs, rhs, opts, category, unique_identifier, description)
  end
else
  -- Manually load the doom_config.lua file to avoid circular dependencies
  local doom_config_path
  if M.file_exists(string.format("%s%sdoom_config.lua", system.doom_configs_root, system.sep)) then
    doom_config_path = string.format("%s%sdoom_config.lua", system.doom_configs_root, system.sep)
  elseif M.file_exists(string.format("%s%sdoom_config.lua", system.doom_root, system.sep)) then
    doom_config_path = string.format("%s%sdoom_config.lua", system.doom_root, system.sep)
  end
  local config = dofile(doom_config_path)

  M.map = function(mode, lhs, rhs, opts, _, _, _)
    local options = config.doom.allow_default_keymaps_overriding and {} or { noremap = true }
    if opts then
      options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
  end
  M.map_buf = function(mode, lhs, rhs, opts, _, _, _)
    vim.api.nvim_buf_set_keymap(mode, lhs, rhs, opts)
  end
  M.map_virtual = function(_, _, _, _, _, _, _)
    return
  end
  M.map_buf_virtual = function(_, _, _, _, _, _, _)
    return
  end
end

-- For autocommands, extracted from
-- https://github.com/norcalli/nvim_utils
M.create_augroups = function(definitions)
  for group_name, definition in pairs(definitions) do
    vim.api.nvim_command("augroup " .. group_name)
    vim.api.nvim_command("autocmd!")
    for _, def in ipairs(definition) do
      local command = table.concat(vim.tbl_flatten({ "autocmd", def }), " ")
      vim.api.nvim_command(command)
    end
    vim.api.nvim_command("augroup END")
  end
end

-- Check if string is empty or if it's nil
-- @return boolean
M.is_empty = function(str)
  return str == "" or str == nil
end

-- Search if a table have the value we are looking for,
-- useful for plugins management
M.has_value = function(tabl, val)
  for _, value in ipairs(tabl) do
    if value == val then
      return true
    end
  end

  return false
end

-- read_file returns the content of the given file
-- @tparam string path The path of the file
-- @return string
M.read_file = function(path)
  local fd = vim.loop.fs_open(path, "r", 438)
  local stat = vim.loop.fs_fstat(fd)
  local data = vim.loop.fs_read(fd, stat.size, 0)
  vim.loop.fs_close(fd)

  return data
end

-- write_file writes the given string into given file
-- @tparam string path The path of the file
-- @tparam string content The content to be written in the file
-- @tparam string mode The mode for opening the file, e.g. 'w+'
M.write_file = function(path, content, mode)
  -- 644 sets read and write permissions for the owner, and it sets read-only
  -- mode for the group and others.
  vim.loop.fs_open(path, mode, tonumber("644", 8), function(err, fd)
    if not err then
      local fpipe = vim.loop.new_pipe(false)
      vim.loop.pipe_open(fpipe, fd)
      vim.loop.write(fpipe, content)
    end
  end)
end

M.load_modules = function(module_path, modules)
  for i = 1, #modules, 1 do
    local ok, err = xpcall(
      require,
      debug.traceback,
      string.format("%s.%s", module_path, modules[i])
    )
    if not ok then
      require("doom.extras.logging").error(
        string.format(
          "There was an error loading the module '%s.%s'. Traceback:\n%s",
          module_path,
          modules[i],
          err
        )
      )
    end
  end
end

return M
