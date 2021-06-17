---[[---------------------------------------]]---
--      functions - Doom Nvim Functions        --
--              Author: NTBBloodbath           --
--              License: MIT                   --
---[[---------------------------------------]]---

local log = require('doom.core.logging')

local M = {}

log.debug('Loading Doom functions module ...')

-- check_plugin checks if the given plugin exists
-- @tparam string plugin_path The plugin name
-- @tparam bool opt If the plugin should be searched in packer's opt dir
-- @return bool
M.check_plugin = function(plugin_path, opt)
	if opt then
		return vim.fn.isdirectory(
			vim.fn.stdpath('data')
				.. '/site/pack/packer/opt/'
				.. plugin_path
		) == 1
	end

	return vim.fn.isdirectory(
		vim.fn.stdpath('data') .. '/site/pack/packer/start/' .. plugin_path
	) == 1
end

-- Load user-defined settings from the Neovim field in the doomrc
-- @param settings_tbl The settings table to iterate over
-- @param scope The settings scope, e.g. autocmds
M.load_custom_settings = function(settings_tbl, scope)
	-- If the provided settings table is not empty
	if next(settings_tbl) ~= nil then
		log.debug('Loading custom ' .. scope .. ' ...')
		if scope == 'autocmds' then
			create_augroups(settings_tbl)
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
	try({
		function()
			log.info('Checking if the colorscheme was changed ...')
			local target = vim.g.colors_name
			if target ~= Doom.colorscheme then
				vim.cmd(
					'silent !sed -i "s/\''
						.. Doom.colorscheme
						.. "'/'"
						.. target
						.. '\'/" $HOME/.config/doom-nvim/doomrc'
				)
				log.info(
					'Colorscheme successfully changed to ' .. target
				)
			end
		end,
		catch({
			function(err)
				log.error('Unable to write to the doomrc. Traceback:\n' .. err)
			end,
		}),
	})

	local quit_cmd = ''

	-- Save current session if enabled
	if Doom.autosave_sessions then
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
	try({
		function()
			log.info('Updating the outdated plugins ...')
			vim.cmd('PackerSync')
		end,
		catch({
			function(err)
				log.error('Unable to update plugins. Traceback:\n' .. err)
			end,
		}),
	})
end

-- create_report creates a markdown report. It's meant to be used when a bug
-- occurs, useful for debugging issues.
M.create_report = function()
	local date = os.date('%Y-%m-%d %H:%M:%S')

    try({
        function()
            vim.cmd(
                'silent !echo "'
                    .. vim.fn.fnameescape('#')
                    .. ' doom crash report" >> '
                    .. Doom_report
            )
            vim.cmd(
                'silent !echo "Report date: ' .. date .. '" >> ' .. Doom_report
            )
            vim.cmd(
                'silent !echo "'
                    .. vim.fn.fnameescape('##')
                    .. ' Begin log dump" >> '
                    .. Doom_report
            )
            vim.cmd(
                'silent !cat ' .. Doom_logs .. ' | grep "$(date +%a %d %b %Y)" >> ' .. Doom_report
            )
            vim.cmd(
                'silent !echo "'
                    .. vim.fn.fnameescape('##')
                    .. ' End log dump" >> '
                    .. Doom_report
            )
            log.info('Report created at ' .. Doom_report)
        end,
        catch({
            function(err)
                log.error('Error while writing report. Traceback:\n' .. err)
            end
        })
    })
end

return M
