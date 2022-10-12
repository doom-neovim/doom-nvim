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
  -- Use the global statusline
  -- @default = true
  global_statusline = true,

  -- Leader key for keybinds
  -- @default = ' '
  leader_key = " ",

  -- Pins plugins to a commit sha to prevent breaking changes
  -- @default = true
  freeze_dependencies = true,

  -- Enables impatent.nvim caching to speed up start time.
  -- Can cause more issues so disabled by default
  -- @default false
  impatient_enabled = false,

  -- Autosave
  -- false : Disable autosave
  -- true  : Enable autosave
  -- @default = false
  autosave = false,

  -- Disable Vim macros
  -- false : Enable
  -- true  : Disable
  -- @default = false
  disable_macros = false,

  -- Disable ex mode
  -- false : Enable
  -- true  : Disable
  -- @default = false
  disable_ex = true,

  -- Disable suspension
  -- false : Enable
  -- true  : Disable
  -- @default = false
  disable_suspension = true,

  -- Set numbering
  -- false : Enable  number lines
  -- true  : Disable number lines
  -- @default = false
  disable_numbering = false,

  -- Set numbering style
  -- false : Shows absolute number lines
  -- true  : Shows relative number lines
  -- @default = true
  relative_num = true,

  -- h,l, wrap lines
  movement_wrap = true,

  -- Undo directory (set to nil to disable)
  -- @default = vim.fn.stdpath("data") .. "/undodir/"
  undo_dir = vim.fn.stdpath("data") .. "/undodir/",

  -- Set preferred border style across UI
  border_style = "single",

  -- Preserve last editing position
  -- false : Disable preservation of last editing position
  -- true  : Enable preservation of last editing position
  -- @default = false
  preserve_edit_pos = false,

  -- horizontal split on creating a new file (<Leader>fn)
  -- false : doesn't split the window when creating a new file
  -- true  : horizontal split on creating a new file
  -- @default = true
  new_file_split = "vertical",

  -- Enable auto comment (current line must be commented)
  -- false : disables auto comment
  -- true  : enables auto comment
  -- @default = false
  auto_comment = false,

  -- Ignore case in a search pattern
  -- false : search is sensitive
  -- true  : search is insensitive
  -- @default = false
  ignorecase = false,

  -- Override the 'ignorecase' option if the search pattern contains upper case
  -- characters. Only used when the search pattern is typed and 'ignorecase'
  -- option is on.
  -- false : don't override the 'ignorecase' option
  -- true  : override the 'ignorecase' option is upper case characters is in search pattern
  -- @default = false
  smartcase = false,

  -- Enable Highlight on yank
  -- false : disables highligh on yank
  -- true  : enables highlight on yank
  -- @default = true
  highlight_yank = true,

  -- Use clipboard outside of vim
  -- false : won't use third party clipboard
  -- true  : enables third part clipboard
  -- @default = true
  clipboard = true,

  -- Enable guicolors
  -- Enables gui colors on GUI versions of Neovim
  -- @default = true
  guicolors = true,

  -- Show hidden files
  -- @default = true
  show_hidden = true,

  -- Hide files listed in .gitignore from file browsers
  -- @default = true
  hide_gitignore = true,

  -- Checkupdates on start
  -- @default = false
  check_updates = false,

  -- sequences used for escaping insert mode
  -- @default = { 'jk', 'kj' }
  escape_sequences = { "jk", "kj" },

  -- Use floating windows for plugins manager (packer) operations
  -- @default = false
  use_floating_win_packer = false,

  -- Set max cols
  -- Defines the column to show a vertical marker
  -- Set to false to disable
  -- @default = 80
  max_columns = 80,

  -- Default indent size
  -- @default = 4
  indent = 4,

  -- Logging level
  -- Set Doom logging level
  -- @default = "info"
  --- @type "trace"|"debug"|"info"|"warn"|"error"|"fatal"
  logging = "info",

  -- Default colorscheme
  -- @default = doom-one
  colorscheme = "doom-one",

  -- Doom One colorscheme settings
  doom_one = {
    -- If the cursor color should be blue
    -- @default = false
    cursor_coloring = false,
    -- If TreeSitter highlighting should be enabled
    -- @default = true
    enable_treesitter = true,
    -- If the comments should be italic
    -- @default = false
    italic_comments = false,
    -- If the telescope plugin window should be colored
    -- @default = true
    telescope_highlights = true,
    -- If the built-in Neovim terminal should use the doom-one
    -- colorscheme palette
    -- @default = false
    terminal_colors = true,
    -- If the Neovim instance should be transparent
    -- @default = false
    transparent_background = false,
  },

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
