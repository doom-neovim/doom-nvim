local M = {}
---[[---------------------------------------]]---
--     userplugins - Load Doom Nvim doom_userplugins      --
--              Author: NTBBloodbath           --
--              License: GPLv2                 --
---[[---------------------------------------]]---

local system = require("doom.core.system")
local log = require("doom.extras.logging")

M.plugins = {}

M.source = nil

log.debug("Loading Doom userplugins module...")

-- Path cases:
--   1. <runtimepath>/doom_userplugins.lua
--   2. /home/user/.config/doom-nvim/doom_userplugins.lua
--   3. stdpath('config')/doom_userplugins.lua
local ok, ret = pcall(require, "doom_userplugins")
if ok then
  M.plugins = ret.plugins
  M.source = ret.source
else
  ok, ret = pcall(dofile, system.doom_configs_root.."/doom_userplugins.lua")
  if ok then
    M.plugins = ret.plugins
    M.source = ret.source
  else
    log.error("Error while loading doom_userplugins.lua. Traceback:\n" .. ret)
  end
end

return M
