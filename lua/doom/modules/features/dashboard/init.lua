local dashboard = {}

dashboard.settings = {
  entries = {
    {
      icon = "  ",
      desc = "Recently Opened Files          ",
      shortcut = "SPC f r",
      action = "Telescope oldfiles",
    },
    {
      icon = "  ",
      desc = "Jump to Bookmark               ",
      shortcut = "SPC s m",
      action = "Telescope marks",
    },
    {
      icon = "  ",
      desc = "Open Configuration             ",
      shortcut = "SPC D c",
      action = "e " .. require("doom.core.config").source,
    },
    {
      icon = "  ",
      desc = "Open Modules                   ",
      shortcut = "SPC D m",
      action = "e " .. require("doom.core.modules").source,
    },
    {
      icon = "  ",
      desc = "Open Documentation             ",
      shortcut = "SPC D d",
      action = "lua require('doom.core.functions').open_docs()",
    },
  },
  header = {
"  .-----------------. .----------------.  .----------------.  .----------------.  .----------------.  .----------------. ",
"| .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. |",
"| | ____  _____  | || |  _________   | || |     ____     | || | ____   ____  | || |     _____    | || | ____    ____ | |",
"| ||_   \\|_   _| | || | |_   ___  |  | || |   .'    `.   | || ||_  _| |_  _| | || |    |_   _|   | || ||_   \\  /   _|| |",
"| |  |   \\ | |   | || |   | |_  \\_|  | || |  /  .--.  \\  | || |  \\ \\   / /   | || |      | |     | || |  |   \\/   |  | |",
"| |  | |\\ \\| |   | || |   |  _|  _   | || |  | |    | |  | || |   \\ \\ / /    | || |      | |     | || |  | |\\  /| |  | |",
"| | _| |_\\   |_  | || |  _| |___/ |  | || |  \\  `--'  /  | || |    \\ ' /     | || |     _| |_    | || | _| |_\\/_| |_ | |",
"| ||_____|\\____| | || | |_________|  | || |   `.____.'   | || |     \\_/      | || |    |_____|   | || ||_____||_____|| |",
"| |              | || |              | || |              | || |              | || |              | || |              | |",
"| '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' |",
" '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'",
    "/        |                              /  |                                          /      |/       \\ /        |",
    "$$$$$$$$/  __    __   ______   _______  $$ |____    ______    _______   _______       $$$$$$/ $$$$$$$  |$$$$$$$$/ ",
    "   $$ |   /  |  /  | /      \\ /       \\ $$      \\  /      \\  /       | /       |        $$ |  $$ |  $$ |$$ |__   ",
    "   $$ |   $$ |  $$ | $$$$$$  |$$$$$$$  |$$$$$$$  | $$$$$$  |/$$$$$$$/ /$$$$$$$/         $$ |  $$ |  $$ |$$    |  ",
    "   $$ |   $$ |  $$ | /    $$ |$$ |  $$ |$$ |  $$ | /    $$ |$$      \\ $$      \\         $$ |  $$ |  $$ |$$$$$/  ",
    "   $$ |   $$ \\__$$ |/$$$$$$$ |$$ |  $$ |$$ |__$$ |/$$$$$$$ | $$$$$$  | $$$$$$  |       _$$ |_ $$ |__$$ |$$ |_____",
    "    $$ |   $$    $$/ $$    $$ |$$ |  $$ |$$    $$/ $$    $$ |/     $$/ /     $$/       / $$   |$$    $$/ $$       |",
    "   $$/     $$$$$$/   $$$$$$$/ $$/   $$/ $$$$$$$/   $$$$$$$/ $$$$$$$/  $$$$$$$/        $$$$$$/ $$$$$$$/  $$$$$$$$/",
    " ",
    " ",
    " ",
    " ",
  },
  footer = { "", "Doom Nvim loaded" },
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
    commit = "f7d623457d6621b25a1292b24e366fae40cb79ab",
    cmd = "Dashboard",
    lazy = true,
  },
}

dashboard.configs = {}
dashboard.configs["dashboard-nvim"] = function()
  local utils = require("doom.utils")
  local db = require("dashboard")
  local is_module_enabled = utils.is_module_enabled

  if is_module_enabled("features", "auto_session") then
    vim.g.dashboard_session_directory = doom.features.auto_session.settings.dir
  end
  if is_module_enabled("features", "telescope") then
    vim.g.dashboard_default_executive = "telescope"
  end
  if is_module_enabled("features", "auto_session") then
    doom.features.dashboard.settings.entries.a = {
      icon = "  ",
      desc = "Load Last Session              ",
      shortcut = "SPC q r",
      action = "lua require('persistence').load({ last = true })",
    }
  end
  if is_module_enabled("features", "session") then
    doom.features.dashboard.settings.entries.t = {
      icon = "  ",
      desc = "Load Last mini Session         ",
      shortcut = "Undef  " ,
      action = "lua MiniSessions.read()",
    }
    doom.features.dashboard.settings.entries.z = {
      icon = "  ",
      desc = "Telescope Session              ",
      shortcut = "Undef  " ,
      action = "Telescope sessions_picker",
    }
  end

  db.custom_center = doom.features.dashboard.settings.entries
  db.theme = "doom"

  if type(doom.features.dashboard.settings.footer) ~= "function" then
    db.custom_footer = doom.features.dashboard.settings.footer
  end

  if type(doom.features.dashboard.settings.header) ~= "function" then
    db.custom_header = doom.features.dashboard.settings.header
  end
  db.hide_tabline = false
  db.hide_statusline = false
  -- Header color
  vim.cmd("hi! dashboardHeader   guifg=" .. doom.features.dashboard.settings.colors.header)
  vim.cmd("hi! dashboardCenter   guifg=" .. doom.features.dashboard.settings.colors.center)
  vim.cmd("hi! DashboardCenterIcon   guifg=" .. doom.features.dashboard.settings.colors.center)
  vim.cmd("hi! dashboardShortcut guifg=" .. doom.features.dashboard.settings.colors.shortcut)
  vim.cmd("hi! dashboardFooter   guifg=" .. doom.features.dashboard.settings.colors.footer)
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
      require("doom.services.keymaps").applyKeymaps({ "q", "<cmd>q<CR>", buffer = true })
      vim.cmd("set foldlevel=99")
    end,
  },
  {
    "VimEnter",
    "*",
    function()
      local utils = require("doom.utils")
      local is_module_enabled = utils.is_module_enabled
      -- Here we check for
      -- 1. Number of files passed to Neovim as arguments during its launch
      -- 2. Bytes count from the start of the buffer to the end (it should be non-existent, -1)
      -- 3. Existence of the buffer
      if vim.fn.argc() == 0 and vim.fn.line2byte("$") == -1 and vim.fn.bufexists(0) == 0 then
        if is_module_enabled("features", "dashboard") then
          vim.cmd("Dashboard")
        end
      end
    end,
    once = true,
  },
}

return dashboard
