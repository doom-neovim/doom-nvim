local utils = require("doom.utils")
local is_module_enabled = utils.is_module_enabled

local git = {}

-- TODO: add git repo search?

git.settings = {
  -- doom.modules.git.settings.gitsigns
  gitsigns = {
    signs = {
      add = {
        hl = "GitSignsAdd",
        text = "│",
        numhl = "GitSignsAddNr",
        linehl = "GitSignsAddLn",
      },
      change = {
        hl = "GitSignsChange",
        text = "│",
        numhl = "GitSignsChangeNr",
        linehl = "GitSignsChangeLn",
      },
      delete = {
        hl = "GitSignsDelete",
        text = "_",
        numhl = "GitSignsDeleteNr",
        linehl = "GitSignsDeleteLn",
      },
      topdelete = {
        hl = "GitSignsDelete",
        text = "‾",
        numhl = "GitSignsDeleteNr",
        linehl = "GitSignsDeleteLn",
      },
      changedelete = {
        hl = "GitSignsChange",
        text = "~",
        numhl = "GitSignsChangeNr",
        linehl = "GitSignsChangeLn",
      },
    },
    numhl = false,
    linehl = false,
    keymaps = {
      -- Default keymap options
      noremap = true,
      buffer = true,

      ["n ]c"] = {
        expr = true,
        "&diff ? ']c' : '<cmd>lua require\"gitsigns\".next_hunk()<CR>'",
      },
      ["n [c"] = {
        expr = true,
        "&diff ? '[c' : '<cmd>lua require\"gitsigns\".prev_hunk()<CR>'",
      },
    },
    watch_gitdir = { interval = 1000, follow_files = true },
    current_line_blame_opts = {
      delay = 1000,
      position = "eol",
    },
    sign_priority = 6,
    update_debounce = 100,
    diff_opts = {
      internal = true, -- If luajit is present
    },
  },
  -- doom.modules.git.settings.vgit
  vgit = {
    hls = {
      GitBackgroundPrimary = 'NormalFloat',
      GitBackgroundSecondary = {
        gui = nil,
        fg = nil,
        bg = nil,
        sp = nil,
        override = false,
      },
      GitBorder = 'LineNr',
      GitLineNr = 'LineNr',
      GitComment = 'Comment',
      GitSignsAdd = {
        gui = nil,
        fg = '#d7ffaf',
        bg = nil,
        sp = nil,
        override = false,
      },
      GitSignsChange = {
        gui = nil,
        fg = '#7AA6DA',
        bg = nil,
        sp = nil,
        override = false,
      },
      GitSignsDelete = {
        gui = nil,
        fg = '#e95678',
        bg = nil,
        sp = nil,
        override = false,
      },
      GitSignsAddLn = 'DiffAdd',
      GitSignsDeleteLn = 'DiffDelete',
      GitWordAdd = {
        gui = nil,
        fg = nil,
        bg = '#5d7a22',
        sp = nil,
        override = false,
      },
      GitWordDelete = {
        gui = nil,
        fg = nil,
        bg = '#960f3d',
        sp = nil,
        override = false,
      },
    },
    live_blame = {
      enabled = true,
      format = function(blame, git_config)
        local config_author = git_config['user.name']
        local author = blame.author
        if config_author == author then
          author = 'You'
        end
        local time = os.difftime(os.time(), blame.author_time)
          / (60 * 60 * 24 * 30 * 12)
        local time_divisions = {
          { 1, 'years' },
          { 12, 'months' },
          { 30, 'days' },
          { 24, 'hours' },
          { 60, 'minutes' },
          { 60, 'seconds' },
        }
        local counter = 1
        local time_division = time_divisions[counter]
        local time_boundary = time_division[1]
        local time_postfix = time_division[2]
        while time < 1 and counter ~= #time_divisions do
          time_division = time_divisions[counter]
          time_boundary = time_division[1]
          time_postfix = time_division[2]
          time = time * time_boundary
          counter = counter + 1
        end
        local commit_message = blame.commit_message
        if not blame.committed then
          author = 'You'
          commit_message = 'Uncommitted changes'
          return string.format(' %s • %s', author, commit_message)
        end
        local max_commit_message_length = 255
        if #commit_message > max_commit_message_length then
          commit_message = commit_message:sub(1, max_commit_message_length) .. '...'
        end
        return string.format(
          ' %s, %s • %s',
          author,
          string.format(
            '%s %s ago',
            time >= 0 and math.floor(time + 0.5) or math.ceil(time - 0.5),
            time_postfix
          ),
          commit_message
        )
      end,
    },
    live_gutter = {
      enabled = true,
    },
    scene = {
      diff_preference = 'unified',
    },
    signs = {
      priority = 10,
      definitions = {
        GitSignsAddLn = {
          linehl = 'GitSignsAddLn',
          texthl = nil,
          numhl = nil,
          icon = nil,
          text = '',
        },
        GitSignsDeleteLn = {
          linehl = 'GitSignsDeleteLn',
          texthl = nil,
          numhl = nil,
          icon = nil,
          text = '',
        },
        GitSignsAdd = {
          texthl = 'GitSignsAdd',
          numhl = nil,
          icon = nil,
          linehl = nil,
          text = '┃',
        },
        GitSignsDelete = {
          texthl = 'GitSignsDelete',
          numhl = nil,
          icon = nil,
          linehl = nil,
          text = '┃',
        },
        GitSignsChange = {
          texthl = 'GitSignsChange',
          numhl = nil,
          icon = nil,
          linehl = nil,
          text = '┃',
        },
      },
      usage = {
        scene = {
          add = 'GitSignsAddLn',
          remove = 'GitSignsDeleteLn',
        },
        main = {
          add = 'GitSignsAdd',
          remove = 'GitSignsDelete',
          change = 'GitSignsChange',
        },
      },
    },
    symbols = {
      void = '⣿',
    },
  }
}

