-- log.lua
--
-- Inspired by rxi/log.lua
-- Modified by tjdevries and can be found at github.com/tjdevries/vlog.nvim
--
-- This library is free software; you can redistribute it and/or modify it
-- under the terms of the MIT license. See LICENSE for details.

----- CUSTOM SECTION --------------------------------------
-----------------------------------------------------------

local system = require("doom.core.system")
local round = require("doom.utils").round
-- logging defaults to "info" level
local logging_level = "info"

-- Manually load doom_config.lua to avoid circular dependencies
local ok, ret = xpcall(require, debug.traceback, "doom_config")
if ok then
  logging_level = ret.config.doom.logging or logging_level
else
  ok, ret = xpcall(dofile, debug.traceback, system.doom_configs_root .. "/doom_config.lua")
  if ok then
    logging_level = ret.config.doom.logging or logging_level
  end
end

-----------------------------------------------------------
-----------------------------------------------------------

-- User configuration section
local default_config = {
  -- Name of the plugin. Prepended to log messages
  plugin = "doom",

  -- Should print the output to neovim while running
  use_console = true,

  -- Should highlighting be used in console (using echohl)
  highlights = true,

  -- Should write to a file
  use_file = true,

  -- Any messages above this level will be logged.
  -- defaults to info
  level = logging_level,

  -- Level configuration
  modes = {
    { name = "trace", hl = "Comment" },
    { name = "debug", hl = "Comment" },
    { name = "info", hl = "None" },
    { name = "warn", hl = "WarningMsg" },
    { name = "error", hl = "ErrorMsg" },
    { name = "fatal", hl = "ErrorMsg" },
  },

  -- Can limit the number of decimals places for floats
  decimal_places = 2,
}

-- {{{ NO NEED TO CHANGE
local log = {}

local unpack = unpack or table.unpack

--- Sets up self
--- @param config table
--- @param standalone boolean
log.new = function(config, standalone)
  config = vim.tbl_deep_extend("force", default_config, config)

  local outfile = ("%s/%s.log"):format(vim.fn.stdpath("data"), config.plugin)

  local obj
  if standalone then
    obj = log
  else
    obj = {}
  end

  local levels = {}
  for i, v in ipairs(config.modes) do
    levels[v.name] = i
  end

  -- Concatenates tables into a string, handling numbers and dumping tables
  local make_string = function(...)
    local t = {}
    for i = 1, select("#", ...) do
      local x = select(i, ...)

      if type(x) == "number" and config.decimal_places then
        x = tostring(round(x, config.decimal_places))
      elseif type(x) == "table" then
        x = vim.inspect(x)
      else
        x = tostring(x)
      end

      t[#t + 1] = x
    end
    return table.concat(t, " ")
  end

  local console_output = vim.schedule_wrap(function(level_config, info, nameupper, msg)
    local console_lineinfo = vim.fn.fnamemodify(info.short_src, ":t") .. ":" .. info.currentline
    local console_string = string.format(
      "[%-6s%s] %s: %s",
      nameupper,
      os.date("%H:%M:%S"),
      console_lineinfo,
      msg
    )

    if config.highlights and level_config.hl then
      vim.cmd(string.format("echohl %s", level_config.hl))
    end

    local split_console = vim.split(console_string, "\n")
    for _, v in ipairs(split_console) do
      vim.cmd(string.format([[echom "[%s] %s"]], config.plugin, vim.fn.escape(v, '"')))
    end

    if config.highlights and level_config.hl then
      vim.cmd("echohl NONE")
    end
  end)

  local log_at_level = function(level, level_config, message_maker, ...)
    -- Return early if we're below the config.level
    if level < levels[config.level] then
      return
    end
    local nameupper = level_config.name:upper()

    local msg = message_maker(...)
    local info = debug.getinfo(2, "Sl")
    local lineinfo = info.short_src .. ":" .. info.currentline

    -- Output to console
    if config.use_console then
      console_output(level_config, info, nameupper, msg)
    end

    -- Output to log file
    if config.use_file then
      local fp = io.open(outfile, "a")
      local str = string.format("[%-6s%s] %s: %s\n", nameupper, os.date(), lineinfo, msg)
      fp:write(str)
      fp:close()
    end
  end

  for i, x in ipairs(config.modes) do
    obj[x.name] = function(...)
      return log_at_level(i, x, make_string, ...)
    end

    obj[("fmt_%s"):format(x.name)] = function()
      return log_at_level(i, x, function(...)
        local passed = { ... }
        local fmt = table.remove(passed, 1)
        local inspected = {}
        for _, v in ipairs(passed) do
          table.insert(inspected, vim.inspect(v))
        end
        return string.format(fmt, unpack(inspected))
      end)
    end
  end
end

log.new(default_config, true)
-- }}}

return log
