---[[---------------------------------------]]---
--        autocmds - Doom Nvim Autocmds        --
--              Author: NTBBloodbath           --
--              License: MIT                   --
---[[---------------------------------------]]---

local utils = require('doom.utils')
local log = require('doom.core.logging')

log.debug('Loading Doom autocmds module ...')

local autocmds = {
	doom_core = {
		-- Compile new plugins changes at save
		{
			'BufWritePost',
			'init.lua,doomrc',
			'PackerCompile profile=true',
		},
	},
	doom_extras = {
		-- Set up vim_buffer_previewer in telescope.nvim
		{ 'User', 'TelescopePreviewerLoaded', 'setlocal wrap' },
		-- Disable tabline on Dashboard
		{
			'FileType',
			'dashboard',
			'set showtabline=0 | autocmd WinLeave <buffer> set showtabline=2',
		},
	},
}

-- Set proper syntax highlight for our doomrc
if vim.api.nvim_buf_get_name(0):find('doomrc', 0, true) then
	vim.cmd([[ set ft=lua ]])
end

-- Set relative numbers
if Doom.relative_num then
	table.insert(autocmds['doom_core'], {
		'BufEnter,WinEnter',
		'*',
		'if &nu | set rnu | endif',
	})
	table.insert(autocmds['doom_core'], {
		'BufLeave,WinEnter',
		'*',
		'if &nu | set nornu | endif',
	})
end

-- Install plugins on launch
if Doom.auto_install_plugins then
	vim.defer_fn(function()
		vim.cmd('PackerInstall')
	end, 200)
end

-- Set autosave
if Doom.autosave then
	table.insert(autocmds['doom_core'], {
		'TextChanged,TextChangedI',
		'<buffer>',
		'silent! write',
	})
end

-- Enable auto comment
if not Doom.auto_comment then
	table.insert(autocmds['doom_core'], {
		{
			'BufEnter',
			'*',
			'setlocal formatoptions-=c formatoptions-=r formatoptions-=o',
		},
	})

	vim.cmd([[ setlocal formatoptions-=c formatoptions-=r formatoptions-=o ]])
end

-- Enable highlight on yank
if Doom.highlight_yank then
	table.insert(autocmds['doom_core'], {
		{
			'TextYankPost',
			'*',
			"lua require('vim.highlight').on_yank({higroup = 'Search', timeout = 200})",
		},
	})
end

-- Format on save
-- NOTE: Requires formatter to be enabled!
if Doom.fmt_on_save then
	table.insert(autocmds['doom_core'], {
		'BufWritePost',
		'*',
		'FormatWrite',
	})
end

-- Preserve last editing position
if Doom.preserve_edit_pos then
	table.insert(autocmds['doom_core'], {
		'BufReadPost',
		'*',
		[[
            if line("'\"") > 1 && line("'\"") <= line("$") |
                exe "normal! g'\"" |
            endif
        ]],
	})

	vim.cmd([[
        if line("'\"") > 1 && line("'\"") <= line("$") |
            exe "normal! g'\"" |
        endif
    ]])
end

-- Create augroups
utils.create_augroups(autocmds)
