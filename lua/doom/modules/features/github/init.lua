local github = {}

-- TODO: !!!
-- It's highly recommended to use gh.nvim with either fzf.lua or telescope to override vim.ui.select. If you use telescope, it will work out of the box. If you want to use fzf.lua, add the following snippet to your config:
-- vim.cmd("FzfLua register_ui_select")

github.settings = {}

github.packages = {
  ["gh.nvim"] = {
    "ldelossa/gh.nvim",
    requires = { { 'ldelossa/litee.nvim' } }
  },
  ["octo.nvim"] = {
    "pwntester/octo.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "kyazdani42/nvim-web-devicons",
    },
  },
}

github.configs = {}

github.configs["octo.nvim"] = function()
  require("octo").setup({
    default_remote = { "upstream", "origin" }, -- order to try remotes
    reaction_viewer_hint_icon = "", -- marker for user reactions
    user_icon = " ", -- user icon
    timeline_marker = "", -- timeline marker
    timeline_indent = "2", -- timeline indentation
    right_bubble_delimiter = "", -- Bubble delimiter
    left_bubble_delimiter = "", -- Bubble delimiter
    github_hostname = "", -- GitHub Enterprise host
    snippet_context_lines = 4, -- number or lines around commented lines
    file_panel = {
      size = 10, -- changed files panel rows
      use_icons = true, -- use web-devicons in file panel
    },
    mappings = {
      issue = {
        close_issue = "<space>ic", -- close issue
        reopen_issue = "<space>io", -- reopen issue
        list_issues = "<space>il", -- list open issues on same repo
        reload = "<C-r>", -- reload issue
        open_in_browser = "<C-b>", -- open issue in browser
        copy_url = "<C-y>", -- copy url to system clipboard
        add_assignee = "<space>aa", -- add assignee
        remove_assignee = "<space>ad", -- remove assignee
        create_label = "<space>lc", -- create label
        add_label = "<space>la", -- add label
        remove_label = "<space>ld", -- remove label
        goto_issue = "<space>gi", -- navigate to a local repo issue
        add_comment = "<space>ca", -- add comment
        delete_comment = "<space>cd", -- delete comment
        next_comment = "]c", -- go to next comment
        prev_comment = "[c", -- go to previous comment
        react_hooray = "<space>rp", -- add/remove 🎉 reaction
        react_heart = "<space>rh", -- add/remove ❤️ reaction
        react_eyes = "<space>re", -- add/remove 👀 reaction
        react_thumbs_up = "<space>r+", -- add/remove 👍 reaction
        react_thumbs_down = "<space>r-", -- add/remove 👎 reaction
        react_rocket = "<space>rr", -- add/remove 🚀 reaction
        react_laugh = "<space>rl", -- add/remove 😄 reaction
        react_confused = "<space>rc", -- add/remove 😕 reaction
      },
      pull_request = {
        checkout_pr = "<space>po", -- checkout PR
        merge_pr = "<space>pm", -- merge PR
        list_commits = "<space>pc", -- list PR commits
        list_changed_files = "<space>pf", -- list PR changed files
        show_pr_diff = "<space>pd", -- show PR diff
        add_reviewer = "<space>va", -- add reviewer
        remove_reviewer = "<space>vd", -- remove reviewer request
        close_issue = "<space>ic", -- close PR
        reopen_issue = "<space>io", -- reopen PR
        list_issues = "<space>il", -- list open issues on same repo
        reload = "<C-r>", -- reload PR
        open_in_browser = "<C-b>", -- open PR in browser
        copy_url = "<C-y>", -- copy url to system clipboard
        add_assignee = "<space>aa", -- add assignee
        remove_assignee = "<space>ad", -- remove assignee
        create_label = "<space>lc", -- create label
        add_label = "<space>la", -- add label
        remove_label = "<space>ld", -- remove label
        goto_issue = "<space>gi", -- navigate to a local repo issue
        add_comment = "<space>ca", -- add comment
        delete_comment = "<space>cd", -- delete comment
        next_comment = "]c", -- go to next comment
        prev_comment = "[c", -- go to previous comment
        react_hooray = "<space>rp", -- add/remove 🎉 reaction
        react_heart = "<space>rh", -- add/remove ❤️ reaction
        react_eyes = "<space>re", -- add/remove 👀 reaction
        react_thumbs_up = "<space>r+", -- add/remove 👍 reaction
        react_thumbs_down = "<space>r-", -- add/remove 👎 reaction
        react_rocket = "<space>rr", -- add/remove 🚀 reaction
        react_laugh = "<space>rl", -- add/remove 😄 reaction
        react_confused = "<space>rc", -- add/remove 😕 reaction
      },
      review_thread = {
        goto_issue = "<space>gi", -- navigate to a local repo issue
        add_comment = "<space>ca", -- add comment
        add_suggestion = "<space>sa", -- add suggestion
        delete_comment = "<space>cd", -- delete comment
        next_comment = "]c", -- go to next comment
        prev_comment = "[c", -- go to previous comment
        select_next_entry = "]q", -- move to previous changed file
        select_prev_entry = "[q", -- move to next changed file
        close_review_tab = "<C-c>", -- close review tab
        react_hooray = "<space>rp", -- add/remove 🎉 reaction
        react_heart = "<space>rh", -- add/remove ❤️ reaction
        react_eyes = "<space>re", -- add/remove 👀 reaction
        react_thumbs_up = "<space>r+", -- add/remove 👍 reaction
        react_thumbs_down = "<space>r-", -- add/remove 👎 reaction
        react_rocket = "<space>rr", -- add/remove 🚀 reaction
        react_laugh = "<space>rl", -- add/remove 😄 reaction
        react_confused = "<space>rc", -- add/remove 😕 reaction
      },
      submit_win = {
        approve_review = "<C-a>", -- approve review
        comment_review = "<C-m>", -- comment review
        request_changes = "<C-r>", -- request changes review
        close_review_tab = "<C-c>", -- close review tab
      },
      review_diff = {
        add_review_comment = "<space>ca", -- add a new review comment
        add_review_suggestion = "<space>sa", -- add a new review suggestion
        focus_files = "<leader>e", -- move focus to changed file panel
        toggle_files = "<leader>b", -- hide/show changed files panel
        next_thread = "]t", -- move to next thread
        prev_thread = "[t", -- move to previous thread
        select_next_entry = "]q", -- move to previous changed file
        select_prev_entry = "[q", -- move to next changed file
        close_review_tab = "<C-c>", -- close review tab
        toggle_viewed = "<leader><space>", -- toggle viewer viewed state
      },
      file_panel = {
        next_entry = "j", -- move to next changed file
        prev_entry = "k", -- move to previous changed file
        select_entry = "<cr>", -- show selected changed file diffs
        refresh_files = "R", -- refresh changed files panel
        focus_files = "<leader>e", -- move focus to changed file panel
        toggle_files = "<leader>b", -- hide/show changed files panel
        select_next_entry = "]q", -- move to previous changed file
        select_prev_entry = "[q", -- move to next changed file
        close_review_tab = "<C-c>", -- close review tab
        toggle_viewed = "<leader><space>", -- toggle viewer viewed state
      },
    },
  })
