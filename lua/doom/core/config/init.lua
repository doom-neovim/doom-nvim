---[[------------------------------]]---
--     config - Core of Doom Nvim     --
--        Author: NTBBloodbath        --
--           License: GPLv2           --
---[[------------------------------]]---

local config = {}

local log = require("doom.extras.logging")
local system = require("doom.core.system")

log.debug("Loading Doom config module ...")

-- Check if running Neovim or Vim and fails if:
-- 1. Running Vim instead of Neovim
-- 2. Running Neovim 0.4 or below
if vim.fn.has("nvim") == 1 then
  if vim.fn.has("nvim-0.5") ~= 1 then
    log.fatal("Doom Nvim requires Neovim 0.5.0, please update it")
  end
else
  log.fatal("Doom Nvim does not have support for Vim, please use it with Neovim instead")
end

-- Set termguicolors on load
if vim.fn.has("vim_starting") then
  vim.opt.termguicolors = true
end

-- {{{ Default doom_config values

config.config = {
  -- {{{ Doom
  doom = {
    -- Autosave
    -- false : Disable autosave
    -- true  : Enable autosave
    -- @default = false
    autosave = false,

    -- Format on save
    -- false : Disable format on save
    -- true  : Enable format on save
    -- @default = false
    fmt_on_save = false,

    -- Disable Vim macros
    -- false : Enable Vim macros
    -- true  : Disable Vim macros
    -- @default = false
    disable_macros = false,

    -- Autosave sessions
    -- false : Disable session autosave
    -- true  : Enable session autosave
    -- @default = false
    autosave_sessions = false,

    -- Autoload sessions
    -- false : Disable session autoload
    -- true  : Enable session autoload
    -- @default = false
    autoload_last_session = false,

    -- Enable Swap files
    -- false : no swap files
    -- true  : enables swap files
    -- @default = false
    swap_files = false,

    -- Undo Directories
    -- the backup variable enables backup related settings (undofile, undodir)
    -- false : ignores undo Directories (this code block will be ignored)
    -- true  : enable undo files/undo dirs.
    -- @default = false
    -- WARNING: if you change this to false and you have an undo dir already,
    --          it will REMOVE the undodir (loss of data might take place)
    backup = false,

    -- Enable Line wrapping
    -- false : disables line wrapping
    -- true  : enables line wrapping
    -- @default = false
    line_wrap = false,

    -- Enable Show mode ( -- INSERT --, -- NORMAL --, -- VISUAL -- )
    -- false : disables show mode
    -- true  : enables show mode
    -- @default = false
    show_mode = false,

    -- Enable scroll off
    -- false : disables scroll off
    -- true  : enables scroll off
    -- @default = true, @default scrolloff_amount = 4,
    scrolloff = true,
    scrolloff_amount = 4,

    -- Enable mouse
    -- false : disables mouse
    -- true  : enables mouse
    -- @default = true
    mouse = true,

    -- Preserve last editing position
    -- false : Disable preservation of last editing position
    -- true  : Enable preservation of last editing position
    -- @default = false
    preserve_edit_pos = false,

    -- Allow overriding the default Doom Nvim keybinds
    -- false : Default keybinds cannot be overwritten
    -- true  : Default keybinds can be overwritten
    -- @default = true
    allow_default_keymaps_overriding = true,

    -- horizontal split on creating a new file (<Leader>fn)
    -- false : doesn't split the window when creating a new file
    -- true  : horizontal split on creating a new file
    -- @default = true
    new_file_split = true,

    -- enable current line highlight
    -- false : disables current line highlight
    -- true  : enables current line highlight
    -- @default = true
    line_highlight = true,

    -- Automatically split right
    -- false : splits right (vertically)
    -- true  : splits left (vertically)
    -- @default = true
    split_right = true,

    -- Automatically split above
    -- false : splits above (horizontally)
    -- true  : splits below (horizontally)
    -- @default = true
    split_below = true,

    -- Use clipboard outside of vim
    -- false : won't use third party clipboard
    -- true  : enables third part clipboard
    -- @default = true
    clipboard = true,

    -- Enable auto comment (current line must be commented)
    -- false : disables auto comment
    -- true  : enables auto comment
    -- @default = false
    auto_comment = false,

    -- Show indent lines
    -- @default = true
    show_indent = true,

    -- Expand tabs
    -- Specifies if spaces or tabs must be used
    -- false : spaces
    -- true  : tabs
    -- @default = true
    expand_tabs = true,

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

    -- Enable winwidth
    -- false : Manually set win width
    -- true  : Active window auto sets width
    -- @default = false, @default win_width_nr = 85
    win_width = false,
    win_width_nr = 85,

    -- Enable Highlight on yank
    -- false : disables highligh on yank
    -- true  : enables highlight on yank
    -- @default = true
    highlight_yank = true,

    -- Enable guicolors
    -- Enables gui colors on GUI versions of Neovim
    -- @default = true
    enable_guicolors = true,

    -- Tree explorer on the right
    -- Places the Tree explorer buffer to the right when enabled
    -- @default = false
    explorer_right = false,

    -- Show hidden files
    -- @default = true
    show_hidden = true,

    -- Checkupdates on start
    -- @default = false
    check_updates = false,

    -- Auto install plugins on launch, useful if you don't want to run
    -- PackerInstall every time you add a new plugin
    -- @default = true
    auto_install_plugins = true,

    -- Disable dashboard status line (does not work perfectly)
    -- false : disables dashboard status line
    -- true  : enables dashboard status line
    -- @default = true
    dashboard_statline = true,

    -- Show the editing file path in your status line
    -- false : show only file name on status line
    -- true  : show file name and the updir in status line
    statusline_show_file_path = true,

    -- Set the keybindings modules that you want to use
    -- false : disables keybindings module
    -- true  : enables keybindings module
    keybinds_modules = {
      -- Core doom keybindings
      core = true,
      -- Movement keybindings, jump between your windows, buffers and code
      movement = true,
      -- Leader keybindings, a bunch of useful keybindings managed by space key
      -- WARNING: disabling this will break which-key plugin if the plugin is enabled
      leader = true,
      -- Completion and snippets keybindings
      completion = true,
    },

    -- sequences used for escaping insert mode
    -- @default = { 'jk', 'kj' }
    escape_sequences = { "jk", "kj" },

    -- Disable or enable Doom autocommands, this can break some configuration options (they will stop working)
    -- e.g. preserve_edit_pos or autosave
    --
    -- false : enable autocommands module
    -- true  : disable autocommands module
    -- @default = false
    disable_autocommands = false,

    -- Enable LSP diagnostics virtual text
    -- @default = false
    enable_lsp_virtual_text = false,

    -- Use floating windows for plugins manager (packer) operations
    -- @default = false
    use_floating_win_packer = false,

    -- Default indent size
    -- @default = 4
    indent = 4,

    -- Set max cols
    -- Defines the column to show a vertical marker
    -- @default = 80
    max_columns = 80,

    -- Completion box height
    -- @default = 10
    complete_size = 10,

    -- Completion box transparency
    -- 0 = no transparency
    -- 100 = fully transparent
    -- @default = 25
    complete_transparency = 25,

    -- Sidebar sizing
    -- Specifies the default width of Tree Explorer and Tagbar
    -- @default = 25
    sidebar_width = 25,

    -- Set the Terminal width
    -- Applies only to float direction
    -- @default = 70
    terminal_width = 70,

    -- Set the Terminal height
    -- Applies to all directions except window
    -- @default = 20
    terminal_height = 20,

    -- Conceal level
    -- Set Neovim conceal level
    -- 0 : Disable indentline and show all
    -- 1 : Conceal some functions and show indentlines
    -- 2 : Concealed text is completely hidden unless it has a custom replacement
    --     character defined
    -- 3 : Concealed text is completely hidden
    conceallevel = 0,

    -- Logging level
    -- Set Doom logging level
    -- Available levels:
    --   · trace
    --   · debug
    --   · info
    --   · warn
    --   · error
    --   · fatal
    -- @default = 'info'
    logging = "info",

    -- Set the Terminal direction
    -- Available directions:
    --   - vertical
    --   - horizontal
    --   - window
    --   - float
    -- @default = 'horizontal'
    terminal_direction = "horizontal",

    -- NOTE: This will only be activated if 'backup' is true.
    -- We don'recommend you put this outside of neovim so we've restricted to the path: ~/.config/nvim
    -- WARNING: only put the folder name that you want. (eg: undo_dir = '/undodir')
    -- @default_directory = '~/.config/nvim/undodir'
    undo_dir = "/undodir",

    -- Default colorscheme
    -- @default = doom-one
    colorscheme = "doom-one",

    -- Background color
    -- @default = dark
    colorscheme_bg = "dark",

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

    -- Set gui fonts here
    -- @default = "FiraCode Nerd Font", @default font size = 15,
    -- WARNING: Font sizes must be in string format!
    guifont = "FiraCode Nerd Font",
    guifont_size = "15",

    -- Change Which Key background color
    -- can use hex, or normal color names (eg: Red, Gree, Blue)
    -- @default = #202328
    whichkey_bg = "#202328",

    -- Set your custom lsp diagnostic symbols below
    lsp_error = "",
    lsp_warn = "",
    lsp_hint = "",
    lsp_info = "",
    lsp_virtual_text = " ",

    -- Set your linters for the programming languages that you use,
    -- see https://github.com/mfussenegger/nvim-lint#available-linters
    linters = {
      c = {},
      cpp = {},
      css = {},
      html = {},
      javascript = {},
      lua = {},
      markdown = {},
      nix = {},
      python = {},
      ruby = {},
      sh = {},
      typescript = {},
    },

    -- Set your dashboard custom colors below
    -- @default = doom emacs' default dashboard colors
    dashboard_custom_colors = {
      header_color = "#586268",
      center_color = "#51afef",
      shortcut_color = "#a9a1e1",
      footer_color = "#586268",
    },

    -- Set your custom dashboard header below
    -- @default = doom emacs' default dashboard header
    dashboard_custom_header = {},
  },
  -- }}}

  -- {{{ Nvim
  nvim = {
    -- Set custom Neovim global variables
    -- @default = {}
    -- example:
    --   {
    --     ['sonokai_style'] = 'andromeda',
    --     ['modelineexpr'] = true,
    --   }
    --
    --   modeline feature was turned off to reduce security exploit surfaces.
    --   Since modeline now uses whitelist approach since nvim 0.4 /vim 8.1,
    --   enabling this is as safe as external packages such as securemodelines.
    --   See https://github.com/neovim/neovim/issues/2865
    --
    global_variables = {},

    -- Set custom autocommands
    -- @default = {}
    -- example:
    --   augroup_name = {
    --      { 'BufNewFile,BufRead', 'doom_modules.lua', 'set ft=lua'}
    --   }
    autocmds = {},

    -- Set custom key bindings
    -- @default = {}
    -- example:
    --   {
    --      {'n', 'ca', ':Lspsaga code_action<CR>', options}
    --   }
    --
    --   where
    --     'n' is the map scope
    --     'ca' is the map activator
    --     ':Lspsaga ...' is the command to be executed
    --     options is a Lua table containing the mapping options, e.g.
    --     { silent = true }, see ':h map-arguments'.
    mappings = {},

    -- Set custom commands
    -- @default = {}
    -- example:
    --   {
    --      'echo "Hello, custom commands!"'
    --   }
    commands = {},

    -- Set custom functions
    -- @default = {}
    -- example:
    --   {
    --      {
    --         hello_custom_func = function()
    --           print("Hello, custom functions!")
    --         end,
    --         -- If the function should be ran on neovim launch or if it should
    --         -- be a global function accesible from anywhere
    --         run_on_start = false,
    --      },
    --   }
    functions = {},

    -- Set custom options
    -- @default = {}
    -- example:
    --   {
    --      { ['shiftwidth'] = 4 }
    --   }
    options = {},
  },
  -- }}}
}

-- }}}

config.source = nil

log.debug("Loading Doom config module ...")

-- Path cases:
--   1. /home/user/.config/doom-nvim/doom_config.lua
--   2. stdpath('config')/doom_config.lua
--   3. <runtimepath>/doom_config.lua
local ok, ret = xpcall(dofile, debug.traceback, system.doom_configs_root .. "/doom_config.lua")
if ok then
  config.config = ret.config
  config.source = ret.source
else
  ok, ret = xpcall(dofile, debug.traceback, system.doom_root .. "/doom_config.lua")
  if ok then
    config.config = ret.config
    config.source = ret.source
  else
    ok, ret = xpcall(require, debug.traceback, "doom_config")
    if ok then
      config.config = ret.config
      config.source = ret.source
    else
      log.error("Error while loading doom_config.lua. Traceback:\n" .. ret)
    end
  end
end

-- Check plugins updates on start if enabled
if config.config.doom.check_updates then
  require("doom.core.functions").check_updates()
end

return config

-- vim: fdm=marker
