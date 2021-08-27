---[[---------------------------------------]]---
--        settings - Doom Nvim settings        --
--             Author: NTBBloodbath            --
--             License: GPLv2                  --
---[[---------------------------------------]]---

local functions = require("doom.core.functions")
local log = require("doom.extras.logging")
local config = require("doom.core.config").load_config()

local M = {}

log.debug("Loading Doom defaults module ...")

-- load_default_options sets and loads default Neovim options based on doomrc values
M.load_default_options = function()
  ----- Default Neovim configurations
  -- Set colorscheme
  vim.cmd("colorscheme " .. config.doom.colorscheme)
  vim.opt.background = config.doom.colorscheme_bg
  vim.cmd("highlight WhichKeyFloat guibg=" .. config.doom.whichkey_bg)

  -- Global options
  vim.opt.hidden = true
  vim.opt.updatetime = 200
  vim.opt.timeoutlen = 500
  vim.opt.completeopt = {
    "menu",
    "menuone",
    "preview",
    "noinsert",
    "noselect",
  }
  vim.opt.shortmess:append("atsc")
  vim.opt.inccommand = "split"
  vim.opt.path = "**"
  vim.opt.signcolumn = "yes"

  -- Buffer options
  vim.opt.smartindent = true
  vim.opt.copyindent = true
  vim.opt.preserveindent = true

  -- set Gui Fonts
  vim.opt.guifont = config.doom.guifont .. ":h" .. config.doom.guifont_size

  -- Use clipboard outside vim
  if config.doom.clipboard then
    vim.opt.clipboard = "unnamedplus"
  end

  if config.doom.line_highlight then
    vim.opt.cursorline = true
  else
    vim.opt.cursorline = false
  end

  -- Automatic split locations
  if config.doom.split_right then
    vim.opt.splitright = true
  else
    vim.opt.splitright = false
  end

  if config.doom.split_below then
    vim.opt.splitbelow = true
  else
    vim.opt.splitbelow = false
  end

  -- Enable scroll off
  if config.doom.scrolloff then
    vim.opt.scrolloff = config.doom.scrolloff_amount
  end

  -- Enable showmode
  if not config.doom.show_mode then
    vim.opt.showmode = false
  else
    vim.opt.showmode = true
  end

  -- Enable mouse input
  if config.doom.mouse then
    vim.opt.mouse = "a"
  end

  -- Enable wrapping
  if not config.doom.line_wrap then
    vim.opt.wrap = false
  else
    vim.opt.wrap = true
  end

  -- Enable swap files
  if not config.doom.swap_files then
    vim.opt.swapfile = false
  else
    vim.opt.swapfile = true
  end

  -- Set numbering
  if config.doom.relative_num then
    vim.opt.number = true
    vim.opt.relativenumber = true
  else
    vim.opt.number = true
  end

  -- Enable winwidth
  if config.doom.win_width then
    vim.opt.winwidth = config.doom.win_width_nr
  end

  -- Checks to see if undo_dir does not exist. If it doesn't, it will create a undo folder
  local undo_dir = vim.fn.stdpath("data") .. config.doom.undo_dir
  if config.doom.backup and vim.fn.empty(vim.fn.glob(undo_dir)) >= 0 then
    if vim.fn.isdirectory(undo_dir) ~= 1 then
      vim.api.nvim_command("!mkdir -p " .. undo_dir)
    end
    vim.opt.undofile = true
  end

  -- If backup is false but `undo_dir` still exists then it will delete it.
  if not config.doom.backup and vim.fn.empty(vim.fn.glob(undo_dir)) == 0 then
    vim.api.nvim_command("!rm -rf " .. undo_dir)
    vim.opt.undofile = false
  end

  -- Set local-buffer options
  if config.doom.expand_tabs then
    vim.opt.expandtab = true
  else
    vim.opt.expandtab = false
  end
  vim.opt.tabstop = config.doom.indent
  vim.opt.shiftwidth = config.doom.indent
  vim.opt.softtabstop = config.doom.indent
  vim.opt.colorcolumn = tostring(config.doom.max_columns)
  vim.opt.conceallevel = config.doom.conceallevel
end

-- Custom Doom Nvim commands
M.custom_options = function()
  -- Set a custom command to update Doom Nvim
  -- can be called by using :DoomUpdate
  vim.cmd('command! DoomUpdate lua require("doom.core.functions").update_doom()')
  -- Set a custom command to rollback Doom Nvim version
  -- can be called by using :DoomRollback
  vim.cmd('command! DoomRollback lua require("doom.core.functions").rollback_doom()')

  -- Load user-defined settings from the Neovim field in the doomrc file
  functions.load_custom_settings(config.nvim.autocmds, "autocmds")
  functions.load_custom_settings(config.nvim.commands, "commands")
  functions.load_custom_settings(config.nvim.functions, "functions")
  functions.load_custom_settings(config.nvim.mappings, "mappings")
  functions.load_custom_settings(config.nvim.global_variables, "variables")
  functions.load_custom_settings(config.nvim.options, "options")
end

return M
