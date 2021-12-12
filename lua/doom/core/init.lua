--- Main Doom configuration file
--- This file loads all doom core components
--- (ui, options, doomrc, etc)

local log = require("doom.extras.logging")

log.debug("Loading Doom core ...")

local core_modules = { "settings", "settings.netrw", "config.ui", "config" }
for i = 1, #core_modules, 1 do
  local ok, err = xpcall(require, debug.traceback, ("doom.core.%s"):format(core_modules[i]))
  if ok then
    if core_modules[i] == "settings" then
      -- Neovim configurations, e.g. shiftwidth
      require("doom.core.settings").load_default_options()
      -- User-defined settings (global variables, mappings, ect)
      require("doom.core.settings").custom_options()
      -- Doom Nvim custom commands
      require("doom.core.settings").doom_commands()
    end
    log.debug(string.format("Successfully loaded 'doom.core.%s' module", core_modules[i]))
  else
    log.error(
      string.format(
        "There was an error loading the module 'doom.core.%s'. Traceback:\n%s",
        core_modules[i],
        err
      )
    )
  end
end
