--  doom.core.config
--
--  Responsible for setting some vim global defaults, managing the `doom.field_name`
--  config options, pre-configuring the user's modules from `modules.lua`, and
--  running the user's `config.lua` file.


local profiler = require("doom.services.profiler")
local utils = require("doom.utils")
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
  local enabled_modules = require("doom.core.modules").enabled_modules

  profiler.start("framework|import modules")
  -- Iterate over each module and save it to the doom global object
  for section_name, section_modules in pairs(enabled_modules) do
    for _, module_name in pairs(section_modules) do
      -- If the section is `user` resolves from `lua/user/modules`
      local profiler_message = ("modules|import `%s.%s`"):format(section_name, module_name)
      profiler.start(profiler_message)
      local search_paths = {
        ("user.modules.%s.%s"):format(section_name, module_name),
        ("doom.modules.%s.%s"):format(section_name, module_name),
      }

      local ok, result
      for _, path in ipairs(search_paths) do
        ok, result = xpcall(require, debug.traceback, path)
        if ok then
          break
        end
      end
      if ok then
        doom[section_name][module_name] = result
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
      profiler.stop(profiler_message)
    end
  end
  profiler.stop("framework|import modules")

  profiler.start("framework|config.lua (user)")
  -- Execute user's `config.lua` so they can modify the doom global object.
  local ok, err = xpcall(dofile, debug.traceback, config.source)
  local log = require("doom.utils.logging")
  if not ok and err then
    log.error("Error while running `config.lua. Traceback:\n" .. err)
  end
  profiler.stop("framework|config.lua (user)")

  -- Apply the necessary `doom.field_name` options
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

  if doom.global_statusline then
    vim.opt.laststatus = 3
  end

  -- Use system clipboard
  if doom.clipboard then
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
  vim.opt.colorcolumn = type(doom.max_columns) == "number" and tostring(doom.max_columns) or ""

  -- Number column
  vim.opt.number = not doom.disable_numbering
  vim.opt.relativenumber = not doom.disable_numbering and doom.relative_num

  vim.g.mapleader = doom.leader_key
end

-- Path cases:
--   1. stdpath('config')/../doom-nvim/config.lua
--   2. stdpath('config')/config.lua
--   3. <runtimepath>/doom-nvim/config.lua
config.source = utils.find_config(filename)

return config
