---[[---------------------------------------]]---
--       ui.lua - Doom Nvim UI settings        --
--             Author: NTBBloodbath            --
--             License: GPLv2                  --
---[[---------------------------------------]]---

local utils = require("doom.utils")
local log = require("doom.extras.logging")
local config = require("doom.core.config").load_config()

log.debug("Loading Doom UI module ...")

-- If no colorscheme was established then fallback to defauls
if not utils.is_empty(config.doom.colorscheme) then
  local loaded_colorscheme = pcall(function()
    vim.opt.background = config.doom.colorscheme_bg
    vim.api.nvim_command("colorscheme " .. config.doom.colorscheme)
  end)

  if not loaded_colorscheme then
    log.error("Colorscheme not found, falling to doom-one")
    vim.api.nvim_command("colorscheme " .. config.doom.colorscheme)
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

-- Set doom-one colorscheme settings
vim.g.doom_one_cursor_coloring = config.doom.doom_one.cursor_coloring
vim.g.doom_one_enable_treesitter = config.doom.doom_one.enable_treesitter
vim.g.doom_one_italic_comments = config.doom.doom_one.italic_comments
vim.g.doom_one_telescope_highlights = config.doom.doom_one.telescope_highlights
vim.g.doom_one_terminal_colors = config.doom.doom_one.terminal_colors
vim.g.doom_one_transparent_background = config.doom.doom_one.transparent_background
