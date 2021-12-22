local utils = require("doom.utils")
local filename = "modules.lua"

local modules = {}

-- Path cases:
--   1. stdpath('config')/../doom-nvim/modules.lua
--   2. stdpath('config')/modules.lua
--   3. <runtimepath>/doom-nvim/modules.lua
modules.source = utils.find_config(filename)
modules.modules = dofile(modules.source)

return modules
