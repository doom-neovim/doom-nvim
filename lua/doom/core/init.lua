--- Main Doom configuration file
--- This file loads all doom core components
--- (ui, options, doomrc, etc)

local utils = require("doom.utils")
local is_plugin_disabled = utils.is_plugin_disabled

-- Required setup modules.
local core_modules = { "commands", "ui" }
-- If the explorer is disabled, the user probably wants a better netrw.
-- Otherwise, don't bother configuring it.
if is_plugin_disabled("explorer") then
  table.insert(core_modules, "netrw")
end
utils.load_modules("doom.core", core_modules)
