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
		border = 'none', -- none, single, double, shadow
		position = 'bottom', -- bottom, top
		margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
		padding = { 1, 1, 1, 1 }, -- extra window padding [top, right, bottom, left]
	},
	layout = {
		height = { min = 4, max = 25 }, -- min and max height of the columns
		width = { min = 20, max = 80 }, -- min and max width of the columns
		spacing = 20, -- spacing between columns
	},
	hidden = { '<silent>', '^:', '^ ' }, -- hide mapping boilerplate
	show_help = true, -- show help message on the command line when the popup is visible
})
