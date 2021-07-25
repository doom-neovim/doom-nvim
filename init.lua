---[[---------------------------------------]]---
--      init.lua - Init file of Doom Nvim      --
--             Author: NTBBloodbath            --
--             License: GPLv2                  --
---[[---------------------------------------]]---

---- Doom Utilities -----------------------------
-------------------------------------------------
-- Store startup time in seconds
vim.g.start_time = vim.fn.reltime()

-- Disable these for very fast startup time
vim.cmd([[
	syntax off
	filetype off
    filetype plugin indent off
]])

-- Temporarily disable shada file to improve performance
vim.opt.shadafile = 'NONE'
-- Disable some unused built-in Neovim plugins
vim.g.loaded_man = false
vim.g.loaded_gzip = false
vim.g.loaded_netrwPlugin = false
vim.g.loaded_tarPlugin = false
vim.g.loaded_zipPlugin = false
vim.g.loaded_2html_plugin = false
vim.g.loaded_remote_plugins = false

---- Doom Configurations ------------------------
-------------------------------------------------
vim.defer_fn(function()
	local log = require('doom.extras.logging')

	-- Load Doom stuff (core, extras, modules)
	local doom_modules = { 'core', 'extras', 'modules' }
	for i = 1, #doom_modules, 1 do
		local ok, err = xpcall(
			require,
			debug.traceback,
			string.format('doom.%s', doom_modules[i])
		)
		if not ok then
			log.error(
				string.format(
					"There was an error loading the module 'doom.%s'. Traceback:\n%s",
					doom_modules[i],
					err
				)
			)
		end
	end

	-- If the dashboard plugin is already installed and the packer_compiled.lua
	-- file exists so we can make sure that the dashboard have been loaded.
	local compiled_plugins_path = vim.fn.expand(
		'$HOME/.config/doom-nvim/plugin/packer_compiled.lua'
	)
	if vim.fn.filereadable(compiled_plugins_path) > 0 then
		-- If the current buffer name is empty then trigger Dashboard.
		-- NOTE: this is done to avoid some weird issues with Dashboard and
		--       number / signcolumn when Dashboard gets triggered automatically
		if vim.api.nvim_buf_get_name(0):len() == 0 then
			vim.cmd('Dashboard')
		end
	end

	vim.defer_fn(function()
		vim.opt.shadafile = ''
		vim.cmd([[
            rshada!
            doautocmd BufRead
            syntax on
            filetype on
            filetype plugin indent on
            PackerLoad nvim-treesitter
            PackerLoad which-key.nvim
            silent! bufdo e
        ]])
	end, 10)
end, 0)
