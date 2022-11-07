--- @class DoomPackageEntry
--- @field [1] string Source of package/plugin i.e "neovim/nvim-lspconfig".
--- @field on_pre_config function(callback:function)nil Add a callback to execute a function once the packages loads but before doom configures the package.
--- @field on_post_config function(callback:function)nil Add a callback to execute a function once the packages loads, after doom configures the package.

--- @alias DoomPackages table<string, DoomPackageEntry>

local DoomPackages = {}

--- Creates a new metatable for doom packages.
---@return DoomPackages
function DoomPackages.new()
  return setmetatable({}, DoomPackages)
end

function DoomPackages.__newindex(table, key, value)
  value.on_pre_config = function(handler)
    table[key].pre_config = vim.tbl_flatten({handler, table[key].pre_config or {}})
  end
  value.on_post_config = function(handler)
    table[key].post_config = vim.tbl_flatten({table[key].post_config or {}, handler})
  end
  rawset(table, key, value)
end

--- Creates a new DoomPackages object and populates it with data from the modules spec
---@param table DoomPackages
---@return DoomPackages
function DoomPackages.new_from_config(table)
  local pkg = DoomPackages.new()
  for key, spec in pairs(table) do
    pkg[key] = spec
  end
  return pkg
end

--- @class DoomModule
--- @field name string Name of the module
--- @field settings table|nil A custom table containing settings for
--- @field packages DoomPackages|nil A table of plugins / packages that this module depends upon
--- @field configs table|nil A table of configs relating to the packages, will be automatically passed into packer as the config function.
--- @field binds table|function():table|nil A table of keybinds or a function that returns a table of keybinds
--- @field cmds table|function():table|nil A Table of commands or a function that returns a table of commands
--- @field autocmds table|function():table|nil A table of auto-commands or a function that returns a table of auto-commands

local DoomModule = {}


function DoomModule.__newindex(table, key, value)
  if key == "packages" then
    rawset(table, "packages", DoomPackages.new_from_config(value))
  end
  rawset(table, key, value)
end

--- Create's a new instance of a DoomModule.
---@param name string name of the module
---@return DoomModule
function DoomModule.new(name)
  local inner = { name = name }
  return setmetatable(inner, DoomModule)
end

return {
  DoomModule = DoomModule,
}
