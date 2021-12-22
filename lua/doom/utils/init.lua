local utils = {}

local system = require("doom.core.system")
local fs = require("doom.utils.fs")

--- Doom Nvim version
utils.doom_version = "4.0.0-alpha1"

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

--- Load the specified Lua modules
--- @param module_path string The path to Lua modules, e.g. 'doom' → 'lua/doom'
--- @param mods table The modules that we want to load
utils.load_modules = function(module_path, mods)
  local log = require("doom.utils.logging")
  for i = 1, #mods, 1 do
    log.debug(string.format("Loading '%s.%s' module", module_path, mods[i]))
    local ok, err = xpcall(require, debug.traceback, string.format("%s.%s", module_path, mods[i]))
    if not ok then
      log.error(
        string.format(
          "There was an error loading the module '%s.%s'. Traceback:\n%s",
          module_path,
          mods[i],
          err
        )
      )
    else
      log.debug(string.format("Successfully loaded '%s.%s' module", module_path, mods[i]))
    end
  end
end

--- Helper to attach illuminate on LSP
utils.illuminate_attach = function(client)
  require("illuminate").on_attach(client)
  -- Set underline highlighting for Lsp references
  vim.cmd("hi! LspReferenceText cterm=underline gui=underline")
  vim.cmd("hi! LspReferenceWrite cterm=underline gui=underline")
  vim.cmd("hi! LspReferenceRead cterm=underline gui=underline")
end

--- Get LSP capabilities for DOOM
utils.get_capabilities = function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.preselectSupport = true
  capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
  capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
  capabilities.textDocument.completion.completionItem.deprecatedSupport = true
  capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
  capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = { "documentation", "detail", "additionalTextEdits" },
  }
  capabilities.textDocument.codeAction = {
    dynamicRegistration = false,
    codeActionLiteralSupport = {
      codeActionKind = {
        valueSet = {
          "",
          "quickfix",
          "refactor",
          "refactor.extract",
          "refactor.inline",
          "refactor.rewrite",
          "source",
          "source.organizeImports",
        },
      },
    },
  }

  return capabilities
end

--- For autocommands, extracted from
--- https://github.com/norcalli/nvim_utils
--- @param definitions table<string, table<number, string>>
utils.create_augroups = function(definitions)
  for group_name, definition in pairs(definitions) do
    vim.cmd("augroup " .. group_name)
    vim.cmd("autocmd!")
    for _, def in ipairs(definition) do
      local command = table.concat(vim.tbl_flatten({ "autocmd", def }), " ")
      vim.cmd(command)
    end
    vim.cmd("augroup END")
  end
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
  if vim.fn.has("nvim-0.6") == 1 then
    return vim.tbl_count(vim.diagnostic.get(bufnr, {
      severity = severity,
    }))
  else
    return vim.lsp.diagnostic.get_count(bufnr, severity)
  end
end

--- Search if a table have the key we are looking for,
--- useful for plugins management
--- @param tabl table
--- @param key string
--- @return boolean
utils.has_key = function(tabl, key)
  for k, _ in pairs(tabl) do
    if k == key then
      return true
    end
  end

  return false
end

--- Check if the given plugin is disabled in doom-nvim/modules.lua
--- @param plugin string The plugin identifier, e.g. statusline
--- @return boolean
utils.is_plugin_disabled = function(plugin)
  local modules = require("doom.core.config.modules").modules

  -- Iterate over all modules sections (e.g. ui) and their plugins
  if vim.tbl_contains(modules, plugin) then
    return false
  end

  return true
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

return utils
