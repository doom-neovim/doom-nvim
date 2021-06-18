return function()
	local ts = require('nvim-treesitter.configs')
	vim.cmd('silent! luafile ' .. require('doom.utils').doom_root .. '/doomrc')

	ts.setup({
		ensure_installed = Doom.ts_parsers,
		highlight = { enable = true },
		autopairs = { enable = true },
		indent = { enable = true },
	})
end
