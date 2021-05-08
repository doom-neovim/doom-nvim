require('which-key').setup({
	plugins = {
		marks = false,
		registers = false,
		presets = {
			operators = false,
			motions = true,
			text_objects = true,
			windows = true,
			nav = true,
			z = true,
			g = true,
		},
	},
	operators = {
		d = 'Delete',
		c = 'Change',
		y = 'Yank (copy)',
		['g~'] = 'Toggle case',
		['gu'] = 'Lowercase',
		['gU'] = 'Uppercase',
		['>'] = 'Indent right',
		['<lt>'] = 'Indent left',
		['zf'] = 'Create fold',
		['!'] = 'Filter though external program',
		-- ['v'] = 'Visual Character Mode',
		gc = 'Comments',
	},
	icons = {
		breadcrumb = '»', -- symbol used in the command line area that shows your active key combo
		separator = '➜', -- symbol used between a key and it's label
		group = '+', -- symbol prepended to a group
	},
	window = {
		padding = { 0, 0, 0, 0 }, -- extra window padding [top, right, bottom, left]
	},
	layout = {
		height = { min = 1, max = 10 }, -- min and max height of the columns
	},
	hidden = { '<silent>', '^:', '^ ' }, -- hide mapping boilerplate
	show_help = true, -- show help message on the command line when the popup is visible
    triggers = {"<leader>"}, -- automatically setup triggers
  -- triggers = {"<leader>"} -- or specifiy a list manually
})
--Cmd('highlight WhichKeyFloat guibg='..Doom.whichkey_bg')

