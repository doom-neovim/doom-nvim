local tree_cb = require('nvim-tree.config').nvim_tree_callback

-- Empty by default
G.nvim_tree_ignore = { '.git', 'node_modules', '.cache', '__pycache__' }
-- False by default, opens the tree when typing `vim $DIR` or `vim`
G.nvim_tree_auto_open = 0
-- False by default, closes the tree when it is the last window
G.nvim_tree_auto_close = 0
-- False by default, closes the tree when you open a file
G.nvim_tree_quit_on_open = 1
-- False by default, this option allows the cursor to be updated when entering a buffer
G.nvim_tree_follow = 1
-- Show hidden files
G.nvim_tree_hide_dotfiles = Doom.show_hidden
-- Set tree width
G.nvim_tree_width = Doom.sidebar_width
-- False by default, this option shows indent markers when folders are open
G.nvim_tree_indent_markers = 1
-- False by default, will enable file highlight for git attributes (can be used without the icons).
G.nvim_tree_git_hl = 1
-- This is the default. See :help filename-modifiers for more options
G.nvim_tree_root_folder_modifier = ':~'
-- False by default, will open the tree when entering a new tab and the tree was previously open
G.nvim_tree_tab_open = 1
-- False by default, will not resize the tree when opening a file
G.nvim_tree_width_allow_resize = 1
-- False by default, append a trailing slash to folder names
G.nvim_tree_add_trailing = 1
-- False by default, compact folders that only contain a single folder into one node in the file tree
G.nvim_tree_group_empty = 1
--- Tree icons
-- If false, do not show the icons for one of 'git' 'folder' and 'files'
-- true by default, notice that if 'files' is 1, it will only display
-- if nvim-web-devicons is installed and on your runtimepath
G.nvim_tree_show_icons = { git = 1, folders = 1, files = 1 }
-- If the tagbar is set to left then set tree side to right and vice versa.
-- left by default
if Doom.tagbar_left == true then
    G.nvim_tree_side = 'right'
end
-- You can edit keybindings be defining this variable
-- You don't have to define all keys.
-- NOTE: the 'edit' key will wrap/unwrap a folder and open a file
G.nvim_tree_bindings = {
	-- default mappings
	['o'] = tree_cb('edit'),
	['<2-LeftMouse>'] = tree_cb('edit'),
	['<CR>'] = tree_cb('cd'),
	['<2-RightMouse>'] = tree_cb('cd'),
	['<C-]>'] = tree_cb('cd'),
	['<C-v>'] = tree_cb('vsplit'),
	['<C-x>'] = tree_cb('split'),
	['<C-t>'] = tree_cb('tabnew'),
	['<BS>'] = tree_cb('close_node'),
	['<S-CR>'] = tree_cb('close_node'),
	['<Tab>'] = tree_cb('preview'),
	['I'] = tree_cb('toggle_ignored'),
	['H'] = tree_cb('toggle_dotfiles'),
	['R'] = tree_cb('refresh'),
	['a'] = tree_cb('create'),
	['d'] = tree_cb('remove'),
	['r'] = tree_cb('rename'),
	['<C-r>'] = tree_cb('full_rename'),
	['x'] = tree_cb('cut'),
	['c'] = tree_cb('copy'),
	['p'] = tree_cb('paste'),
	['[c'] = tree_cb('prev_git_item'),
	[']c'] = tree_cb('next_git_item'),
	['-'] = tree_cb('dir_up'),
	['q'] = tree_cb('close'),
}

-- default will show icon by default if no icon is provided
-- default shows no icon by default
G.nvim_tree_icons = {
	default = '',
	symlink = '',
	git = {
		unstaged = '✗',
		staged = '✓',
		unmerged = '',
		renamed = '➜',
		untracked = '★',
	},
	folder = {
		default = '',
		open = '',
		empty = '',
		empty_open = '',
		symlink = '',
		symlink_open = '',
	},
}
