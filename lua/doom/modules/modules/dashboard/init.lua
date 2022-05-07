local dashboard = {}

dashboard.settings = {
  entries = {
    b = {
      description = { "  Recently Opened Files          SPC f r" },
      command = "Telescope oldfiles",
    },
    c = {
      description = { "  Jump to Bookmark               SPC s m" },
      command = "Telescope marks",
    },
    d = {
      description = { "  Open Configuration             SPC D c" },
      command = "e " .. require("doom.core.config").source,
    },
    e = {
      description = { "  Open Modules                   SPC D m" },
      command = "e " .. require("doom.core.modules").source,
    },
    f = {
      description = { "  Open Documentation             SPC D d" },
      command = [[lua require("doom.core.functions").open_docs()]],
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
  footer = { "Doom Nvim loaded" },
  colors = {
    header = "#586268",
    center = "#51afef",
    shortcut = "#a9a1e1",
    footer = "#586268",
  },
}

dashboard.packages = {
  ["dashboard-nvim"] = {
    "glepnir/dashboard-nvim",
    commit = "ba98ab86487b8eda3b0934b5423759944b5f7ebd",
    cmd = "Dashboard",
    opt = true,
  },
}


dashboard.configs = {}
dashboard.configs["dashboard-nvim"] = function()
  local utils = require("doom.utils")
  local is_module_enabled = utils.is_module_enabled

  if is_module_enabled("auto_session") then
    vim.g.dashboard_session_directory = doom.modules.auto_session.settings.dir
  end
  if is_module_enabled("telescope") then
    vim.g.dashboard_default_executive = "telescope"
  end
  if is_module_enabled("auto_session") then
    doom.modules.dashboard.settings.entries.a = {
      description = { "  Load Last Session              SPC s r" },
      command = [[lua require("persistence").load({ last = true })]],
    }
  end

  vim.g.dashboard_custom_section = doom.modules.dashboard.settings.entries

  if type(doom.modules.dashboard.settings.footer) ~= "function" then
    vim.g.dashboard_custom_footer = doom.modules.dashboard.settings.footer
  end

  if type(doom.modules.dashboard.settings.header) ~= "function" then
    vim.g.dashboard_custom_header = doom.modules.dashboard.settings.header
  end
  -- Header color
  vim.cmd("hi! dashboardHeader   guifg=" .. doom.modules.dashboard.settings.colors.header)
  vim.cmd("hi! dashboardCenter   guifg=" .. doom.modules.dashboard.settings.colors.center)
  vim.cmd("hi! dashboardShortcut guifg=" .. doom.modules.dashboard.settings.colors.shortcut)
  vim.cmd("hi! dashboardFooter   guifg=" .. doom.modules.dashboard.settings.colors.footer)
end

dashboard.binds = {
  "<leader>",
  name = "+prefix",
  {
    {
      "o",
      name = "+open/close",
      {
        { "D", "<cmd>Dashboard<CR>", name = "Dashboard" },
      },
    },
  },
}

dashboard.autocmds = {
  {
    "FileType",
    "dashboard",
    function()
      require("nest").applyKeymaps({ "q", "<cmd>q<CR>", buffer = true })
    end,
  },
  {
    "VimEnter",
    "*",
    function()
      if
        (vim.api.nvim_buf_get_number(0) > 1
        or vim.api.nvim_buf_get_lines(0, 0, 1, false)[1]:len() == 0)
        and vim.api.nvim_buf_get_name(0):len() == 0 -- Empty buffer name
      then
        vim.cmd("Dashboard")
      end
    end,
    once = true,
  }
}

return dashboard
