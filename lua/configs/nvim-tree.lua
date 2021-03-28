-- Empty by default
vim.g.nvim_tree_ignore = { '.git', 'node_modules', '.cache', '__pycache__' }
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
-- False by default, will enable file highlight for git attributes (can be used without the icons).
vim.g.nvim_tree_git_hl = 1
-- This is the default. See :help filename-modifiers for more options
vim.g.nvim_tree_root_folder_modifier = ':~'
-- False by default, will open the tree when entering a new tab and the tree was previously open
vim.g.nvim_tree_tab_open = 1
-- False by default, will not resize the tree when opening a file
vim.g.nvim_tree_width_allow_resize = 1
--- Tree icons
-- If false, do not show the icons for one of 'git' 'folder' and 'files'
-- true by default, notice that if 'files' is 1, it will only display
-- if nvim-web-devicons is installed and on your runtimepath
vim.g.nvim_tree_show_icons = {
    git = 1,
    folders = 1,
    files = 1,
}
-- You can edit keybindings be defining this variable
-- You don't have to define all keys.
-- NOTE: the 'edit' key will wrap/unwrap a folder and open a file
vim.g.nvim_tree_bindings = {
    edit            = {"<CR>", "o"},
    edit_vsplit     = "<C-v>",
    edit_split      = "<C-x>",
    edit_tab        = "<C-t>",
    close_node      = {"<S-CR>", "<BS>"},
    toggle_ignored  = "I",
    toggle_dotfiles = "H",
    refresh         = "R",
    preview         = "<Tab>",
    cd              = "<CR>",
    create          = "n",
    remove          = "d",
    rename          = "r",
    cut             = "x",
    copy            = "c",
    paste           = "p",
    prev_git_item   = "[c",
    next_git_item   = "]c",
    dir_up          = "-",
    close           = "q",
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
        untracked = "★"
    },
    folder = {
        default = "",
        open = "",
        symlink = "",
    }
}
