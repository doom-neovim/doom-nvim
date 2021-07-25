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
	-- TODO: uncomment it after restructuring some things later
	-- Load plugins
	-- require('doom.modules')

	-- Load Doom core
	require('doom.core')

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

	vim.opt.shadafile = ''
	vim.defer_fn(function()
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
