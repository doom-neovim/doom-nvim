local utils = require("doom.utils")
-- `core` is required, doom wouldn't make sense without it.

local config = {}
local filename = "config.lua"

require('doom.core.config.globals')

config.source = nil
config.load = function()
  -- Set vim defaults on first load. To override these, the user can just
  -- override vim.opt in their own config, no bells or whistles attached.
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
  -- Combine core modules with user-enabled modules
  local enabled_modules = require("doom.core.config.modules").modules
  local all_modules = vim.tbl_deep_extend('keep', {
    core = {
      'doom',
      'nest',
      'treesitter',
      'reloader',
    }
  },enabled_modules)

  for section_name, section_modules in pairs(all_modules) do
    for _, module_name in pairs(section_modules) do
      -- print(("Addign module %s.%s"):format(section_name, module_name))
      -- Special case for user folder, resolves to `lua/user/modules`
      local root_folder = section_name == "user"
        and "user.modules"
        or ("doom.modules.%s"):format(section_name)

      local ok, result = xpcall(require, debug.traceback, ("%s.%s"):format(root_folder, module_name))
      if ok then
        doom.modules[module_name] = result
      else
        local log = require("doom.utils.logging")
        log.error(
          string.format(
            "There was an error loading module '%s.%s'. Traceback:\n%s",
            section_name,
            module_name,
            result
          )
        )
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

-- Path cases:
--   1. stdpath('config')/../doom-nvim/config.lua
--   2. stdpath('config')/config.lua
--   3. <runtimepath>/doom-nvim/config.lua
config.source = utils.find_config(filename)

return config

-- vim: fdm=marker
