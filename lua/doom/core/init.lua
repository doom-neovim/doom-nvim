--- Main Doom configuration file
--- This file loads all doom core components
--- (ui, options, doomrc, etc)

local utils = require("doom.utils")
local is_module_enabled = utils.is_module_enabled

-- Required setup modules.
local core_modules = { "commands", "ui" }
-- If the explorer is disabled, the user probably wants a better netrw.
-- Otherwise, don't bother configuring it.
if is_module_enabled("explorer") then
  table.insert(core_modules, "netrw")
end
utils.load_modules("doom.core", core_modules)
