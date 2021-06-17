---[[---------------------------------------]]---
--      functions - Doom Nvim Functions        --
--              Author: NTBBloodbath           --
--              License: MIT                   --
---[[---------------------------------------]]---

log.debug('Loading Doom functions module ...')

-- Check if the given plugin exists
function Check_plugin(plugin_path)
	return vim.fn.isdirectory(vim.fn.expand(
		'$HOME/.local/share/nvim/site/pack/packer/start/' .. plugin_path
	)) == 1
end

-- Load user-defined settings from the Neovim field in the doomrc
-- @param settings_tbl The settings table to iterate over
-- @param scope The settings scope, e.g. autocmds
function Load_custom_settings(settings_tbl, scope)
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
function Quit_doom(write, force)
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
			function(_)
				log.error('Unable to write to the doomrc')
			end,
		}),
	})

	vim.cmd(
		'silent !echo "[---] - Dumping :messages" >>  ' .. Doom_logs
	)
	vim.cmd('redir >>  ' .. Doom_logs)
	vim.cmd('silent messages')
	vim.cmd('redir END')
	vim.cmd('silent !echo " " >>  ' .. Doom_logs)
	vim.cmd('silent !echo "[---] - End of dump" >>  ' .. Doom_logs)

	local quit_cmd = ''

	-- Save current session if enabled
	if Doom.autosave_sessions then
		vim.cmd('SaveSession')
	end

	if write then
		quit_cmd = 'wa | '
	end
	if force == false then
		vim.cmd(quit_cmd .. 'q!')
	else
		vim.cmd(quit_cmd .. 'qa!')
	end
end

-- Check for plugins updates
function Check_updates()
	try({
		function()
			log.info('Updating the outdated plugins ...')
			vim.cmd('PackerSync')
		end,
		catch({
			function(_)
				log.error('Unable to update plugins')
			end,
		}),
	})
end

-- Create a markdown report to use when a bug occurs,
-- useful for debugging issues.
function Create_report()
	local today = os.date('%Y-%m-%d %H:%M:%S')

	vim.cmd(
		'silent !echo "'
			.. vim.fn.fnameescape('#')
			.. ' doom crash report" >> '
			.. Doom_report
	)
	vim.cmd(
		'silent !echo "Report date: ' .. today .. '" >> ' .. Doom_report
	)
	vim.cmd(
		'silent !echo "'
			.. vim.fn.fnameescape('##')
			.. ' Begin log dump" >> '
			.. Doom_report
	)
	vim.cmd(
		'silent !echo | cat  ' .. Doom_logs .. ' >> ' .. Doom_report
	)
	vim.cmd(
		'silent !echo "'
			.. vim.fn.fnameescape('##')
			.. ' End log dump" >> '
			.. Doom_report
	)
	log.info('Report created at ' .. Doom_report)
end
