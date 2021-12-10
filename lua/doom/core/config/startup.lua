local startup = {}

local system = require("doom.core.system")
local log = require("doom.extras.logging")

startup.source = nil

log.debug("Loading Doom startup module ...")
-- Path cases:
--   1. /home/user/.config/doom-nvim/doom_startup.lua
--   2. stdpath('config')/doom_startup.lua
--   3. <runtimepath>/doom_startup.lua
local ok, ret = xpcall(dofile, debug.traceback, system.doom_configs_root .. "/doom_startup.lua")
if ok then
  startup.source = ret.source
else
  ok, ret = xpcall(dofile, debug.traceback, system.doom_root .. "/doom_startup.lua")
  if ok then
    startup.source = ret.source
  else
    ok, ret = xpcall(require, debug.traceback, "doom_startup")
    if ok then
      startup.source = ret.source
    else
      log.error("Error while loading doom_startup.lua. Traceback:\n" .. ret)
    end
  end
end

return startup
