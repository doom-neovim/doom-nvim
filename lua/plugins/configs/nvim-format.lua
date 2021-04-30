require('format').setup({
	['*'] = {
		-- remove trailing whitespaces
		{
			cmd = {
				"sed -i 's/[ \t]*$//'",
			},
		},
	},
	vim = {
		{
			cmd = {
				function(file)
					return string.format(
						'stylua --config-path ~/.config/stylua/stylua.toml %s',
						file
					)
				end,
			},
			start_pattern = '^lua << EOF$',
			end_pattern = '^EOF$',
		},
	},
	vimwiki = {
		{
			cmd = { 'prettier -w --parser babel' },
			start_pattern = '^{{{javascript$',
			end_pattern = '^}}}$',
		},
	},
	lua = {
		{
			cmd = {
				function(file)
					return string.format(
						'stylua --config-path ~/.config/stylua/stylua.toml %s',
						file
					)
				end,
			},
		},
	},
	python = {
		{
			cmd = {
				'yapf -i',
			},
		},
	},
	go = {
		{
			cmd = {
				'gofmt -w',
				'goimports -w',
			},
			tempfile_postfix = '.tmp',
		},
	},
	javascript = {
		{
			cmd = {
				'prettier -w',
				'./node_modules/.bin/eslint --fix',
			},
		},
	},
	markdown = {
		{
			cmd = { 'prettier -w' },
		},
		{
			cmd = {
				'yapf -i',
			},
			start_pattern = '^```python$',
			end_pattern = '^```$',
			target = 'current',
		},
	},
})
