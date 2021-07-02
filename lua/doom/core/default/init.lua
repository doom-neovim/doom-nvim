---[[---------------------------------------]]---
--         default - Doom Nvim defaults        --
--              Author: NTBBloodbath           --
--              License: MIT                   --
---[[---------------------------------------]]---

local functions = require('doom.core.functions')
local log = require('doom.core.logging')

local M = {}

log.debug('Loading Doom defaults module ...')

-- load_default_options sets and loads default Doom options based on doomrc values
M.load_default_options = function()
	----- Default Neovim configurations
	-- Set colorscheme
	vim.cmd('colorscheme ' .. Doom.colorscheme)
	vim.opt.background = Doom.colorscheme_bg
	vim.cmd('highlight WhichKeyFloat guibg=' .. Doom.whichkey_bg)

	--- Set default options
	vim.opt.encoding = 'utf-8'

	-- Global options
	vim.opt.wildmenu = true
	vim.opt.autoread = true
	vim.opt.smarttab = true
	vim.opt.hidden = true
	vim.opt.hlsearch = true
	vim.opt.laststatus = 2
	vim.opt.backspace = { 'indent', 'eol', 'start' }
	vim.opt.updatetime = 200
	vim.opt.timeoutlen = 500
	vim.opt.completeopt = {
		'menu',
		'menuone',
		'preview',
		'noinsert',
		'noselect',
	}
	vim.opt.shortmess:append('atsc')
	vim.opt.inccommand = 'split'
	vim.opt.path = '**'
	vim.opt.signcolumn = 'yes'

	-- Buffer options
	vim.opt.autoindent = true
	vim.opt.smartindent = true
	vim.opt.copyindent = true
	vim.opt.preserveindent = true

	-- set Gui Fonts
	vim.opt.guifont = Doom.guifont .. ':h' .. Doom.guifont_size

	-- Use clipboard outside vim
	if Doom.clipboard then
		vim.opt.clipboard = 'unnamedplus'
	end

	if Doom.line_highlight then
		vim.opt.cursorline = true
	else
		vim.opt.cursorline = false
	end

	-- Automatic split locations
	if Doom.split_right then
		vim.opt.splitright = true
	else
		vim.opt.splitright = false
	end

	if Doom.split_below then
		vim.opt.splitbelow = true
	else
		vim.opt.splitbelow = false
	end

	-- Enable scroll off
	if Doom.scrolloff then
		vim.opt.scrolloff = Doom.scrolloff_amount
	end

	-- Enable showmode
	if not Doom.show_mode then
		vim.opt.showmode = false
	else
		vim.opt.showmode = true
	end

	-- Enable mouse input
	if Doom.mouse then
		vim.opt.mouse = 'a'
	end

	-- Enable wrapping
	if not Doom.line_wrap then
		vim.opt.wrap = false
	else
		vim.opt.wrap = true
	end

	-- Enable swap files
	if not Doom.swap_files then
		vim.opt.swapfile = false
	else
		vim.opt.swapfile = true
	end

	-- Set numbering
	if Doom.relative_num then
		vim.opt.number = true
		vim.opt.relativenumber = true
	else
		vim.opt.number = true
	end

	-- Checks to see if undo_dir does not exist. If it doesn't, it will create a undo folder
	local undo_dir = vim.fn.stdpath('config') .. Doom.undo_dir
	if Doom.backup and vim.fn.empty(vim.fn.glob(undo_dir)) > 0 then
		vim.api.nvim_command('!mkdir ' .. undo_dir .. ' -p')
		vim.opt.undofile = true
	end

	-- If backup is false but `undo_dir` still exists then it will delete it.
	if not Doom.backup and vim.fn.empty(vim.fn.glob(undo_dir)) == 0 then
		vim.api.nvim_command('!rm -rf ' .. undo_dir)
		vim.opt.undofile = false
	end

	-- Set local-buffer options
	if Doom.expand_tabs then
		vim.opt.expandtab = true
	else
		vim.opt.expandtab = false
	end
	vim.opt.tabstop = Doom.indent
	vim.opt.shiftwidth = Doom.indent
	vim.opt.softtabstop = Doom.indent
	vim.opt.colorcolumn = tostring(Doom.max_columns)
	vim.opt.conceallevel = Doom.conceallevel
end

-- Custom Doom Nvim commands
M.custom_options = function()
	-- Set a custom command to update Doom Nvim
	-- can be called by using :DoomUpdate
	vim.cmd(
		'command! DoomUpdate !git -C ~/.config/doom-nvim/ stash -q && git -C ~/.config/doom-nvim/ pull && git -C ~/.config/doom-nvim/ stash pop -q'
	)

	-- Load user-defined settings from the Neovim field in the doomrc file
	functions.load_custom_settings(Neovim.autocmds, 'autocmds')
	functions.load_custom_settings(Neovim.commands, 'commands')
	functions.load_custom_settings(Neovim.functions, 'functions')
	functions.load_custom_settings(Neovim.mappings, 'mappings')
	functions.load_custom_settings(Neovim.global_variables, 'variables')
end

return M
