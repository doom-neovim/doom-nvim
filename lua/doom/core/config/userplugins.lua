---[[---------------------------------------]]---
--     userplugins - Load Doom Nvim doom_userplugins      --
--              Author: NTBBloodbath           --
--              License: GPLv2                 --
---[[---------------------------------------]]---

local system = require("doom.core.system")
local log = require("doom.extras.logging")

local userplugins = {}

userplugins.plugins = {}

userplugins.source = nil

log.debug("Loading Doom userplugins module...")

-- Path cases:
--   1. /home/user/.config/doom-nvim/doom_userplugins.lua
--   2. stdpath('config')/doom_userplugins.lua
--   3. <runtimepath>/doom_userplugins.lua
local ok, ret = xpcall(dofile, debug.traceback, system.doom_configs_root .. "/doom_userplugins.lua")
if ok then
  userplugins.plugins = ret.plugins
  userplugins.source = ret.source
else
  ok, ret = xpcall(dofile, debug.traceback, system.doom_root .. "/doom_userplugins.lua")
  if ok then
    userplugins.plugins = ret.plugins
    userplugins.source = ret.source
  else
    ok, ret = xpcall(require, debug.traceback, "doom_userplugins")
    if ok then
      userplugins.plugins = ret.plugins
      userplugins.source = ret.source
    else
      log.error("Error while loading doom_userplugins.lua. Traceback:\n" .. ret)
    end
  end
end

return userplugins
