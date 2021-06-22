---[[---------------------------------------]]---
--         utils - Doom Nvim utilities         --
--              Author: NTBBloodbath           --
--              License: MIT                   --
---[[---------------------------------------]]---

local M = {}

-------------------- HELPERS --------------------
-- Doom Nvim version
M.doom_version = '2.3.2'

-- Local files
M.doom_root = vim.fn.expand('$HOME/.config/doom-nvim')
M.doom_logs = vim.fn.stdpath('data') .. '/doom.log'
M.doom_report = vim.fn.stdpath('data') .. '/doom_report.md'

-- mappings wrapper, extracted from
-- https://github.com/ojroques/dotfiles/blob/master/nvim/init.lua#L8-L12
M.map = function(mode, lhs, rhs, opts)
	local options = { noremap = true }
	if opts then
		options = vim.tbl_extend('force', options, opts)
	end
	vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- For autocommands, extracted from
-- https://github.com/norcalli/nvim_utils
M.create_augroups = function(definitions)
	for group_name, definition in pairs(definitions) do
		vim.api.nvim_command('augroup ' .. group_name)
		vim.api.nvim_command('autocmd!')
		for _, def in ipairs(definition) do
			local command = table.concat(
				vim.tbl_flatten({ 'autocmd', def }),
				' '
			)
			vim.api.nvim_command(command)
		end
		vim.api.nvim_command('augroup END')
	end
end

-- Check if string is empty or if it's nil
-- @return bool
M.is_empty = function(str)
	return str == '' or str == nil
end

-- Search if a table have the value we are looking for,
-- useful for plugins management
M.has_value = function(tabl, val)
	for _, value in ipairs(tabl) do
		if value == val then
			return true
		end
	end

	return false
end

-- Get current OS, returns 'Other' if the current OS is not recognized
M.get_os = function()
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

return M
