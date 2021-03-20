---[[----------------------]]---
--    Vim-related wrappers    --
---]]----------------------[[---
-- Access to global variables
g = vim.g
-- Vim commands like 'colorscheme X'
cmd = vim.cmd

---------------------------------------------

return function()
    -- Empty by default
    g.nvim_tree_ignore = { '.git', 'node_modules', '.cache', '__pycache__' }
    -- False by default, opens the tree when typing `vim $DIR` or `vim`
    g.nvim_tree_auto_open = false
    -- False by default, closes the tree when it is the last window
    g.nvim_tree_auto_close = false
    -- False by default, closes the tree when you open a file
    g.nvim_tree_quit_on_open = true
    -- False by default, this option allows the cursor to be updated when entering a buffer
    g.nvim_tree_follow = true
    -- False by default, this option shows indent markers when folders are open
    g.nvim_tree_indent_markers = true
    -- False by default, will enable file highlight for git attributes (can be used without the icons).
    g.nvim_tree_git_hl = true
    -- This is the default. See :help filename-modifiers for more options
    g.nvim_tree_root_folder_modifier = ':~'
    -- False by default, will open the tree when entering a new tab and the tree was previously open
    g.nvim_tree_tab_open = true
    -- False by default, will not resize the tree when opening a file
    g.nvim_tree_width_allow_resize = true
    --- Tree icons
    -- If false, do not show the icons for one of 'git' 'folder' and 'files'
    -- true by default, notice that if 'files' is 1, it will only display
    -- if nvim-web-devicons is installed and on your runtimepath
    g.nvim_tree_show_icons = {
        git = 1,
        folders = 1,
        files = 1,
    }
    -- You can edit keybindings be defining this variable
    -- You don't have to define all keys.
    -- NOTE: the 'edit' key will wrap/unwrap a folder and open a file
    g.nvim_tree_bindings = {
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
    g.nvim_tree_icons = {
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
end
