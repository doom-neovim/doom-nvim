---[[---------------------------------------]]---
--     keybindings - Doom Nvim keybindings     --
--              Author: NTBBloodbath           --
--              License: GPLv2                 --
---[[---------------------------------------]]---

local log = require("doom.extras.logging")
local config = require("doom.core.config").config

log.debug("Loading Doom keybindings module ...")

-------------------------------------------------

---[[---------------------------------]]---
--          Custom Key mappings          --
--                                       --
--    <leader>b = Buffer Menu            --
--    <leader>f = File Menu              --
--    <leader>g = Git Menu               --
--    <leader>p = Plugin Menu            --
--    <leader>r = Runner Menu            --
--    <leader>s = Session Menu           --
--    <leader>o = Open Menu              --
--    <leader>w = Window Menu            --
--                                       --
--          TAB = Cycle buffers          --
--          ESC = Search highlight off   --
--           F2 = Toggle Symbols-Outline --
--           F3 = Toggle Tree Explorer   --
--           F4 = Toggle Terminal        --
--           F5 = Toggle Minimap         --
--           F6 = Toggle Zen Mode        --
--           F7 = Run restclient         --
---]]---------------------------------[[---

-------------------------------------------------

local keybinds_modules = config.doom.keybinds_modules or {
  -- Core doom keybindings
  core = true,
  -- Movement keybindings, jump between your windows, buffers and code
  movement = true,
  -- Leader keybindings, a bunch of useful keybindings managed by space key
  -- WARNING: disabling this will break which-key plugin if the plugin is enabled
  leader = true,
  -- Completion and snippets keybindings
  completion = true,
}

for module in pairs(keybinds_modules) do
  if keybinds_modules[module] then
    require(string.format("doom.extras.keybindings.%s", module))
  end
end
