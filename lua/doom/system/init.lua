---[[---------------------------------------]]---
--     system - Doom Nvim system utilities     --
--              Author: NTBBloodbath           --
--              License: MIT                   --
---[[---------------------------------------]]---

function Which_os()
	log.debug('Checking OS ...')

	local doom_os = get_os()
	if doom_os == 'Windows' then
		Doom.separator = '\\'
	elseif doom_os == 'Linux' or doom_os == 'OSX' then
		Doom.separator = '/'
	else
		log.warn('OS not recognized, falling to Unix separator')
		Doom.separator = '/'
	end
end
