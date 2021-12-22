local dashboard = {}

dashboard.defaults = {
  entries = {
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
  },
  header = {
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
  },
  footer = function()
    return {
      "Doom Nvim loaded in " .. vim.fn.printf(
        "%.3f",
        vim.fn.reltimefloat(vim.fn.reltime(vim.g.start_time))
      ) .. " seconds.",
    }
  end,
  colors = {
    header = "#586268",
    center = "#51afef",
    shortcut = "#a9a1e1",
    footer = "#586268",
  },
}

dashboard.packer_config = {}
dashboard.packer_config["dashboard-nvim"] = function()
  local utils = require("doom.utils")
  local is_plugin_disabled = utils.is_plugin_disabled

  if not is_plugin_disabled("auto_session") then
    vim.g.dashboard_session_directory = doom.auto_session.dir
  end
  if not is_plugin_disabled("telescope") then
    vim.g.dashboard_default_executive = "telescope"
  end

  vim.g.dashboard_custom_section = doom.dashboard.entries

  if type(doom.dashboard.footer) ~= "function" then
    vim.g.dashboard_custom_footer = doom.dashboard.footer
  end

  if type(doom.dashboard.header) ~= "function" then
    vim.g.dashboard_custom_header = doom.dashboard.header
  end
  -- Header color
  vim.cmd("hi! dashboardHeader   guifg=" .. doom.dashboard.colors.header)
  vim.cmd("hi! dashboardCenter   guifg=" .. doom.dashboard.colors.center)
  vim.cmd("hi! dashboardShortcut guifg=" .. doom.dashboard.colors.shortcut)
  vim.cmd("hi! dashboardFooter   guifg=" .. doom.dashboard.colors.footer)
end

return dashboard