end




github.configs["gh.nvim"] = function()
  -- require('litee.lib').setup() -- do this in the core litee
  require('litee.gh').setup({
    -- deprecated, around for compatability for now.
    jump_mode   = "invoking",
    -- remap the arrow keys to resize any litee.nvim windows.
    map_resize_keys = false,
    -- do not map any keys inside any gh.nvim buffers.
    disable_keymaps = false,
    -- the icon set to use.
    icon_set = "default",
    -- any custom icons to use.
    icon_set_custom = nil,
    -- whether to register the @username and #issue_number omnifunc completion
    -- in buffers which start with .git/
    git_buffer_completion = true,
    -- defines keymaps in gh.nvim buffers.
    keymaps = {
        -- when inside a gh.nvim panel, this key will open a node if it has
        -- any futher functionality. for example, hitting <CR> on a commit node
        -- will open the commit's changed files in a new gh.nvim panel.
        open = "<CR>",
        -- when inside a gh.nvim panel, expand a collapsed node
        expand = "zo",
        -- when inside a gh.nvim panel, collpased and expanded node
        collapse = "zc",
        -- when cursor is over a "#1234" formatted issue or PR, open its details
        -- and comments in a new tab.
        goto_issue = "gd",
        -- show any details about a node, typically, this reveals commit messages
        -- and submitted review bodys.
        details = "d",
        -- inside a convo buffer, submit a comment
        submit_comment = "<C-s>",
        -- inside a convo buffer, when your cursor is ontop of a comment, open
        -- up a set of actions that can be performed.
        actions = "<C-a>",
        -- inside a thread convo buffer, resolve the thread.
        resolve_thread = "<C-r>",
        -- inside a gh.nvim panel, if possible, open the node's web URL in your
        -- browser. useful particularily for digging into external failed CI
        -- checks.
        goto_web = "gx"
    }
  })
