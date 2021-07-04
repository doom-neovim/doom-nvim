---[[---------------------------------------]]---
--      functions - Doom Nvim Functions        --
--              Author: NTBBloodbath           --
--              License: MIT                   --
---[[---------------------------------------]]---

local utils = require('doom.utils')
local log = require('doom.core.logging')
local config = require('doom.core.config').load_config()

local M = {}

log.debug('Loading Doom functions module ...')

-- check_plugin checks if the given plugin exists
-- @tparam string plugin_name The plugin name, e.g. nvim-tree.lua
-- @tparam string path Where should be searched the plugin in packer's path, defaults to `start`
-- @return bool
M.check_plugin = function(plugin_name, path)
	if not path then
		path = 'start'
	end

	return vim.fn.isdirectory(
		vim.fn.stdpath('data')
			.. '/site/pack/packer/'
			.. path
			.. '/'
			.. plugin_name
	) == 1
end

-- is_plugin_disabled checks if the given plugin is disabled in doomrc
-- @tparam string plugin The plugin identifier, e.g. statusline
-- @return bool
M.is_plugin_disabled = function(plugin)
	local doomrc = require('doom.core.config.doomrc').load_doomrc()

	-- Iterate over all doomrc sections (e.g. ui) and their plugins
	for _, section in pairs(doomrc) do
		if utils.has_value(section, plugin) then
			return false
		end
	end

	return true
end

-- Load user-defined settings from the Neovim field in the doomrc
-- @param settings_tbl The settings table to iterate over
-- @param scope The settings scope, e.g. autocmds
M.load_custom_settings = function(settings_tbl, scope)
	-- If the provided settings table is not empty
	if next(settings_tbl) ~= nil then
		log.debug('Loading custom ' .. scope .. ' ...')
		if scope == 'autocmds' then
			utils.create_augroups(settings_tbl)
		elseif scope == 'commands' then
			for _, cmd in ipairs(settings_tbl) do
				vim.cmd(cmd)
			end
		elseif scope == 'functions' then
			for _, func_body in pairs(settings_tbl) do
				func_body()
			end
		elseif scope == 'mappings' then
			local opts = { silent = true }
			for _, map in ipairs(settings_tbl) do
				-- scope, lhs, rhs, options
				map(map[1], map[2], map[3], opts)
			end
		elseif scope == 'variables' then
			for var, val in pairs(settings_tbl) do
				vim.g[var] = val
			end
		end
	end
end

-- Quit Neovim and change the colorscheme at doomrc if the colorscheme is not the same,
-- dump all messages to doom.log file
-- @tparam bool write If doom should save before exiting
-- @tparam bool force If doom should force the exiting
M.quit_doom = function(write, force)
	local changed_colorscheme, err = pcall(function()
		log.info('Checking if the colorscheme was changed ...')
		local target = vim.g.colors_name
		if target ~= config.doom.colorscheme then
			vim.cmd(
				'silent !sed -i "s/\''
					.. config.doom.colorscheme
					.. "'/'"
					.. target
					.. '\'/" $HOME/.config/doom-nvim/doomrc'
			)
			log.info('Colorscheme successfully changed to ' .. target)
		end
	end)

	if not changed_colorscheme then
		log.error('Unable to write to the doomrc. Traceback:\n' .. err)
	end

	local quit_cmd = ''

	-- Save current session if enabled
	if config.doom.autosave_sessions then
		vim.cmd('SaveSession')
	end

	if write then
		quit_cmd = 'wa | '
	end
	if force then
		vim.cmd(quit_cmd .. 'qa!')
	else
		vim.cmd(quit_cmd .. 'q!')
	end
end

-- check_updates checks for plugins updates
M.check_updates = function()
	local updated_plugins, err = pcall(function()
		log.info('Updating the outdated plugins ...')
		vim.cmd('PackerSync')
	end)

	if not updated_plugins then
		log.error('Unable to update plugins. Traceback:\n' .. err)
	end
end

-- create_report creates a markdown report. It's meant to be used when a bug
-- occurs, useful for debugging issues.
M.create_report = function()
	local date = os.date('%Y-%m-%d %H:%M:%S')

	local created_report, err = pcall(function()
		vim.cmd(
			'silent !echo "'
				.. vim.fn.fnameescape('#')
				.. ' doom crash report" >> '
				.. utils.doom_report
		)
		vim.cmd(
			'silent !echo "Report date: '
				.. date
				.. '" >> '
				.. utils.doom_report
		)
		vim.cmd(
			'silent !echo "'
				.. vim.fn.fnameescape('##')
				.. ' Begin log dump" >> '
				.. utils.doom_report
		)
		vim.cmd(
			'silent !cat '
				.. utils.doom_logs
				.. ' | grep "$(date +%a %d %b %Y)" >> '
				.. utils.doom_report
		)
		vim.cmd(
			'silent !echo "'
				.. vim.fn.fnameescape('##')
				.. ' End log dump" >> '
				.. utils.doom_report
		)
		log.info('Report created at ' .. utils.doom_report)
	end)

	if not created_report then
		log.error('Error while writing report. Traceback:\n' .. err)
	end
end

return M
