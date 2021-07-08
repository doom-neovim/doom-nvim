---[[---------------------------------------]]---
--     system - Doom Nvim system utilities     --
--              Author: NTBBloodbath           --
--              License: GPLv2                   --
---[[---------------------------------------]]---

function Which_os()
	Log_message('+', 'Checking OS ...', 2)

	local doom_os = Get_OS()
	if doom_os == 'Windows' then
		Doom.separator = '\\'
	elseif doom_os == 'Linux' or doom_os == 'OSX' then
		Doom.separator = '/'
	else
		Log_message('!', 'OS not recognized', 1)
	end
end
