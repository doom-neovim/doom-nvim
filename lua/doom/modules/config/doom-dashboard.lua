return function()
  local config = require("doom.core.config").config

  vim.g.dashboard_session_directory = require("doom.core.system").doom_root .. "/sessions"
  vim.g.dashboard_default_executive = "telescope"

  vim.g.dashboard_custom_section = {
    a = {
      description = { "  Load Last Session              SPC s r" },
      command = "lua require('persistence').load({ last = true })",
    },
    b = {
      description = { "  Recently Opened Files          SPC f r" },
      command = "Telescope oldfiles",
    },
    c = {
      description = { "  Jump to Bookmark               SPC s m" },
      command = "Telescope marks",
    },
    d = {
      description = { "  Find File                      SPC f f" },
      command = "Telescope find_files",
    },
    e = {
      description = { "  Find Word                      SPC s g" },
      command = "Telescope live_grep",
    },
    f = {
      description = { "  Open Private Configuration     SPC d c" },
      command = 'lua require("doom.core.functions").edit_config()',
    },
    g = {
      description = { "  Open Documentation             SPC d d" },
      command = 'lua require("doom.core.functions").open_docs()',
    },
  }

  vim.g.dashboard_custom_footer = {
    "Doom Nvim loaded in " .. vim.fn.printf(
      "%.3f",
      vim.fn.reltimefloat(vim.fn.reltime(vim.g.start_time))
    ) .. " seconds.",
  }

  vim.g.dashboard_custom_header = vim.tbl_isempty(config.doom.dashboard_custom_header)
      and {
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
    or config.doom.dashboard_custom_header
  -- Header color
  vim.cmd("hi! dashboardHeader   guifg=" .. config.doom.dashboard_custom_colors.header_color)
  vim.cmd("hi! dashboardCenter   guifg=" .. config.doom.dashboard_custom_colors.center_color)
  vim.cmd("hi! dashboardShortcut guifg=" .. config.doom.dashboard_custom_colors.shortcut_color)
  vim.cmd("hi! dashboardFooter   guifg=" .. config.doom.dashboard_custom_colors.footer_color)
end
