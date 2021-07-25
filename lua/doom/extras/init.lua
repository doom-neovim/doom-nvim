--- Doom extra configurations
--- This file loads all doom extra components
--- (autocommands, keybindings, logging)

local log = require('doom.extras.logging')

local extra_modules = { 'autocmds', 'keybindings' }
for i = 1, #extra_modules, 1 do
	local ok, err = xpcall(
		require,
		debug.traceback,
		string.format('doom.extras.%s', extra_modules[i])
	)
	if not ok then
		log.error(
			string.format(
				"There was an error loading the module 'doom.core.%s'. Traceback:\n%s",
				extra_modules[i],
				err
			)
		)
	end
end
