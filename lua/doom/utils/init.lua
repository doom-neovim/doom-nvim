---[[---------------------------------------]]---
--         utils - Doom Nvim utilities         --
--              Author: NTBBloodbath           --
--              License: MIT                   --
---[[---------------------------------------]]---

-------------------- HELPERS --------------------
Doom = {}

-- Local files
Doom_root = vim.fn.expand('$HOME/.config/doom-nvim')
Doom_logs = Doom_root .. '/logs/doom.log'
Doom_report = Doom_root .. '/logs/report.md'

-- mappings wrapper, extracted from
-- https://github.com/ojroques/dotfiles/blob/master/nvim/init.lua#L8-L12
function map(mode, lhs, rhs, opts)
	local options = { noremap = true }
	if opts then
		options = vim.tbl_extend('force', options, opts)
	end
	vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- For autocommands, extracted from
-- https://github.com/norcalli/nvim_utils
function create_augroups(definitions)
	for group_name, definition in pairs(definitions) do
		vim.api.nvim_command('augroup ' .. group_name)
		vim.api.nvim_command('autocmd!')
		for _, def in ipairs(definition) do
			local command =
				table.concat(vim.tbl_flatten({ 'autocmd', def }), ' ')
			vim.api.nvim_command(command)
		end
		vim.api.nvim_command('augroup END')
	end
end

-- Check if string is empty or if it's nil
function is_empty(str)
	return str == '' or str == nil
end

-- Search if a table have the value we are looking for,
-- useful for plugins management
function has_value(tabl, val)
	for _, value in ipairs(tabl) do
		if value == val then
			return true
		end
	end

	return false
end

-- try/catch statements, see
-- https://gist.github.com/cwarden/1207556
function catch(err)
	return err[1]
end

function try(block)
	local status, result = pcall(block[1])
	if not status then
		block[2](result)
	end
	return result
end

-- A better and less primitive implementation of custom plugins in Doom Nvim
function custom_plugins(plugins)
	require('packer').use(plugins)
end

-- Get current OS, returns 'Other' if the current OS is not recognized
function get_os()
	--[[
	--	 Target OS names:
	--	 	- Windows
	--	 	- Linux
	--	 	- OSX
	--	 	- BSD
	--	 	- POSIX
	--	 	- Other
	--]]

	-- We make use of JIT because LuaJIT is bundled in Neovim
	return jit.os
end
