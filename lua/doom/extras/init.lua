--- Main Doom extras file
--- This file loads all doom extra components
--- (autocommands, keybindings)

require("doom.extras.logging").debug("Loading Doom extras ...")

local extra_modules = { "keybindings" }

local disabled_autocommands = require("doom.core.config").config.doom.disable_autocommands
if not disabled_autocommands then
  vim.list_extend(extra_modules, { "autocmds" })
end

require("doom.utils.modules").load_modules("doom.extras", extra_modules)
