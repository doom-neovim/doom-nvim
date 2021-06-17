---[[---------------------------------------]]---
--     system - Doom Nvim system utilities     --
--              Author: NTBBloodbath           --
--              License: MIT                   --
---[[---------------------------------------]]---

local utils = require('doom.utils')
local log = require('doom.core.logging')

local M = {}

log.debug('Loading doom system module ...')

-- which_os identifies the current OS to determine which separator should be used
-- and then return it
-- @return string
M.which_os = function()
	log.debug('Checking OS ...')

	local doom_os = utils.get_os()
	if doom_os == 'Windows' then
		return '\\'
	elseif doom_os == 'Linux' or doom_os == 'OSX' then
		return '/'
	else
		log.warn('OS not recognized, falling to Unix separator')
		return '/'
	end
end

return M
