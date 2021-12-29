local utils = require("doom.utils")
local enabled_modules = require("doom.core.config.modules").modules
-- `core` is required, doom wouldn't make sense without it.
if not vim.tbl_contains(enabled_modules, "core") then
  table.insert(enabled_modules, "core")
end

local config = {}
local filename = "config.lua"

-- TODO: Consider moving this to its own file.
-- {{{ Default doom_config values

config.defaults = {
  -- Pins plugins to a commit sha to prevent breaking changes
  -- @default = true
  freeze_dependencies = true,

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

  -- Enable Highlight on yank
  -- false : disables highligh on yank
  -- true  : enables highlight on yank
  -- @default = true
  highlight_yank = true,

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

  -- Default indent size
  -- @default = 4
  indent = 4,

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
  logging = "warn",

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
}

-- }}}

config.source = nil
config.load = function()
  -- Set vim defaults on first load. To override these, the user can just
  -- override vim.opt in their own config, no bells or whistles attached.
  local first_load = vim.tbl_isempty(doom or {})
  if first_load then
    vim.opt.hidden = true
    vim.opt.updatetime = 200
    vim.opt.timeoutlen = 400
    vim.opt.background = "dark"
    vim.opt.completeopt = {
      "menu",
      "menuone",
      "preview",
      "noinsert",
      "noselect",
    }
    vim.opt.shortmess = "atsc"
    vim.opt.inccommand = "split"
    vim.opt.path = "**"
    vim.opt.signcolumn = "auto:2-3"
    vim.opt.foldcolumn = "auto:9"
    vim.opt.colorcolumn = "80"
    vim.opt.formatoptions:append("j")
    vim.opt.fillchars = {
      vert = "▕",
      fold = " ",
      eob = " ",
      diff = "─",
      msgsep = "‾",
      foldopen = "▾",
      foldclose = "▸",
      foldsep = "│",
    }
    vim.opt.smartindent = true
    vim.opt.copyindent = true
    vim.opt.preserveindent = true
    vim.opt.clipboard = "unnamedplus"
    vim.opt.cursorline = true
    vim.opt.splitright = false
    vim.opt.splitbelow = true
    vim.opt.scrolloff = 4
    vim.opt.showmode = false
    vim.opt.mouse = "a"
    vim.opt.wrap = false
    vim.opt.swapfile = false
    vim.opt.number = true
    vim.opt.relativenumber = true
    vim.opt.expandtab = true
    vim.opt.conceallevel = 0
    vim.opt.foldenable = true
    vim.opt.foldtext = require("doom.core.functions").sugar_folds()
    doom = config.defaults
    doom.packages = {}
    doom.autocmds = {}
    doom.binds = {}
    for _, module in ipairs(enabled_modules) do
      local init = require(("doom.modules.%s"):format(module))
      doom[module] = init.defaults
      doom.packages = vim.tbl_extend(
        "force",
        doom.packages,
        require(("doom.modules.%s.packages"):format(module))
      )
      doom.autocmds[module] = {}
    end
  end

  dofile(config.source)

  for module, _ in pairs(doom.autocmds) do
    local ok, cmds = xpcall(require, debug.traceback, ("doom.modules.%s.autocmds"):format(module))

    if ok then
      for _, cmd in ipairs(cmds) do
        table.insert(doom.autocmds[module], cmd)
      end
    end
  end
  local module_binds = {}
  for _, module in ipairs(enabled_modules) do
    local ok, binds = xpcall(require, debug.traceback, ("doom.modules.%s.binds"):format(module))

    if ok and not vim.tbl_isempty(binds) then
      table.insert(module_binds, binds)
    end
  end
  if not vim.tbl_isempty(module_binds) then
    if not vim.tbl_isempty(doom.binds) then
      doom.binds = { module_binds, doom.binds }
    else
      doom.binds = module_binds
    end
  end

  -- If we shouldn't freeze, remove commit SHAs.
  if not doom.freeze_dependencies then
    for _, spec in pairs(doom.packages) do
      spec.commit = nil
    end
  end

  -- Check plugins updates on start if enabled.
  if doom.check_updates then
    require("doom.core.functions").check_updates()
  end

  -- These are the few vim options we wrap directly, because their usual
  -- interface is either error-prone or verbose.
  if first_load then
    vim.opt.shiftwidth = doom.indent
    vim.opt.softtabstop = doom.indent
    vim.opt.tabstop = doom.indent
    if doom.guicolors then
      if vim.fn.exists("+termguicolors") == 1 then
        vim.opt.termguicolors = true
      elseif vim.fn.exists("+guicolors") == 1 then
        vim.opt.guicolors = true
      end
    end

    if doom.auto_comment then
      vim.opt.formatoptions:append("croj")
    end
    if doom.movement_wrap then
      vim.cmd("set whichwrap+=<,>,[,],h,l")
    end

    if doom.undo_dir then
      vim.opt.undofile = true
      vim.opt.undodir = doom.undo_dir
    else
      vim.opt.undofile = false
      vim.opt.undodir = nil
    end
  end
end

-- Path cases:
--   1. stdpath('config')/../doom-nvim/config.lua
--   2. stdpath('config')/config.lua
--   3. <runtimepath>/doom-nvim/config.lua
config.source = utils.find_config(filename)

return config

-- vim: fdm=marker
