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
    filetype plugin indent off
]])

-- Temporarily disable shada file to improve performance
vim.opt.shadafile = 'NONE'
-- Disable some unused built-in Neovim plugins
vim.g.loaded_gzip = false
vim.g.loaded_zipPlugin = false
vim.g.loaded_tarPlugin = false
vim.g.loaded_netrwPlugin = false
vim.g.loaded_2html_plugin = false

-- Utility functions
require('doom.utils')
-- Load default settings
require('doom.default')

local async

async = vim.loop.new_async(vim.schedule_wrap(function()
    -- Doom logging system
    log = require('doom.logging')
	-- Doom system detection (unused at the moment)
	-- require('doom.system')
	-- Doom functions
	require('doom.functions')

	---- Doom Configurations ------------------------
	-------------------------------------------------
	-- Load doomrc (user-defined configurations)
	require('doom.config.doomrc')
	-- Load main configurations and plugins
	require('doom.config')
	-- UI settings
	require('doom.config.ui')
	-- Doom keybindings
	require('doom.keybindings')
	-- Doom autocommands
	require('doom.autocmds')

	-- If the current buffer name is empty then trigger Dashboard
	if vim.api.nvim_buf_get_name(0):len() == 0 then
		vim.cmd('Dashboard')
	end

    vim.opt.shadafile = ''
	vim.defer_fn(function()
        vim.cmd [[
            rshada!
            doautocmd BufRead
            syntax on
            filetype plugin indent on
            silent! bufdo e
        ]]
    end, 15)

	async:close()
end))

async:send()
