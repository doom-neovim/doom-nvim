---[[---------------------------------------]]---
--         utils - Doom Nvim utilities         --
--              Author: NTBBloodbath           --
--              License: GPLv2                   --
---[[---------------------------------------]]---

local M = {}

-------------------- HELPERS --------------------
-- Doom Nvim version
M.doom_version = '3.0.4'

-- Local files
M.doom_root = vim.fn.expand('$HOME/.config/doom-nvim')
M.doom_logs = vim.fn.stdpath('data') .. '/doom.log'
M.doom_report = vim.fn.stdpath('data') .. '/doom_report.md'

M.git_workspace = string.format('git -C %s ', M.doom_root)

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

-- read_file returns the content of the given file
-- @tparam string path The path of the file
-- @return string
M.read_file = function(path)
	local fd = vim.loop.fs_open(path, 'r', 438)
	local stat = vim.loop.fs_fstat(fd)
	local data = vim.loop.fs_read(fd, stat.size, 0)
	vim.loop.fs_close(fd)

	return data
end

-- write_file writes the given string into given file
-- @tparam string path The path of the file
-- @tparam string content The content to be written in the file
-- @tparam string mode The mode for opening the file, e.g. 'w+'
M.write_file = function(path, content, mode)
	-- 644 sets read and write permissions for the owner, and it sets read-only
	-- mode for the group and others.
	vim.loop.fs_open(path, mode, tonumber('644', 8), function(err, fd)
		if not err then
			local fpipe = vim.loop.new_pipe(false)
			vim.loop.pipe_open(fpipe, fd)
			vim.loop.write(fpipe, content)
		end
	end)
end

return M
