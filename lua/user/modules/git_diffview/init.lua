local diffview = {}

diffview.settings = {}

diffview.packages = {
  ["diffview.nvim"] = { "sindrets/diffview.nvim", requires = "nvim-lua/plenary.nvim" },
}

-- Usage
-- :DiffviewOpen [git rev] [args] [ -- {paths...}]
-- Calling :DiffviewOpen with no args opens a new Diffview that compares against the current index. You can also provide any valid git rev to view only changes for that rev. Examples:
--
-- :DiffviewOpen
-- :DiffviewOpen HEAD~2
-- :DiffviewOpen HEAD~4..HEAD~2
-- :DiffviewOpen d4a7b0d
-- :DiffviewOpen d4a7b0d..519b30e
-- :DiffviewOpen origin/main...HEAD
-- You can also provide additional paths to narrow down what files are shown:
--
-- :DiffviewOpen HEAD~2 -- lua/diffview plugin
-- For information about additional [args], visit the documentation.
--
-- Additional commands for convenience:
--
-- :DiffviewClose: Close the current diffview. You can also use :tabclose.
-- :DiffviewToggleFiles: Toggle the files panel.
-- :DiffviewFocusFiles: Bring focus to the files panel.
-- :DiffviewRefresh: Update stats and entries in the file list of the current Diffview.
-- With a Diffview open and the default key bindings, you can cycle through changed files with <tab> and <s-tab> (see configuration to change the key bndings).

-- :DiffviewFileHistory [paths] [args]
-- Opens a new file history view that lists all commits that changed a given file or directory. If no [paths] are given, defaults to the current file. Multiple [paths] may be provided. If you want to view the file history for all changed files for every commit, simply call :DiffviewFileHistory . (assuming your cwd is the top level of the git repository).
--
-- Tips
-- Hide untracked files:
-- DiffviewOpen -uno
-- Exclude certain paths:
-- DiffviewOpen -- :!exclude/this :!and/this
-- Run as if git was started in a specific directory:
-- DiffviewOpen -C/foo/bar/baz
-- Diff the index against a git rev:
-- DiffviewOpen HEAD~2 --cached
-- Defaults to HEAD if no rev is given.
-- Change the fill char for the deleted lines in diff-mode:
-- (vimscript): set fillchars+=diff:╱
-- Note: whether or not the diagonal lines will line up nicely will depend on your terminal emulator.
-- Restoring Files
-- If the right side of the diff is showing the local state of a file, you can restore the file to the state from the left side of the diff (key binding X from the file panel by default). The current state of the file is stored in the git object database, and a command is echoed that shows how to undo the change.


