--  doom.core.ui
--
--  Responsible for safely setting the colorscheme and falling back to `doom-one`
--  if necessary.

local utils = require("doom.utils")
local log = require("doom.utils.logging")

-- If the colorscheme was not found then fallback to defaults.
if not utils.is_empty(doom.settings.colorscheme) then
  local loaded_colorscheme = xpcall(function()
    vim.api.nvim_command("colorscheme " .. doom.settings.colorscheme)
  end, debug.traceback)

  if not loaded_colorscheme then
    log.warn("Colorscheme '" .. doom.settings.colorscheme .. "' not found, falling back to doom-one")
    vim.api.nvim_command("colorscheme doom-one")
  end
else
  log.warn("Forced default Doom colorscheme")
  vim.api.nvim_command("colorscheme doom-one")
end

-- Set doom-one colorscheme settings
if doom.settings.colorscheme == "doom-one" then
  require("colors.doom-one").setup({
    cursor_coloring = doom.settings.doom_one.cursor_coloring,
    terminal_colors = doom.settings.doom_one.terminal_colors,
    italic_comments = doom.settings.doom_one.italic_comments,
    enable_treesitter = doom.settings.doom_one.enable_treesitter,
    transparent_background = doom.settings.doom_one.transparent_background,
    pumblend = {
      enable = true,
      transparency_amount = doom.complete_transparency,
    },
    plugins_integrations = {
      neorg = true,
      barbar = false,
      bufferline = true,
      gitgutter = false,
      gitsigns = true,
      telescope = doom.settings.doom_one.telescope_highlights,
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