git.packages = {
  ["gitsigns.nvim"] = {
    "lewis6991/gitsigns.nvim",
    commit = "3791dfa1ee356a3250e0b74f63bad90e27455f60",
  },
  ["vgit.nvim"] = { "tanvirtin/vgit.nvim" },
  ["git-blame.nvim"] = { 'f-person/git-blame.nvim' },
  -- ["gitlinker.nvim"] = { 'ruifm/gitlinker.nvim' },
  -- ["github-notifications.nvim"] = { 'rlch/github-notifications.nvim' },
  -- ["igs.nvim"] = { 'rmagatti/igs.nvim' },
  -- ["gitstat.nvim"] = { 'kyoh86/gitstat.nvim' },
  -- ["githublink.nvim"] = { 'knsh14/githublink.nvim' },
  -- ["gitignore-grabber.nvim"] = { 'antonk52/gitignore-grabber.nvim' },
  -- ["cmp-git"] = { 'petertriho/cmp-git' }, -- wip / unstable..
  -- https://github.com/ThePrimeagen/git-worktree.nvim
    -- https://github.com/nickgerace/gfold
}

git.configs = {}

git.configs["gitsigns.nvim"] = function()
  require("gitsigns").setup(doom.modules.features.git.settings.gitsigns)
end

git.configs["vgit.nvim"] = function()
  require("vgit").setup()
end

local function commit_hunk_under_cursor()
  require('vgit').project_unstage_all()
  require"gitsigns".stage_hunk()
  vim.cmd("Neogit commit")
end

local function commit_current_buffer()
  -- a. unstage all previously staged hunks (vgit command)
  -- b. stage buffer
  -- c. commit
  -- d. push
end

