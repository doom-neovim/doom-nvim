return function()
  local config = require("doom.core.config").load_config()
  local tree_cb = require("nvim-tree.config").nvim_tree_callback

  -- Empty by default
  vim.g.nvim_tree_ignore = { ".git", "node_modules", ".cache", "__pycache__" }
  -- False by default, opens the tree when typing `vim $DIR` or `vim`
  vim.g.nvim_tree_auto_open = 0
  -- False by default, closes the tree when it is the last window
  vim.g.nvim_tree_auto_close = 0
  -- False by default, closes the tree when you open a file
  vim.g.nvim_tree_quit_on_open = 1
  -- False by default, this option allows the cursor to be updated when entering a buffer
  vim.g.nvim_tree_follow = 1
  -- False by default, this option shows indent markers when folders are open
  vim.g.nvim_tree_indent_markers = 1
  -- Show hidden files
  vim.g.nvim_tree_hide_dotfiles = config.doom.show_hidden
  -- Set tree width
  vim.g.nvim_tree_width = config.doom.sidebar_width
  -- False by default, will enable file highlight for git attributes (can be used without the icons).
  vim.g.nvim_tree_git_hl = 1
  -- This is the default. See :help filename-modifiers for more options
  vim.g.nvim_tree_root_folder_modifier = ":~"
  -- False by default, will open the tree when entering a new tab and the tree was previously open
  vim.g.nvim_tree_tab_open = 1
  -- False by default, will not resize the tree when opening a file
  vim.g.nvim_tree_width_allow_resize = 1
  -- False by default, append a trailing slash to folder names
  vim.g.nvim_tree_add_trailing = 1
  -- False by default, compact folders that only contain a single folder into one node in the file tree
  vim.g.nvim_tree_group_empty = 1
  --- Tree icons
  -- If false, do not show the icons for one of 'git' 'folder' and 'files'
  -- true by default, notice that if 'files' is 1, it will only display
  -- if nvim-web-devicons is installed and on your runtimepath
  vim.g.nvim_tree_show_icons = { git = 1, folders = 1, files = 1 }
  if config.doom.explorer_right then
    vim.g.nvim_tree_side = "right"
  end
  -- You can edit keybindings be defining this variable
  -- You don't have to define all keys.
  -- NOTE: the 'edit' key will wrap/unwrap a folder and open a file
  vim.g.nvim_tree_bindings = {
    -- default mappings
    { key = "o", cb = tree_cb("edit") },
    { key = "<2-LeftMouse>", cb = tree_cb("edit") },
    { key = "<CR>", cb = tree_cb("cd") },
    { key = "<2-RightMouse>", cb = tree_cb("cd") },
    { key = "<C-]>", cb = tree_cb("cd") },
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
  }

  -- default will show icon by default if no icon is provided
  -- default shows no icon by default
  vim.g.nvim_tree_icons = {
    default = "",
    symlink = "",
    git = {
      unstaged = "✗",
      staged = "✓",
      unmerged = "",
      renamed = "➜",
      untracked = "★",
    },
    folder = {
      default = "",
      open = "",
      empty = "",
      empty_open = "",
      symlink = "",
      symlink_open = "",
    },
  }

  -- Make sure nvim-tree loads itself when lazy loaded
  vim.defer_fn(require("nvim-tree").refresh, 25)
end
