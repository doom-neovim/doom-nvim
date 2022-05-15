local utils = {}

local system = require("doom.core.system")
local fs = require("doom.utils.fs")

--- Doom Nvim version
utils.version = {
  major = 4,
  minor = 0,
  patch = 0,
}
utils.doom_version = string.format("%d.%d.%d", utils.version.major, utils.version.minor, utils.version.patch)

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
utils.safe_require = function (path)
  local log = require("doom.utils.logging")
  log.debug(string.format("Doom: loading '%s'... ", path))
  local ok, result = xpcall(require, debug.traceback, path)
  if not ok and result then
      log.error(
        string.format(
          "There was an error requiring '%s'. Traceback:\n%s",
          path,
          result
        )
      )
    return nil
  else
    log.debug(string.format("Successfully loaded '%s' module", path))
    return result
  end
end

--- Stores a function in a global table, returns a string to execute the function
-- @param  fn function
-- @return string
utils.commandify_function = function(fn)
  if not _G._doom then
    _G._doom = {}
  end
  if not _doom.cmd_funcs then
    _doom.cmd_funcs = {}
  end
  -- Nobody is going to need more than a million of these, right?
  local unique_number = utils.unique_index()
  _doom.cmd_funcs[unique_number] = fn
  return ("lua _doom.cmd_funcs[%d]()"):format(unique_number)
end

--- Creates a new command that can be executed from the neovim command line
-- @param  cmd_name string The name of the command, i.e. `:DoomReload`
-- @param  action string|function The action to execute when the cmd is entered.
utils.make_cmd = function(cmd_name, action)
  local cmd = "command! " .. cmd_name .. " "
  cmd = type(action) == "function"
    and cmd .. utils.commandify_function(action)
    or cmd .. action
    vim.cmd(cmd)
end

utils.make_autocmd = function(event, pattern, action, group, nested, once)
  local cmd = "autocmd "

  if group then
    cmd = cmd .. group .. " "
  end

  cmd = cmd .. event .. " "
  cmd = cmd .. pattern .. " "

  if nested then
    cmd = cmd .. "++nested "
  end
  if once then
    cmd = cmd .. "++once "
  end

  cmd = type(action) == "function"
    and cmd .. utils.commandify_function(action)
    or cmd .. action

  vim.cmd(cmd)
end

utils.make_augroup = function(group_name, cmds, existing_group)
  if not existing_group then
    vim.cmd("augroup " .. group_name)
    vim.cmd("autocmd!")
  end

  for _, cmd in ipairs(cmds) do
    utils.make_autocmd(cmd[1], cmd[2], cmd[3], existing_group and group_name, cmd.nested, cmd.once)
  end

  if not existing_group then
    vim.cmd("augroup END")
  end
end

utils.get_sysname = function ()
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
--- @param plugin string The plugin identifier, e.g. statusline
--- @return boolean
utils.is_module_enabled = function(plugin)
  local modules = require("doom.core.modules").enabled_modules

  -- Iterate over all modules sections (e.g. ui) and their plugins
  for _, section in pairs(modules) do
    if vim.tbl_contains(section, plugin) then
      return true
    end
  end

  return false
end

local modules_list_cache = {}

utils.get_all_modules_as_list = function()
  if doom then
    if #modules_list_cache ~= 0 then
      return modules_list_cache
    end
    local all_modules = {}
    for section_name, _ in pairs(doom.modules) do
      for k, module in pairs(doom[section_name]) do
        all_modules[k] = module
        all_modules[k].name = section_name
      end
    end
    modules_list_cache = table.sort(all_modules, function (a, b)
      return (a.priority or 100) < (b.priority or 100)
    end)
    return modules_list_cache
  end
  return nil
end

utils.clear_module_cache = function()
  modules_list_cache = {}
end

--- Returns a function that can only be run once
---@param fn function
---@return function
utils.make_run_once_function = function(fn)
  local has_run = false
  return function(...)
    if not has_run then
      fn(...)
      has_run = true
    end
  end
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

--- Returns an iterator over the string str whose next function returns until
--- the next sep is reached.
--- @param str string String to iterate over
--- @param sep string Separator to look for
--- @return fun(string, string),string,string
utils.iter_string_at = function(str, sep)
  return string.gmatch(str, "([^" .. sep .. "]+)")
end

utils.get_modules_flat_with_meta_data = function()
  local config_path = vim.fn.stdpath("config")

  local function glob_modules(cat)
    if cat ~= "doom" and cat ~= "user" then return end
    local glob = config_path .. "/lua/"..cat.."/modules/*/*/"
    return vim.split(vim.fn.glob(glob), "\n")
  end
  local function get_all_module_paths()
    local glob_doom_modules = glob_modules("doom")
    local glob_user_modules = glob_modules("user")
    local all = glob_doom_modules
    for _, p in ipairs(glob_user_modules) do
      table.insert(all, p)
    end
    return all
  end

  local all_m = get_all_module_paths()

  local prep_all_m = { doom = {}, user = {} }

  for _, p in ipairs(all_m) do
    local m_origin, m_section, m_name =  p:match("/([_%w]-)/modules/([_%w]-)/([_%w]-)/$") -- capture only dirname
    if prep_all_m[m_origin][m_section] == nil then
      prep_all_m[m_origin][m_section] = {}
    end
    prep_all_m[m_origin][m_section][m_name] = {
      enabled = false,
      name = m_name,
      section = m_section,
      origin = m_origin,
      path = p
    }
  end

  local enabled_modules = require("doom.core.modules").enabled_modules
  local all_modules = vim.tbl_deep_extend("keep", {
    core = {
      'doom',
      'nest',
      'treesitter',
      'reloader',
    }
  },enabled_modules)



  for section_name, section_modules in pairs(all_modules) do
    for _, module_name in pairs(section_modules) do
      local search_paths = {
        ("user.modules.%s.%s"):format(section_name, module_name),
        ("doom.modules.%s.%s"):format(section_name, module_name)
      }
      for _, path in ipairs(search_paths) do
        local origin = path:sub(1,4)

        if prep_all_m[origin][section_name] ~= nil then
          if prep_all_m[origin][section_name][module_name] ~= nil then
            prep_all_m[origin][section_name][module_name].enabled = true
              for k, v in pairs(doom[section_name][module_name]) do
                prep_all_m[origin][section_name][module_name][k] = v
              end
            break;
          end
        end
      end
    end
  end

 return prep_all_m
end

utils.get_buf_handle = function(path)
  local buf
  if path ~= nil then
    buf = vim.uri_to_bufnr(vim.uri_from_fname(path))
  else
    buf = vim.api.nvim_get_current_buf()
  end
  return buf
end

return utils
