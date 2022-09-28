--  doom.core.config
--
--  Responsible for setting some vim global defaults, managing the `doom.field_name`
--  config options, pre-configuring the user's modules from `modules.lua`, and
--  running the user's `config.lua` file.

local utils = require("doom.utils")
local tree = require("doom.utils.tree")
local config = {}
local filename = "config.lua"

config.source = nil

--- Entry point to bootstrap doom-nvim.
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
  vim.opt.cursorline = true
  vim.opt.splitright = false
  vim.opt.splitbelow = true
  vim.opt.scrolloff = 4
  vim.opt.showmode = false
  vim.opt.mouse = "a"
  vim.opt.wrap = false
  vim.opt.swapfile = false
  vim.opt.expandtab = true
  vim.opt.conceallevel = 0
  vim.opt.foldenable = true
  vim.opt.foldtext = require("doom.core.functions").sugar_folds()

  -- Combine enabled modules (`modules.lua`) with core modules.
  tree.traverse_table({
    tree = require("doom.core.modules").enabled_modules,
    leaf = function(stack, _, module_name)
      local pc, path_concat = tree.flatten_stack(stack, module_name, ".")
      local ok, result
      local search_paths = {
        ("user.modules.%s"):format(path_concat),
        ("doom.modules.%s"):format(path_concat),
      }
      for _, path in ipairs(search_paths) do
        ok, result = xpcall(require, debug.traceback, path)
        if ok then
          break
        end
      end
      if ok then
        -- Add string tag so that we can easilly target modules later.
        result.type = "doom_module_single"
        utils.get_set_table_path(doom.modules, pc, result)
      else
        local log = require("doom.utils.logging")
        log.error(
          string.format(
            "There was an error loading module '%s'. Traceback:\n%s",
            path_concat,
            result
          )
        )
      end
    end,
  })

  -- Execute user's `config.lua` so they can modify the doom global object.
  local ok, err = xpcall(dofile, debug.traceback, config.source)
  local log = require("doom.utils.logging")
  if not ok and err then
    log.error("Error while running `config.lua. Traceback:\n" .. err)
  end

  -- Apply the necessary `doom.field_name` options
  vim.opt.shiftwidth = doom.settings.indent
  vim.opt.softtabstop = doom.settings.indent
  vim.opt.tabstop = doom.settings.indent
  if doom.settings.guicolors then
    if vim.fn.exists("+termguicolors") == 1 then
      vim.opt.termguicolors = true
    elseif vim.fn.exists("+guicolors") == 1 then
      vim.opt.guicolors = true
    end
  end

  if doom.settings.auto_comment then
    vim.opt.formatoptions:append("croj")
  end
  if doom.settings.movement_wrap then
    vim.cmd("set whichwrap+=<,>,[,],h,l")
  end

  if doom.settings.undo_dir then
    vim.opt.undofile = true
    vim.opt.undodir = doom.settings.undo_dir
  else
    vim.opt.undofile = false
    vim.opt.undodir = nil
  end

  if doom.settings.global_statusline then
    vim.opt.laststatus = 3
  end

  -- Use system clipboard
  if doom.settings.clipboard then
    vim.opt.clipboard = "unnamedplus"
  end

  if doom.ignorecase then
    vim.cmd("set ignorecase")
  else
    vim.cmd("set noignorecase")
  end
  if doom.smartcase then
    vim.cmd("set smartcase")
  else
    vim.cmd("set nosmartcase")
  end

  -- Color column
  vim.opt.colorcolumn = type(doom.settings.max_columns) == "number" and tostring(doom.settings.max_columns) or ""

  -- Number column
  vim.opt.number = not doom.settings.disable_numbering
  vim.opt.relativenumber = not doom.settings.disable_numbering and doom.settings.relative_num

  vim.g.mapleader = doom.settings.leader_key
end

-- Path cases:
--   1. stdpath('config')/../doom-nvim/config.lua
--   2. stdpath('config')/config.lua
--   3. <runtimepath>/doom-nvim/config.lua
config.source = utils.find_config(filename)

return config
