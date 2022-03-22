local utils = require("doom.utils")
local enabled_modules = require("doom.core.config.modules").modules
-- `core` is required, doom wouldn't make sense without it.

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
    doom.uses = {} -- Extra packages
    doom.cmds = {} -- Extra commands
    doom.autocmds = {} -- Extra autocommands
    doom.binds = {} -- Extra binds
    doom.modules = {} -- Modules

    -- @type PackerSpec
    -- @field 1 string Github `user/repositoryname`
    -- @field opt boolean|nil Whether or not this package is optional (loaded manually or on startup)
    -- @field commit string|nil Commit sha to pin this package to

    -- Add doom.use helper function
    -- @param  string|packer_spec PackerSpec
    doom.use_package = function(...)
      local arg = {...}
      -- Get table of packages via git repository name
      local packages_to_add = vim.tbl_map(function (t)
        return type(t) == 'string' and t or t[1]
      end, arg)

      -- Predicate returns false if the package needs to be overriden
      local package_override_predicate = function(t)
        return not vim.tbl_contains(packages_to_add, t[1])
      end

      -- Iterate over existing packages, removing all packages that are about to be overriden
      doom.uses = vim.tbl_filter(package_override_predicate, doom.uses)

      for _, packer_spec in ipairs(arg) do
        table.insert(doom.uses, type(packer_spec) == "string" and { packer_spec } or packer_spec)
      end
    end

    doom.use_keybind = function(...)
      local arg = {...}
      for _, bind in ipairs(arg) do
        table.insert(doom.binds, bind)
      end
    end

    doom.use_cmd = function(...)
      local arg = {...}
      for _, cmd in ipairs(arg) do
        if type(cmd[1] == "string") then
          doom.cmds[cmd[1]] = cmd;
        elseif cmd ~= nil then
          doom.use_cmd(unpack(cmd))
        end
      end
    end

    doom.use_autocmd = function(...)
      local arg = {...}
      for _, autocmd in ipairs(arg) do
        if type(autocmd[1]) == 'string' and type(autocmd[2]) == 'string' then
          local key = string.format('%s-%s', autocmd[1], autocmd[2])
          doom.autocmds[key] = autocmd
        elseif autocmd ~= nil then
          doom.use_autocmd(unpack(autocmd))
        end
      end
    end

    -- Combine core modules with user-enabled modules
    local all_modules = vim.tbl_deep_extend('keep', {
      core = {
        'doom',
        'nest',
        'treesitter',
      }
    }, enabled_modules)

    for section_name, section_modules in pairs(all_modules) do
      for _, module_name in pairs(section_modules) do
        -- Special case for user folder, resolves to `lua/user/modules`
        local root_folder = section_name == "user"
          and "user.modules"
          or ("doom.modules.%s"):format(section_name)

        local ok, result = xpcall(require, debug.traceback, ("%s.%s"):format(root_folder, module_name))
        if ok then
          doom.modules[module_name] = result
        else
          print(vim.inspect(result))
        end
      end
    end
  end

  -- Execute user config, log errors if any occur
  local ok, err = xpcall(dofile, debug.traceback, config.source)
  local log = require("doom.utils.logging")
  if not ok and err then
    log.error("Error while running `config.lua. Traceback:\n" .. err)
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
