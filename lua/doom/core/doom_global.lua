-- doom.core.doom_global
--
-- Sets the `doom` global object including defaults and helper functions.
-- We set it directly within this file (rather than returning the object) and
-- setting it elsewhere to allow sumneko_lua to provide documented type
-- completions.

--- TYPE DEFINITIONS
--- @class DoomKeybindOptions
--- @field noremap boolean
--- @field silent boolean
--- @field expr boolean

--- @class DoomKeybind
--- @field [1] string Left hand side
--- @field [2] string|function|DoomKeybind[] Command or another group of Keybinds
--- @field name string Name used by whichkey and mapper to document the keybind
--- @field buffer boolean|number|nil Bind to current buffer (true) or a particular buffer (number)
--- @field mode string|nil Bind to a partcular mode (e.g. "nv" for normal + visual, defaults to "n" for normal)
--- @field options DoomKeybindOptions|nil

--- @class DoomCmd
--- @field [1] string Command name i.e. `:Test`
--- @field [2] function|string Function or command to execute

--- @class DoomAutocmd
--- @field [1] string Event
--- @field [2] string Pattern
--- @field [3] function|string Function or command to execute

--- @class DoomPackage
--- @field [1] string Repository i.e. 'tpope/vim-surround'
--- @field opt string Is package optional
--- @field cmd string|string[] Load package when command is run
--- @field disable boolean Disable plugin
--- @field as string Alias module
--- @field after string|string[] Plugin(s) to load before this plugin
--- @field branch string Git branch to use
--- @field tag string Git tag to use
--- @field commit string Git commit to use
--- @field requires DoomPackage[]|string[] Specify extra dependencies
--- @field config string|function Command or function to run after the plugin is loaded.
--- @field setup string|function Command or function to run before the plugin is loaded.

-- From here on, we have a hidden global `_doom` that holds state the user
-- shouldn't mess with.
_G._doom = {}

--- Global object
doom = {
  packages = {},
  --- Wrapper around packer.nvim `use` function
  ---
  --- Example:
  ---
  --- Can use the entire packer API
  --- doom.use_package({
  ---   'EdenEast/nightfox.nvim',
  ---   config = function()
  ---     require('nightfox').setup({
  ---       options = {
  ---         dim_inactive = false,
  ---       }
  ---     })
  ---   end
  --- })
  ---
  --- Shorthand
  --- doom.use_package(
  ---   'rafcamlet/nvim-luapad',
  ---   'nvim-treesitter/playground',
  ---   'tpope/vim-surround',
  ---   'dstein64/vim-startuptime'
  --- )
  ---@vararg DoomPackage|string|DoomPackage[] Packages to install
  use_package = function(...)
    local arg = { ... }
    -- Get table of packages via git repository name
    local packages_to_add = vim.tbl_map(function(t)
      return type(t) == "string" and t or t[1]
    end, arg)

    -- Predicate returns false if the package needs to be overriden
    local package_override_predicate = function(t)
      return not vim.tbl_contains(packages_to_add, t[1])
    end

    -- Iterate over existing packages, removing all packages that are about to be overriden
    doom.packages = vim.tbl_filter(package_override_predicate, doom.packages)

    for _, packer_spec in ipairs(arg) do
      table.insert(doom.packages, type(packer_spec) == "string" and { packer_spec } or packer_spec)
    end
  end,

  autocmds = {},

  --- Bind autocommands, takes either multiple arguments or a nested table.
  ---
  --- Example:
  ---
  --- doom.use_autocmd(
  ---   { "FileType", "lua", function() print("Just opened a lua file.") end },
  ---   {
  ---     { "FileType", "rust", function() print("Just opened a rust file") end }
  ---   }
  --- )
  ---
  --- @vararg DoomAutocmd|DoomAutocmd[] Autocommands to setup
  use_autocmd = function(...)
    local arg = { ... }
    for _, autocmd in ipairs(arg) do
      if type(autocmd[1]) == "string" and type(autocmd[2]) == "string" then
        local key = string.format("%s-%s", autocmd[1], autocmd[2])
        doom.autocmds[key] = autocmd
      elseif autocmd ~= nil then
        doom.use_autocmd(unpack(autocmd))
      end
    end
  end,

  cmds = {},

  --- Bind commands, takes either multiple arguments or a nested table
  ---
  --- Example:
  ---
  --- Use bind single
  --- doom.use_cmd( { 'Test', function() print('test') end } )
  ---
  --- Bind multiple
  --- doom.use_cmd({
  ---   { 'Test1', function() print('test1') end },
  ---   { 'Test2', function() print('test2') end },
  --- })
  ---@vararg DoomCmd|DoomCmd[] Commands to bind
  use_cmd = function(...)
    local arg = { ... }
    for _, cmd in ipairs(arg) do
      if type(cmd[1]) == "string" then
        doom.cmds[cmd[1]] = cmd
      elseif cmd ~= nil then
        doom.use_cmd(unpack(cmd))
      end
    end
  end,

  binds = {},
  --- Binds keybinds using a modified nest.nvim syntax.
  ---
  --- Example:
  ---
  --- doom.use_keybind({
  ---   { '<leader>f', name = '+files', {
  ---     { 'f', ':Telescope find_files', name = 'Find files' },
  --      { 'g', ':Telescope grep_string', name = 'Grep files' }
  ---   } },
  ---   { '<leader>o', name = '+open', {
  --      { 'f', ':!open .<CR>', name = 'Working directory'}
  ---   }}
  --- })
  ---@vararg DoomKeybind|DoomKeybind[]
  use_keybind = function(...)
    local arg = { ... }
    for _, bind in ipairs(arg) do
      table.insert(doom.binds, bind)
    end
  end,

  -- This is where modules are stored.
  -- The entire data structure will be stored in modules[module_name] = {}
  -- The key (`user` vs `modules` vs `langs`) cooresponds with the section in
  -- the user's modules.lua.
  modules = {
    core = {},
    features = {},
    langs = {},
  },
}
-- Maintain backwards compatibility + provide a shorthand way to access modules
doom.core = doom.modules.core
doom.features = doom.modules.features
doom.langs = doom.modules.langs
