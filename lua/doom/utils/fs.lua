local luv = vim.loop
local fs = {}

if jit ~= nil then
  fs.is_windows = jit.os == "Windows"
else
  fs.is_windows = package.config:sub(1, 1) == "\\"
end

if fs.is_windows and vim.o.shellslash then
  fs.use_shellslash = true
else
  fs.use_shallslash = false
end

fs.get_seperator = function()
  if fs.is_windows and not fs.use_shellslash then
    return "\\"
  end
  return "/"
end

--- Joins a number of strings into a valid path
---@vararg string String segments to convert to file system path
fs.join_paths = function(...)
  return table.concat({ ... }, fs.get_seperator())
end

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

fs.rm_dir = function(path)
  local handle = luv.fs_scandir(path)

  if type(handle) == "string" then
    return fs.notify.error(handle)
  end

  while true do
    local name, t = luv.fs_scandir_next(handle)
    if not name then
      break
    end

    local new_cwd = fs.join_paths(path, name)
    if t == "directory" then
      local success = fs.rm_dir(new_cwd)
      if not success then
        return false
      end
    else
      local success = luv.fs_unlink(new_cwd)
      if not success then
        return false
      end
    end
  end

  return luv.fs_rmdir(path)
end

return fs
