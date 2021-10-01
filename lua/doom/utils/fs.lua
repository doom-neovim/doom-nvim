---[[---------------------------------------]]---
--      fs utils - Doom Nvim fs utilities      --
--              Author: NTBBloodbath           --
--              License: GPLv2                 --
---[[---------------------------------------]]---

local fs = {}

--- Check if the given file exists
--- @param path string The path of the file
--- @return boolean
fs.file_exists = function(path)
  local fd = vim.loop.fs_open(path, "r", 438)
  if fd then
    vim.loop.fs_close(fd)
    return true
  end

  return false
end

--- Returns the content of the given file
--- @param path string The path of the file
--- @return string
fs.read_file = function(path)
  local fd = vim.loop.fs_open(path, "r", 438)
  local stat = vim.loop.fs_fstat(fd)
  local data = vim.loop.fs_read(fd, stat.size, 0)
  vim.loop.fs_close(fd)

  return data
end

--- write_file writes the given string into given file
--- @param path string The path of the file
--- @param content string The content to be written in the file
--- @param mode string The mode for opening the file, e.g. 'w+'
fs.write_file = function(path, content, mode)
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

return fs
