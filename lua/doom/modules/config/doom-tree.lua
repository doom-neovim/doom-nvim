return function()
  local config = require("doom.core.config").config
  local tree_cb = require("nvim-tree.config").nvim_tree_callback

  ----- GLOBAL VARIABLES ------------------------
  -----------------------------------------------
  -- Empty by default
  vim.g.nvim_tree_ignore = { ".git", "node_modules", ".cache", "__pycache__" }

  -- False by default, this option shows indent markers when folders are open
  vim.g.nvim_tree_indent_markers = 1

  -- Show hidden files
  vim.g.nvim_tree_hide_dotfiles = config.doom.show_hidden

  -- False by default, will enable file highlight for git attributes (can be used without the icons).
  vim.g.nvim_tree_git_hl = 1

  -- False by default
  vim.g.nvim_tree_gitignore = 1

  -- This is the default. See :help filename-modifiers for more options
  vim.g.nvim_tree_root_folder_modifier = ":~"

  -- False by default, append a trailing slash to folder names
  vim.g.nvim_tree_add_trailing = 1

  -- False by default, compact folders that only contain a single folder into one node in the file tree
  vim.g.nvim_tree_group_empty = 1

  -- 1000 by default, control how often the tree can be refreshed,
  -- 1000 means the tree can be refresh once per 1000ms.
  vim.g.nvim_tree_refresh_wait = 500

  -- Ignored filetypes and buffers when window picker is enabled
  vim.g.nvim_tree_window_picker_exclude = {
    filetype = {
      "notify",
      "packer",
      "qf",
    },
    buftype = {
      "terminal",
    },
  }

  -- List of filenames that gets highlighted with NvimTreeSpecialFile
  vim.g.nvim_tree_special_files = { ["README.md"] = 1, Makefile = 1, MAKEFILE = 1 }

  -- If false, do not show the icons for one of 'git' 'folder' and 'files'
  -- true by default, notice that if 'files' is 1, it will only display
  -- if nvim-web-devicons is installed and on your runtimepath
  vim.g.nvim_tree_show_icons = { git = 1, folders = 1, files = 1, folder_arrows = 0 }

  --- Tree icons
  -- default will show icon by default if no icon is provided
  -- default shows no icon by default
  vim.g.nvim_tree_icons = {
    default = "",
    symlink = "",
    git = {
      unstaged = "",
      staged = "",
      unmerged = "",
      renamed = "",
      untracked = "",
      deleted = "",
      ignored = "◌",
    },
    folder = {
      arrow_open = "",
      arrow_closed = "",
      default = "",
      open = "",
      empty = "",
      empty_open = "",
      symlink = "",
      symlink_open = "",
    },
    lsp = {
      hint = config.doom.lsp_hint,
      info = config.doom.lsp_info,
      warning = config.doom.lsp_warn,
      error = config.doom.lsp_error,
    },
  }

  ----- SETUP CONFIGURATION ---------------------
  -----------------------------------------------
  require("nvim-tree").setup({
    -- Completely disable netrw
    disable_netrw = false,
    -- Hijack netrw window on startup
    hijack_netrw = true,
    -- open the tree when running this setup function
    open_on_setup = false,
    -- will not open on setup if the filetype is in this list
    ignore_ft_on_setup = {},
    -- closes neovim automatically when the tree is the last **WINDOW** in the view
    auto_close = false,
    -- opens the tree when changing/opening a new tab if the tree wasn't previously opened
    open_on_tab = true,
    -- hijack the cursor in the tree to put it at the start of the filename
    hijack_cursor = true,
    -- updates the root directory of the tree on `DirChanged` (when your run `:cd` usually)
    update_cwd = true,
    -- show lsp diagnostics in the signcolumn
    diagnostics = {
      enable = require("doom.utils").is_plugin_disabled("lsp") and false or true,
      icons = {
        hint = config.doom.lsp_hint,
        info = config.doom.lsp_info,
        warning = config.doom.lsp_warn,
        error = config.doom.lsp_error,
      },
    },
    -- update the focused file on `BufEnter`, un-collapses the folders recursively until it finds the file
    update_focused_file = {
      -- enables the feature
      enable = true,
      -- update the root directory of the tree to the one of the folder containing the file if the file is not under the current root directory
      -- only relevant when `update_focused_file.enable` is true
      update_cwd = true,
      -- list of buffer names / filetypes that will not update the cwd if the file isn't found under the current root directory
      -- only relevant when `update_focused_file.update_cwd` is true and `update_focused_file.enable` is true
      ignore_list = {},
    },
    -- configuration options for the system open command (`s` in the tree by default)
    system_open = {
      -- the command to run this, leaving nil should work in most cases
      cmd = nil,
      -- the command arguments as a list
      args = {},
    },

    view = {
      -- width of the window, can be either a number (columns) or a string in `%`
      width = config.doom.sidebar_width,
      -- side of the tree, can be one of 'left' | 'right' | 'top' | 'bottom'
      side = config.doom.explorer_right and "right" or "left",
      -- if true the tree will resize itself after opening a file
      auto_resize = true,
      mappings = {
        -- custom only false will merge the list with the default mappings
        -- if true, it will only use your list to set the mappings
        custom_only = false,
        -- list of mappings to set on the tree manually
        list = {
          { key = { "o", "<2-LeftMouse>" }, cb = tree_cb("edit") },
          { key = { "<CR>", "<2-RightMouse>", "<C-]>" }, cb = tree_cb("cd") },
          { key = "<C-v>", cb = tree_cb("vsplit") },
          { key = "<C-x>", cb = tree_cb("split") },
          { key = "<C-t>", cb = tree_cb("tabnew") },
          { key = "<BS>", cb = tree_cb("close_node") },
          { key = "<S-CR>", cb = tree_cb("close_node") },
          { key = "<Tab>", cb = tree_cb("preview") },
          { key = "I", cb = tree_cb("toggle_ignored") },
          { key = "H", cb = tree_cb("toggle_dotfiles") },
          { key = "R", cb = tree_cb("refresh") },
          { key = "a", cb = tree_cb("create") },
          { key = "d", cb = tree_cb("remove") },
          { key = "r", cb = tree_cb("rename") },
          { key = "<C-r>", cb = tree_cb("full_rename") },
          { key = "x", cb = tree_cb("cut") },
          { key = "c", cb = tree_cb("copy") },
          { key = "p", cb = tree_cb("paste") },
          { key = "[c", cb = tree_cb("prev_git_item") },
          { key = "]c", cb = tree_cb("next_git_item") },
          { key = "-", cb = tree_cb("dir_up") },
          { key = "q", cb = tree_cb("close") },
          { key = "g?", cb = tree_cb("toggle_help") },
        },
      },
    },
  })

  -- Make sure nvim-tree loads itself when lazy loaded
  vim.defer_fn(require("nvim-tree").refresh, 25)
end
