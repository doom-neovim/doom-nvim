---[[---------------------------------------]]---
--        autocmds - Doom Nvim Autocmds        --
--              Author: NTBBloodbath           --
--              License: GPLv2                   --
---[[---------------------------------------]]---

local autocmds = {
	doom_core = {
		-- Set proper syntax highlight for our doomrc
		{ 'BufNewFile,BufRead', 'doomrc', 'set ft=lua' },
		-- Ensure every file does full syntax highlight
		{ 'BufEnter', '*', ':syntax sync fromstart' },
		{ 'BufEnter', '*', ':set signcolumn=yes' },
		{
			'BufEnter',
			'*',
			':set pumblend=' .. Doom.complete_transparency,
		},
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
	table.insert(autocmds['doom_core'], {
		'VimEnter',
		'*',
		'PackerInstall',
	})
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
			'BufWinEnter',
			'*',
			'setlocal formatoptions-=c formatoptions-=r formatoptions-=o',
		},
	})
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
end

-- If logging level is greater than 0 then dump :messages to doom.log on exit
if Doom.logging >= 1 then
	table.insert(autocmds['doom_core'], {
		'VimLeave',
		'*',
		':lua Dump_messages()',
	})
end

-- Create augroups
Create_augroups(autocmds)
