---[[---------------------------------------]]---
--         utils - Doom Nvim utilities         --
--              Author: NTBBloodbath           --
--              License: MIT                   --
---[[---------------------------------------]]---

-------------------- HELPERS --------------------
Api, Cmd, Fn = vim.api, vim.cmd, vim.fn
Keymap, Execute, G = Api.nvim_set_keymap, Api.nvim_command, vim.g
Scopes = { o = vim.o, b = vim.bo, w = vim.wo }

-- Local files
Doom_root = Fn.expand('$HOME/.config/doom-nvim')
Doom_logs = Doom_root .. '/logs/doom.log'
Doom_report = Doom_root .. '/logs/report.md'

-- Mappings wrapper, extracted from
-- https://github.com/ojroques/dotfiles/blob/master/nvim/init.lua#L8-L12
function Map(mode, lhs, rhs, opts)
	local options = { noremap = true }
	if opts then
		options = vim.tbl_extend('force', options, opts)
	end
	Keymap(mode, lhs, rhs, options)
end

-- Options wrapper, extracted from
-- https://github.com/ojroques/dotfiles/blob/master/nvim/init.lua#L14-L17
function Opt(scope, key, value)
	Scopes[scope][key] = value
	if scope ~= 'o' then
		Scopes['o'][key] = value
	end
end

-- For autocommands, extracted from
-- https://github.com/norcalli/nvim_utils
function Create_augroups(definitions)
	for group_name, definition in pairs(definitions) do
		Execute('augroup ' .. group_name)
		Execute('autocmd!')
		for _, def in ipairs(definition) do
			local command =
				table.concat(vim.tbl_flatten({ 'autocmd', def }), ' ')
			Execute(command)
		end
		Execute('augroup END')
	end
end

-- Check if string is empty or if it's nil
function Is_empty(str)
	return str == '' or str == nil
end

-- Search if a table have the value we are looking for,
-- useful for plugins management
function Has_value(tabl, val)
	for _, value in ipairs(tabl) do
		if value == val then
			return true
		end
	end

	return false
end

-- try/catch statements, see
-- https://gist.github.com/cwarden/1207556
function Catch(err)
	return err[1]
end

function Try(block)
	local status, result = pcall(block[1])
	if not status then
		block[2](result)
	end
	return result
end

-- A better and less primitive implementation of custom plugins in Doom Nvim
function Custom_plugins(plugins)
	local packer = require('packer')

	packer.use(plugins)
end

-- Get current OS, returns 'Other' if the current OS is not recognized
function Get_OS()
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