-- use({ "sindrets/diffview.nvim", config = require("molleweide.configs.diffview") })
diffview.configs = {
  ["diffview.nvim"] = function()

    local cb = require("diffview.config").diffview_callback

    require("diffview").setup({
      diff_binaries = false, -- Show diffs for binaries
      enhanced_diff_hl = false, -- See ':h diffview-config-enhanced_diff_hl'
      use_icons = true, -- Requires nvim-web-devicons
      icons = { -- Only applies when use_icons is true.
        folder_closed = "",
        folder_open = "",
      },
      signs = {
        fold_closed = "",
        fold_open = "",
      },
      file_panel = {
        position = "left", -- One of 'left', 'right', 'top', 'bottom'
        width = 35, -- Only applies when position is 'left' or 'right'
        height = 10, -- Only applies when position is 'top' or 'bottom'
        listing_style = "tree", -- One of 'list' or 'tree'
        tree_options = { -- Only applies when listing_style is 'tree'
          flatten_dirs = true,
          folder_statuses = "always", -- One of 'never', 'only_folded' or 'always'.
        },
      },
      file_history_panel = {
        position = "bottom",
        width = 35,
        height = 16,
        log_options = {
          max_count = 256, -- Limit the number of commits
          follow = false, -- Follow renames (only for single file)
          all = false, -- Include all refs under 'refs/' including HEAD
          merges = false, -- List only merge commits
          no_merges = false, -- List no merge commits
          reverse = false, -- List commits in reverse order
        },
      },
      default_args = { -- Default args prepended to the arg-list for the listed commands
        DiffviewOpen = {},
        DiffviewFileHistory = {},
      },
      key_bindings = {
        disable_defaults = false, -- Disable the default key bindings
        -- The `view` bindings are active in the diff buffers, only when the current
        -- tabpage is a Diffview.
        view = {
          ["<tab>"] = cb("select_next_entry"), -- Open the diff for the next file
          ["<s-tab>"] = cb("select_prev_entry"), -- Open the diff for the previous file
          ["gf"] = cb("goto_file"), -- Open the file in a new split in previous tabpage
          ["<C-w><C-f>"] = cb("goto_file_split"), -- Open the file in a new split
          ["<C-w>gf"] = cb("goto_file_tab"), -- Open the file in a new tabpage
          ["<leader>e"] = cb("focus_files"), -- Bring focus to the files panel
          ["<leader>b"] = cb("toggle_files"), -- Toggle the files panel.
        },
        file_panel = {
          ["j"] = cb("next_entry"), -- Bring the cursor to the next file entry
          ["<down>"] = cb("next_entry"),
          ["k"] = cb("prev_entry"), -- Bring the cursor to the previous file entry.
          ["<up>"] = cb("prev_entry"),
          ["<cr>"] = cb("select_entry"), -- Open the diff for the selected entry.
          ["o"] = cb("select_entry"),
          ["<2-LeftMouse>"] = cb("select_entry"),
          ["-"] = cb("toggle_stage_entry"), -- Stage / unstage the selected entry.
          ["S"] = cb("stage_all"), -- Stage all entries.
          ["U"] = cb("unstage_all"), -- Unstage all entries.
          ["X"] = cb("restore_entry"), -- Restore entry to the state on the left side.
          ["R"] = cb("refresh_files"), -- Update stats and entries in the file list.
          ["<tab>"] = cb("select_next_entry"),
          ["<s-tab>"] = cb("select_prev_entry"),
          ["gf"] = cb("goto_file"),
          ["<C-w><C-f>"] = cb("goto_file_split"),
          ["<C-w>gf"] = cb("goto_file_tab"),
          ["i"] = cb("listing_style"), -- Toggle between 'list' and 'tree' views
          ["f"] = cb("toggle_flatten_dirs"), -- Flatten empty subdirectories in tree listing style.
          ["<leader>e"] = cb("focus_files"),
          ["<leader>b"] = cb("toggle_files"),
        },
        file_history_panel = {
          ["g!"] = cb("options"), -- Open the option panel
          ["<C-A-d>"] = cb("open_in_diffview"), -- Open the entry under the cursor in a diffview
          ["y"] = cb("copy_hash"), -- Copy the commit hash of the entry under the cursor
          ["zR"] = cb("open_all_folds"),
          ["zM"] = cb("close_all_folds"),
          ["j"] = cb("next_entry"),
          ["<down>"] = cb("next_entry"),
          ["k"] = cb("prev_entry"),
          ["<up>"] = cb("prev_entry"),
          ["<cr>"] = cb("select_entry"),
          ["o"] = cb("select_entry"),
          ["<2-LeftMouse>"] = cb("select_entry"),
          ["<tab>"] = cb("select_next_entry"),
          ["<s-tab>"] = cb("select_prev_entry"),
          ["gf"] = cb("goto_file"),
          ["<C-w><C-f>"] = cb("goto_file_split"),
          ["<C-w>gf"] = cb("goto_file_tab"),
          ["<leader>e"] = cb("focus_files"),
          ["<leader>b"] = cb("toggle_files"),
        },
        option_panel = {
          ["<tab>"] = cb("select"),
          ["q"] = cb("close"),
        },
      },
    })
  end,
}

-- diffview.autocmds = {}
--
-- diffview.cmds = {}

-- diffview.binds = {
--   {
--     "<leader>g",
--     name = "+git",
--     {
--       {
--         "d",
--         ""
--         name = "Open diffview",
--       },
--     },
--   },
-- }

return diffview