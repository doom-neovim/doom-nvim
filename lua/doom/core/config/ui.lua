---[[---------------------------------------]]---
--       ui.lua - Doom Nvim UI settings        --
--             Author: NTBBloodbath            --
--             License: GPLv2                  --
---[[---------------------------------------]]---

local utils = require("doom.utils")
local log = require("doom.extras.logging")
local config = require("doom.core.config").config

log.debug("Loading Doom UI module ...")

-- If no colorscheme was established then fallback to defauls
if not utils.is_empty(config.doom.colorscheme) then
  local loaded_colorscheme = xpcall(function()
    vim.opt.background = config.doom.colorscheme_bg
    vim.api.nvim_command("colorscheme " .. config.doom.colorscheme)
  end, debug.traceback)

  if not loaded_colorscheme then
    log.warn("Colorscheme '" .. config.doom.colorscheme .. "' not found, falling to doom-one")
    vim.api.nvim_command("colorscheme doom-one")
  end
else
  log.warn("Forced default Doom colorscheme")
  vim.api.nvim_command("colorscheme doom-one")
end

-- Set colors based on environment (GUI, TUI)
if config.doom.enable_guicolors then
  if vim.fn.exists("+termguicolors") == 1 then
    vim.opt.termguicolors = true
  elseif vim.fn.exists("+guicolors") == 1 then
    vim.opt.guicolors = true
  end
end

-- Set custom WhichKey background
vim.cmd("highlight WhichKeyFloat guibg=" .. config.doom.whichkey_bg)

-- Set doom-one colorscheme settings
if config.doom.colorscheme == "doom-one" then
  require("colors.doom-one").setup({
    cursor_coloring = config.doom.doom_one.cursor_coloring,
    terminal_colors = config.doom.doom_one.terminal_colors,
    italic_comments = config.doom.doom_one.italic_comments,
    enable_treesitter = config.doom.doom_one.enable_treesitter,
    transparent_background = config.doom.doom_one.transparent_background,
    pumblend = {
      enable = true,
      transparency_amount = config.doom.complete_transparency,
    },
    plugins_integrations = {
      neorg = true,
      barbar = false,
      bufferline = true,
      gitgutter = false,
      gitsigns = true,
      telescope = config.doom.doom_one.telescope_highlights,
      neogit = true,
      nvim_tree = true,
      dashboard = true,
      startify = false,
      whichkey = true,
      indent_blankline = true,
      vim_illuminate = true,
      lspsaga = false,
    },
  })
end
