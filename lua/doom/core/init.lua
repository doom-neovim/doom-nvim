--- Main Doom configuration file
--- This file loads all doom core components
--- (ui, options, doomrc, etc)

local log = require("doom.extras.logging")

local core_modules = { "config", "config.ui", "settings" }
for i = 1, #core_modules, 1 do
  local ok, err = xpcall(require, debug.traceback, string.format("doom.core.%s", core_modules[i]))
  if not ok then
    log.error(
      string.format(
        "There was an error loading the module 'doom.core.%s'. Traceback:\n%s",
        core_modules[i],
        err
      )
    )
  end

  if ok then
    if core_modules[i] == "settings" then
      -- Neovim configurations, e.g. shiftwidth
      require("doom.core.settings").load_default_options()
      -- User-defined settings (global variables, mappings, ect)
      require("doom.core.settings").custom_options()
    elseif core_modules[i] == "config" then
      -- Automatically install language DAP clients
      require("doom.core.config").install_dap_clients(
        require("doom.core.config.doomrc").load_doomrc().langs
      )
    end
  end
end
