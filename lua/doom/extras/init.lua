--- Main Doom extras file
--- This file loads all doom extra components
--- (autocommands, keybindings)

require("doom.extras.logging").debug("Loading Doom extras ...")

require("doom.utils").load_modules("doom.extras", {
  "autocmds",
  "keybindings",
})
