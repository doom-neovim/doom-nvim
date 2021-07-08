---[[---------------------------------------]]---
--      functions - Doom Nvim Functions        --
--              Author: NTBBloodbath           --
--              License: GPLv2                   --
---[[---------------------------------------]]---

-- Check if the given plugin exists
function Check_plugin(plugin_path)
	return Fn.isdirectory(Fn.expand('$HOME/.local/share/nvim/site/pack/packer/start/' .. plugin_path)) == 1
end

-- Quit Neovim and change the colorscheme at doomrc if the colorscheme is not the same,
-- dump all messages to doom.log file
function Quit_doom(write, force)
	Try({
		function()
			Log_message(
				'*',
				'Checking if the colorscheme was changed ...',
				2
			)
			local target = G.colors_name
			if target ~= Doom.colorscheme then
				Cmd(
					'!sed -i "s/\''
						.. Doom.colorscheme
						.. "'/'"
						.. target
						.. '\'/" $HOME/.config/doom-nvim/doomrc'
				)
				Log_message(
					'*',
					'Colorscheme successfully changed to ' .. target,
					2
				)
			else
				Log_message(
					'*',
					'No need to write colors (same colorscheme)',
					2
				)
			end
		end,
		Catch({
			function(_)
				Log_message('!', 'Unable to write to the doomrc', 1)
			end,
		}),
	})

	Cmd(
		'silent !echo "[---] - Dumping :messages" >>  ' .. Doom_logs
	)
	Cmd('redir >>  ' .. Doom_logs)
	Cmd('silent messages')
	Cmd('redir END')
	Cmd('silent !echo " " >>  ' .. Doom_logs)
	Cmd('silent !echo "[---] - End of dump" >>  ' .. Doom_logs)

	local quit_cmd = ''

	-- Save current session if enabled
	if Doom.autosave_sessions then
		Cmd('SaveSession')
	end

	if write then
		quit_cmd = 'wa | '
	end
	if force == false then
		Cmd(quit_cmd .. 'q!')
	else
		Cmd(quit_cmd .. 'qa!')
	end
end

-- Check for plugins updates
function Check_updates()
	Try({
		function()
			Log_message('+', 'Updating the outdated plugins ...', 2)
			Cmd('PackerSync')
			Log_message('+', 'Done', 2)
		end,
		Catch({
			function(_)
				Log_message('!', 'Unable to update plugins', 1)
			end,
		}),
	})
end

-- Create a markdown report to use when a bug occurs,
-- useful for debugging issues.
function Create_report()
	local today = os.date('%Y-%m-%d %H:%M:%S')

	Cmd(
		'silent !echo "'
			.. Fn.fnameescape('#') .. ' doom crash report" >> '
			.. Doom_report
	)
	Cmd(
		'silent !echo "Report date: ' .. today .. '" >> ' .. Doom_report
	)
	Cmd(
		'silent !echo "'
			.. Fn.fnameescape('##') .. ' Begin log dump" >> '
			.. Doom_report
	)
	Cmd(
		'silent !echo | cat  ' .. Doom_logs .. ' >> ' .. Doom_report
	)
	Cmd(
		'silent !echo "'
			.. Fn.fnameescape('##') .. ' End log dump" >> '
			.. Doom_report
	)
	print('Report created at ' .. Doom_report)
end
