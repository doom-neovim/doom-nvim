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
		log.info('Checking if the colorscheme or background were changed ...')
		local target_colorscheme = vim.g.colors_name
		local target_background = vim.opt.background:get()

		if target_colorscheme ~= config.doom.colorscheme then
			vim.cmd(
				'silent !sed -i "s/\''
					.. config.doom.colorscheme
					.. "'/'"
					.. target_colorscheme
					.. '\'/" $HOME/.config/doom-nvim/doom_config.lua'
			)
			log.info(
				'Colorscheme successfully changed to ' .. target_colorscheme
			)
		end
		if target_background ~= config.doom.colorscheme_bg then
			vim.cmd(
				'silent !sed -i "s/\''
					.. config.doom.colorscheme_bg
					.. "'/'"
					.. target_background
					.. '\'/" $HOME/.config/doom-nvim/doom_config.lua'
			)
			log.info('Background successfully changed to ' .. target_background)
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

-- save_backup_hashes saves the commits or releases SHA for future rollbacks
local function save_backup_hashes()
	-- Check for the current branch
	local branch_handler = io.popen(
		utils.git_workspace .. 'branch --show-current'
	)
	local git_branch = branch_handler:read('a'):gsub('[\r\n]', '')
	branch_handler:close()

	if git_branch == 'main' then
		local releases_database_path = string.format(
			'%s/.doom_releases',
			utils.doom_root
		)

		-- Fetch for a file containing the releases tags
		log.info('Saving the Doom releases for future rollbacks ...')
		local saved_releases, releases_err = pcall(function()
			-- Get the releases
		    log.debug('Executing "' .. utils.git_workspace .. 'show-ref --tags"')
			local releases_handler = io.popen(
				utils.git_workspace .. 'show-ref --tags'
			)
			local doom_releases = releases_handler:read('a')
			releases_handler:close()

			-- Put all the releases into a table so we can sort them later
			local releases = {}
			for release in doom_releases:gmatch('[^\r\n]+') do
				table.insert(releases, release)
			end
			-- Sort the releases table
		    local sorted_releases = {}
			for idx, release in ipairs(releases) do
				sorted_releases[#releases + 1 - idx] = release:gsub("refs/tags/", "")
			end

			-- Check if the database already exists so we can check if the
			-- database is up-to-date or if we should override it.
			--
			-- If the database does not exist yet then we will create it
			if vim.fn.filereadable(releases_database_path) == 1 then
				local current_releases = utils.read_file(releases_database_path)
				if current_releases ~= doom_releases then
					-- Write the first release in the list with 'w+' so the
					-- actual content will be overwritten by this one
					utils.write_file(
						releases_database_path,
						sorted_releases[1] .. '\n',
						'w+'
					)
					-- Write the rest of the releases
					for idx, release in ipairs(sorted_releases) do
						-- Exclude the first release because we have already
						-- written it in the database file
						if idx ~= 1 then
							utils.write_file(
								releases_database_path,
								release .. '\n',
								'a+'
							)
						end
					end
				end
			else
				for _, release in ipairs(sorted_releases) do
					utils.write_file(
						releases_database_path,
						release .. '\n',
						'a+'
					)
				end
			end
		end)

		if not saved_releases then
			log.error(
				'Error while saving the Doom releases. Traceback:\n'
					.. releases_err
			)
		end
	else
		-- Get the current commit SHA and store it into a hidden file
		log.info('Saving the current commit SHA for future rollbacks ...')
		local saved_backup_hash, backup_err = pcall(function()
			os.execute(
				utils.git_workspace
					.. 'rev-parse --short HEAD > '
					.. utils.doom_root
					.. '/.doom_backup_hash'
			)
		end)

		if not saved_backup_hash then
			log.error(
				'Error while saving the backup commit hash. Traceback:\n'
					.. backup_err
			)
		end
	end
end

-- update_doom saves the current commit/release hash into a file for future
-- restore if needed and then updates Doom.
M.update_doom = function()
	save_backup_hashes()

	log.info('Pulling Doom remote changes ...')
	local updated_doom, update_err = pcall(function()
		os.execute(utils.git_workspace .. 'pull -q')
	end)

	if not updated_doom then
		log.error('Error while updating Doom. Traceback:\n' .. update_err)
	end
	-- Run syntax_on event to fix UI if it's broke after the git pull
	vim.cmd('syntax on')

	log.info('Successfully updated Doom, please restart')
end

-- rollback_doom will rollback the local doom version to an older one
-- in case that the local one is broken
M.rollback_doom = function()
	-- Backup file for main (stable) branch
	local releases_database_path = string.format(
		'%s/.doom_releases',
		utils.doom_root
	)
	-- Backup file for development branch
	local rolling_backup = string.format(
		'%s/.doom_backup_hash',
		utils.doom_root
	)

	-- Check if there's a rollback file and sets the rollback type
	if vim.fn.filereadable(releases_database_path) == 1 then
		-- Get the releases database and split it into a table
		local doom_releases = utils.read_file(releases_database_path)

		-- Put all the releases into a table so we can sort them later
		local releases = {}
		for release in doom_releases:gmatch('[^\r\n]+') do
			table.insert(releases, release)
		end
		-- Sort the releases table
		local sorted_releases = {}
		for idx, release in ipairs(releases) do
			sorted_releases[#releases + 1 - idx] = release:gsub("refs/tags/", "")
		end

		-- Check the current commit hash and compare it with the ones in the
		-- releases table
		local current_version
		local commit_handler = io.popen(utils.git_workspace .. 'rev-parse HEAD')
		local current_commit = commit_handler:read('a'):gsub('[\r\n]', '')
		commit_handler:close()
		for _, version_info in ipairs(sorted_releases) do
		    for release_hash, version in version_info:gmatch('(%w+)%s(%w+%W+%w+%W+%w+)') do
		        if release_hash == current_commit then
		            current_version = version
		        end
		    end
		end
		-- If the current_version variable is still nil then
		-- fallback to latest version
		if not current_version then
		    -- next => index, SHA vX.Y.Z
		    local _, release_info = next(releases, nil)
		    -- split => { SHA, vX.Y.Z }, [2] => vX.Y.Z
		    current_version = vim.split(release_info, ' ')[2]
		end

        local rollback_sha, rollback_version
        local break_loop = false
		for _, version_info in ipairs(releases) do
	        for commit_hash, release in version_info:gmatch('(%w+)%s(%w+%W+%w+%W+%w+)') do
		        if release:gsub('v', '') < current_version:gsub('v', '') then
		            rollback_sha = commit_hash
		            rollback_version = release
		            break_loop = true
		            break
		        end
	        end
	        if break_loop then
	            break
	        end
		end

        log.info('Reverting back to version ' .. rollback_version .. ' (' .. rollback_sha .. ') ...')
		local rolled_back, rolled_err = pcall(function()
			os.execute(utils.git_workspace .. 'checkout ' .. rollback_sha)
		end)

		if not rolled_back then
			log.error(
				'Error while rolling back to version '
				    .. rollback_version
				    .. ' ('
					.. rollback_sha
					.. '). Traceback:\n'
					.. rolled_err
			)
		end

		log.info(
			'Successfully rolled back Doom to version '
			    .. rollback_version
			    .. ' ('
				.. rollback_sha
				.. '), please restart'
		)

	elseif vim.fn.filereadable(rolling_backup) == 1 then
		local backup_commit = utils.read_file(rolling_backup):gsub(
			'[\r\n]+',
			''
		)
		log.info('Reverting back to commit ' .. backup_commit .. ' ...')
		local rolled_back, rolled_err = pcall(function()
			os.execute(utils.git_workspace .. 'checkout ' .. backup_commit)
		end)

		if not rolled_back then
			log.error(
				'Error while rolling back to commit '
					.. backup_commit
					.. '. Traceback:\n'
					.. rolled_err
			)
		end

		log.info(
			'Successfully rolled back Doom to commit '
				.. backup_commit
				.. ', please restart'
		)
	else
		log.error('There are no backup files to rollback')
	end
end

return M
