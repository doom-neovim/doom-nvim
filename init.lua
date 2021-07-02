---[[---------------------------------------]]---
--      init.lua - Init file of Doom Nvim      --
--             Author: NTBBloodbath            --
--             License: MIT                    --
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

local async

async = vim.loop.new_async(vim.schedule_wrap(function()
	---- Doom Configurations ------------------------
	-------------------------------------------------
	vim.defer_fn(function()
		-- Load Doom core
		require('doom.core')

		-- If the current buffer name is empty then trigger Dashboard
		if vim.api.nvim_buf_get_name(0):len() == 0 then
			vim.cmd('Dashboard')
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
                silent! bufdo e
            ]])
		end, 15)
	end, 0)

	async:close()
end))

async:send()
