local log = require('doom.core.logging')

-- selene: allow(undefined_variable)
if packer_plugins and not packer_plugins['nvim-toggleterm.lua'] then
	log.error(
		"Doom compiler needs toggleterm plugin, please uncomment the 'terminal' entry in your doomrc"
	)
end

local M = {}

-- Currently supported languages,
-- filetype → binary to execute
local languages = {
	rust = 'rust',
	go = 'go',
}

-- compile will compile the project in the current working directory
M.compile = function()
	local filetype = vim.bo.filetype
	local lang_bin = languages[filetype]

	local compiled_code, err = pcall(function()
		if lang_bin then
			-- Set the properly builder command for the project
			local compiler_cmd
			if lang_bin == 'rust' then
				compiler_cmd = 'cargo build'
			elseif lang_bin == 'go' then
				-- NOTE: Untested because I am not using Go anymore, this
				-- command should look for a main program in the cwd
				compiler_cmd = 'go build .'
			end
			require('toggleterm').exec_command(
				string.format('cmd="%s"', compiler_cmd),
				1
			)
		else
			log.error(
				'The filetype '
					.. filetype
					.. ' is not yet supported in the Doom compiler plugin'
			)
		end
	end)

	if not compiled_code then
		log.error(
			'Error while trying to compile the project. Traceback:\n' .. err
		)
	end
end

-- compile_and_run compiles the project and then runs it
M.compile_and_run = function()
	local filetype = vim.bo.filetype
	local lang_bin = languages[filetype]

	local compiled_code, err = pcall(function()
		if lang_bin then
			-- Set the properly builder command for the project
			local compiler_cmd
			if lang_bin == 'rust' then
				compiler_cmd = 'cargo run'
			elseif lang_bin == 'go' then
				-- NOTE: Untested because I am not using Go anymore
				-- TODO: Maybe try to find other way for this if not everyone
				--       uses a main.go file as their entry points?
				compiler_cmd = 'go run main.go'
			end
			require('toggleterm').exec_command(
				string.format('cmd="%s"', compiler_cmd),
				1
			)
		else
			log.error(
				'The filetype '
					.. filetype
					.. ' is not yet supported in the Doom compiler plugin'
			)
		end
	end)

	if not compiled_code then
		log.error(
			'Error while trying to compile and run the project. Traceback:\n'
				.. err
		)
	end
end

return M
