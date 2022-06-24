return function()
  local config = require("doom.core.config").config
  -- require [dashboard-nvim](https://github.com/glepnir/dashboard-nvim)
  local db = require("dashboard")

  vim.g.dashboard_session_directory = require("doom.core.system").doom_root .. "/sessions"
  vim.g.dashboard_default_executive = "telescope"

  -- Custom Center
  db.custom_center = {
    {
      icon = "  ",
      desc = "Load Last Session              ",
      shortcut = "SPC s r",
      action = "lua require('persistence').load({ last = true })",
    },
    {
      icon = "  ",
      desc = "Recently Opened Files          ",
      shortcut = "SPC f r",
      action = "lua require('telescope.builtin').oldfiles()",
    },
    {
      icon = "  ",
      desc = "Jump to Bookmark               ",
      shortcut = "SPC s m",
      action = "lua require('telescope.builtin').marks()",
    },
    {
      icon = "  ",
      desc = "Find File                      ",
      shortcut = "SPC f f",
      action = "lua require('telescope.builtin').find_files()",
    },
    {
      icon = "  ",
      desc = "Find Word                      ",
      shortcut = "SPC f g",
      action = "lua require('telescope.builtin').live_grep()",
    },
    {
      icon = "  ",
      desc = "Open Private Configuration     ",
      shortcut = "SPC d c",
      action = "lua require('doom.core.functions').edit_config()",
    },
    {
      icon = "  ",
      desc = "Open Documentation             ",
      shortcut = "SPC d d",
      action = "lua require('doom.core.functions').open_docs()",
    },
  }

  -- Custom Footer
  db.custom_footer = {
    "", -- add 'newline' padding between `custom_center` and `custom_footer`
    "Doom Nvim loaded in " .. vim.fn.printf(
      "%.3f",
      vim.fn.reltimefloat(vim.fn.reltime(vim.g.start_time))
    ) .. " seconds.",
  }

  -- always show tabline & statusline
  db.hide_tabline = false
  db.hide_statusline = false

  -- Custom Header (default)
  db.custom_header = {
    "                                                                              ",
    "=================     ===============     ===============   ========  ========",
    "\\\\ . . . . . . .\\\\   //. . . . . . .\\\\   //. . . . . . .\\\\  \\\\. . .\\\\// . . //",
    "||. . ._____. . .|| ||. . ._____. . .|| ||. . ._____. . .|| || . . .\\/ . . .||",
    "|| . .||   ||. . || || . .||   ||. . || || . .||   ||. . || ||. . . . . . . ||",
    "||. . ||   || . .|| ||. . ||   || . .|| ||. . ||   || . .|| || . | . . . . .||",
    "|| . .||   ||. _-|| ||-_ .||   ||. . || || . .||   ||. _-|| ||-_.|\\ . . . . ||",
    "||. . ||   ||-'  || ||  `-||   || . .|| ||. . ||   ||-'  || ||  `|\\_ . .|. .||",
    "|| . _||   ||    || ||    ||   ||_ . || || . _||   ||    || ||   |\\ `-_/| . ||",
    "||_-' ||  .|/    || ||    \\|.  || `-_|| ||_-' ||  .|/    || ||   | \\  / |-_.||",
    "||    ||_-'      || ||      `-_||    || ||    ||_-'      || ||   | \\  / |  `||",
    "||    `'         || ||         `'    || ||    `'         || ||   | \\  / |   ||",
    "||            .===' `===.         .==='.`===.         .===' /==. |  \\/  |   ||",
    "||         .=='   \\_|-_ `===. .==='   _|_   `===. .===' _-|/   `==  \\/  |   ||",
    "||      .=='    _-'    `-_  `='    _-'   `-_    `='  _-'   `-_  /|  \\/  |   ||",
    "||   .=='    _-'          `-__\\._-'         `-_./__-'         `' |. /|  |   ||",
    "||.=='    _-'                                                     `' |  /==.||",
    "=='    _-'                        N E O V I M                         \\/   `==",
    "\\   _-'                                                                `-_   /",
    " `''                                                                      ``'  ",
  }

  -- overwrite the default `custom_header` if the user sets `config.doom.dashboard_custom_header`
  local next = next
  if next(config.doom.dashboard_custom_header) ~= nil then
    -- user has set `config.doom.dashboard_custom_header`
    db.custom_header = config.doom.dashboard_custom_header
  end

  -- Header color
  vim.cmd("hi! DashboardHeader       guifg=" .. config.doom.dashboard_custom_colors.header_color)
  vim.cmd("hi! DashboardCenter       guifg=" .. config.doom.dashboard_custom_colors.center_color)
  vim.cmd("hi! DashboardCenterIcon   guifg=" .. config.doom.dashboard_custom_colors.center_color)
  vim.cmd("hi! DashboardShortCut     guifg=" .. config.doom.dashboard_custom_colors.shortcut_color)
  vim.cmd("hi! DashboardFooter       guifg=" .. config.doom.dashboard_custom_colors.footer_color)
end