git.binds = {
  { "ih", ':<C-U>lua require"gitsigns".select_hunk()<CR>', name = "select hunk", mode = "o" },
  { "ih", ':<C-U>lua require"gitsigns".select_hunk()<CR>', name = "select hunk", mode = "x" },
  {
    "<leader>",
    name = "+prefix",
    {
      {
        "g",
        name = "+git",

        {
          -----------------------------------------------------------------------------
          -- COMMITS
          -----------------------------------------------------------------------------
          {
            "c", name = "+commits",
            {
              { "c", "<cmd>Telescope git_commits<CR>", name = "Tele commits" },
              { "u", commit_hunk_under_cursor, name = "commit single hunk"}, -- resets all other
              -- { "U", commit_current_buffer, name = "unstage all;  commit current buffer"}, -- resets all other
              -- { "p", commit_hunk_and_push, name = "com hunk @ curs & push"}, -- resets all other
            }
          },

          -- STAGING | HUNKS
          { "e", name = "+staging/hunks", {
            { "q", ":lua require('vgit').project_hunks_qf()<cr>", name = "proj hunks qt" },
            { "S", '<cmd>lua require"gitsigns".stage_hunk()<CR>', name = "stage hunk" },
            { "u", '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>', name = "undo hunk" },
            { "r", '<cmd>lua require"gitsigns".reset_hunk()<CR>', name = "reset hunk" },
            { "R", '<cmd>lua require"gitsigns".reset_buffer()<CR>', name = "reset buffer" },
            { "h", '<cmd>lua require"gitsigns".preview_hunk()<CR>', name = "preview hunk" },
            { "s", ":lua require('vgit').buffer_hunk_stage()<cr>", name = "stage hunk" },
            { "r", ":lua require('vgit').buffer_hunk_reset()<cr>", name = "reset hunk" },
            { "p", ":lua require('vgit').buffer_hunk_preview()<cr>", name = "preview hunk" },
            { "u", ":lua require('vgit').buffer_reset()<cr>", name = "buf reset" },
            {
              "P",
              name = "+project",
              {
                { "s", ":lua require('vgit').project_stage_all()<cr>", name = "stage all" },
                { "X", ":lua require('vgit').project_reset_all()<cr>", name = "discard all!staged" },
                { "u", ":lua require('vgit').project_unstage_all()<cr>", name = "unstage all" },
              },
            },
          }},
          -----------------------------------------------------------------------------
          -- DIFF
          -----------------------------------------------------------------------------
          { "q", name = "+diff", {
            { "f", ":lua require('vgit').buffer_diff_preview()<cr>", name = "diff preview" },
            { "h", ":lua require('vgit').buffer_history_preview()<cr>", name = "hist preview" },
            {
              "l",
              ":lua require('vgit').project_hunks_preview()<cr>",
              name = "proj hunks preview",
            },
            {
              "d",
              ":lua require('vgit').project_diff_preview()<cr>",
              name = "proj diff preview",
            },
            {
              "x",
              ":lua require('vgit').toggle_diff_preference()<cr>",
              name = "toggle diff pref",
            },
          }},
          -- { "f", name = "+stash", {
          --
          -- }},
          -----------------------------------------------------------------------------
          -- INFO | STATUS
          -----------------------------------------------------------------------------
          { "i", name = "+info/status",
            {
              { "s", "<cmd>Telescope git_status<CR>", name = "Tele status" },
              { "b", '<cmd>lua require"gitsigns".blame_line()<CR>', name = "blame line" },
              { "b", ":lua require('vgit').buffer_blame_preview()<cr>", name = "blame preview" },
              {
                "g",
                ":lua require('vgit').buffer_gutter_blame_preview()<cr>",
                name = "gutter bl preview",
              },
              { "h", '<cmd>lua require"gitsigns".preview_hunk()<CR>', name = "preview hunk" },
              { "b", '<cmd>lua require"gitsigns".blame_line()<CR>', name = "blame line" },
            }
          },
          {
            "b", name = "+branches", {
              { "b", "<cmd>Telescope git_branches<CR>", name = "Tele Branches" },
            }
          },
          -----------------------------------------------------------------------------
          -- PULL
          -----------------------------------------------------------------------------
          -- { "p", name = "+pull", {
          --
          -- }},
          -----------------------------------------------------------------------------
          -- PUSH
          -----------------------------------------------------------------------------
          -- { "P", name = "+push", {
          --
          -- }},
          -----------------------------------------------------------------------------
          -- MISC
          -----------------------------------------------------------------------------
          -- { "m", name = "+misc", {
          --
          -- }},
        },
      },
    },
  },
}

return git