end





-- github.autocmds = {}
--
-- github.cmds = {}














-- local wk = require("which-key")
-- wk.register({
--     g = {
--         name = "+Git",
--         h = ,
--     },
-- }, { prefix = "<leader>" })








-- TODO: fix name attr on all `gh` binds

github.binds = {
  {
    "<leader>g",
    name = "+git",
    {
      {
        "o",
        name = "+octo",
        {
          { "i", ":Octo issue ", name = "issue", options = { silent = false } },
          { "l", "<cmd>Octo issue list<cr>", name = "issue list" },
        },
      },
      {
        "h",
        name = "+gh",
        {
          {
            "c", name = "Commits",
            {
              {"c", "<cmd>GHCloseCommit<cr>", name = "Close" },
              {"e", "<cmd>GHExpandCommit<cr>", name = "Expand" },
              {"o", "<cmd>GHOpenToCommit<cr>", name = "Open To" },
              {"p", "<cmd>GHPopOutCommit<cr>", name = "Pop Out" },
              {"z", "<cmd>GHCollapseCommit<cr>", name = "Collapse" },
            },
          },
          {
              "i", name = "+Issues",
            {
              { "p", name = "<cmd>GHPreviewIssue<cr>", "Preview" },
            }
          },
          {
              "l", name = "+Litee",
            {
              { "t", name = "<cmd>LTPanel<cr>", "Toggle Panel" },
            }
          },
          {
              "r", name = "+Review",
            {
              {"b", "<cmd>GHStartReview<cr>", name = "Begin" },
              {"c", "<cmd>GHCloseReview<cr>", name = "Close" },
              {"d", "<cmd>GHDeleteReview<cr>", name = "Delete" },
              {"e", "<cmd>GHExpandReview<cr>", name = "Expand" },
              {"s", "<cmd>GHSubmitReview<cr>", name = "Submit" },
              {"z", "<cmd>GHCollapseReview<cr>", name = "Collapse" },
            }
          },
          {
              "p", name = "+Pull Request",
            {
              {"c", "<cmd>GHClosePR<cr>", name = "Close" },
              {"d", "<cmd>GHPRDetails<cr>", name = "Details" },
              {"e", "<cmd>GHExpandPR<cr>", name = "Expand" },
              {"o", "<cmd>GHOpenPR<cr>", name = "Open" },
              {"p", "<cmd>GHPopOutPR<cr>", name = "PopOut" },
              {"r", "<cmd>GHRefreshPR<cr>", name = "Refresh" },
              {"t", "<cmd>GHOpenToPR<cr>", name = "Open To" },
              {"z", "<cmd>GHCollapsePR<cr>", name = "Collapse" },
            }
          },
          {
              "t", name = "+Threads",
            {
              {"c", "<cmd>GHCreateThread<cr>", name = "Create" },
              {"n", "<cmd>GHNextThread<cr>", name = "Next" },
              {"t", "<cmd>GHToggleThread<cr>", name = "Toggle" },
            }
          },
        },
      },
    },
  },
}

-- CREATE BUFFER BASED LEADER KEYS FOR OCTO HERE. SO THAT THERE IS A LEGEND FOR GITHUB...

return github
