local utils = {}

local system = require("doom.core.system")
local fs = require("doom.utils.fs")

--- Doom Nvim version
utils.version = {
  major = 4,
  minor = 1,
  patch = 0,
}

--- Currently supported version of neovim for this build of doom-nvim
utils.nvim_latest_supported = "nvim-0.8"

utils.doom_version = string.format(
  "%d.%d.%d",
  utils.version.major,
  utils.version.minor,
  utils.version.patch
)

-- Finds `filename` (where it is a doom config file).
utils.find_config = function(filename)
  local function get_filepath(dir)
    return table.concat({ dir, filename }, system.sep)
  end

  local path = get_filepath(system.doom_configs_root)
  if fs.file_exists(path) then
    return path
  end
  path = get_filepath(system.doom_root)
  if fs.file_exists(path) then
    return path
  end
  local candidates = vim.api.nvim_get_runtime_file(
    get_filepath("*" .. system.sep .. "doon-nvim"),
    false
  )
  if not vim.tbl_isempty(candidates) then
    return candidates[1]
  end
  -- TODO: Consider copying the default to the user config dir.
  -- Can't use log yet, doom doesn't exist.
  print(("Error while loading %s: Not found"):format(filename))
  vim.cmd("qa!")
end

-- If it receives a bool, returns the corresponding number. Otherwise
-- it's an identity function.
--
-- Useful for setting vim-style boolean options.
utils.bool2num = function(bool_or_num)
  if type(bool_or_num) == "boolean" then
    return bool_or_num and 1 or 0
  end
  return bool_or_num
end

--- Useful in vim `:set <option>` style commands
---@param bool boolean Bool to convert to string
---@return string "on" or "off"
utils.bool2str = function(bool)
  return bool and "on" or "off"
end

--- Wraps lua's require function in an xpcall and logs errors.
---@param path string
---@return any
utils.safe_require = function(path)
  local log = require("doom.utils.logging")
  log.debug(string.format("Doom: loading '%s'... ", path))
  local ok, result = xpcall(require, debug.traceback, path)
  if not ok and result then
    log.error(string.format("There was an error requiring '%s'. Traceback:\n%s", path, result))
    return nil
  else
    log.debug(string.format("Successfully loaded '%s' module", path))
    return result
  end
end

utils.get_sysname = function()
  return vim.loop.os_uname().sysname
end

local index = 1
utils.unique_index = function()
  local ret = index
  index = index + 1
  return ret
end

--- Wraps nvim_replace_termcodes
--- @param str string
--- @return string
function utils.replace_termcodes(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

--- Check if string is empty or if it's nil
--- @param str string The string to be checked
--- @return boolean
utils.is_empty = function(str)
  return str == "" or str == nil
end

--- Escapes a string
--- @param str string String to escape
--- @return string
utils.escape_str = function(str)
  local escape_patterns = {
    "%^",
    "%$",
    "%(",
    "%)",
    "%[",
    "%]",
    "%%",
    "%.",
    "%-",
    "%*",
    "%+",
    "%?",
  }

  return str:gsub(("([%s])"):format(table.concat(escape_patterns)), "%%%1")
end

--- Wraps the appropriate diagnostics function according to nvim version
--- @param bufnr number The number of desired buffer
--- @param severity string The name of desired severity
--- @return number The count of items
utils.get_diagnostic_count = function(bufnr, severity)
  return vim.tbl_count(vim.diagnostic.get(bufnr, {
    severity = severity,
  }))
end

--- Check if the given plugin is disabled in doom-nvim/modules.lua
--- @param section string The module section, e.g. features
--- @param plugin string The module identifier, e.g. statusline
--- @return boolean
utils.is_module_enabled = function(section, plugin)
  local modules = require("doom.core.modules").enabled_modules

  return modules[section] and vim.tbl_contains(modules[section], plugin)
end

--- Rounds a number, optionally to the nearest decimal place
--- @param num number - Value to round
--- @param decimalplace number|nil - Number of decimal places
--- @return number
utils.round = function(num, decimalplace)
  local mult = 10 ^ (decimalplace or 0)
  return math.floor(num * mult + 0.5) / mult
end

--- Searches for a number of executables in the user's path
--- @param executables table<number, string> Table of executables to search for
--- @return string|nil First valid executable in table
utils.find_executable_in_path = function(executables)
  return vim.tbl_filter(function(c)
    return c ~= vim.NIL and vim.fn.executable(c) == 1
  end, executables)[1]
end

--- Picks a field from a table by checking the keys if it's compatible
---@generic T
---@param compatibility_table table<string,T>
---@return T
---@example
---```lua
---local val = utils.pick_compatible_field({
---  ['nvim-0.5'] = 'this will be picked',
---  ['nvim-9.9'] = 'version too high, wont be picked'
---})
---print(val) -- > 'this will be picked'
---```
utils.pick_compatible_field = function(compatibility_table)
  -- Sort the keys in order of neovim version
  local sorted = vim.tbl_keys(compatibility_table)
  table.sort(sorted, function(a, b)
    return a < b
  end)
  -- Need "latest" to be last as it is a catch all for the default behaviour
  if sorted[1] == "latest" then
    table.remove(sorted, 1)
    table.insert(sorted, "latest")
  end

  -- Find the last key that is compatible with this neovim version
  local last_field = nil
  for _, version in ipairs(sorted) do
    local field = compatibility_table[version]
    local ver = version == "latest" and utils.nvim_latest_supported or version

    if vim.fn.has(ver) == 1 then
      last_field = field
    else
      break
    end
  end

  -- Must always return a value.
  if last_field == nil then
    error("Error getting compatible field.")
  end
  return last_field
end

--- Pads a string with chars on the right hand side.
---@param str string String to pad
---@param length number Intended length of string
---@param char string|nil Single char to fill with
---@return string,boolean Padded string,Flag if padding was needed
utils.right_pad = function(str, length, char)
  local res = str .. string.rep(char or " ", length - #str)

  return res, res ~= str
end
--- Pads a string with chars on the left hand side.
---@param str string String to pad
---@param length number Intended length of string
---@param char string|nil Single char to fill with
---@return string,boolean Padded string,Flag if padding was needed
utils.left_pad = function(str, length, char)
  local res = string.rep(char or " ", length - #str) .. str

  return res, res ~= str
end

-- Get or Set a table path list.
--
-- Used with recursive module structures so that you can check if eg. a deep
-- path exists or if you want to create/set data to a deep path.
--
-- if no data supplies -> returns table path node or false if not exists
--
---@param head  table   The table to which you want target
---@param tp    table   Path that you wish to check in head
---@param data  any     If supplied, attaches this data to tp tip, eg. `{"a", "b"} -> b = data`
utils.get_set_table_path = function(head, tp, data)
  if not head or not tp then
    return false
  end
  local last = #tp
  for i, p in ipairs(tp) do
    if i ~= last then
      if head[p] == nil then
        if not data then
          -- if a nil occurs, this means the path does no exist >> return
          return false
        end
        head[p] = {}
      end
      head = head[p]
    else
      if data then
        if type(data) == "function" then
          data(head[p])
        else
          head[p] = data
        end
      else
        -- print(vim.inspect(head), p)
        return head[p]
      end
    end
  end
end


return utils
