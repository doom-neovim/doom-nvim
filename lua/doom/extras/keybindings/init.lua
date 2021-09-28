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
--    <leader>b = +buffers               --
--    <leader>c = +code                  --
--    <leader>d = +debug                 --
--    <leader>l = +lsp                   --
--    <leader>d = +doom                  --
--    <leader>f = +file                  --
--    <leader>g = +git                   --
--    <leader>p = +plugins               --
--    <leader>q = +quit/sessions         --
--    <leader>s = +search                --
--    <leader>t = +tweak                 --
--    <leader>w = +windows               --
--    <leader>o = +open                  --
--    <leader>j = +jumps                 --
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

local keybinds_modules = config.doom.keybinds_modules
  or {
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
    local ok, err = xpcall(require, debug.traceback, ("doom.extras.keybindings.%s"):format(module))
    if not ok then
      log.error(
        string.format(
          "There was an error loading the module 'doom.extras.keybindings.%s'. Traceback:\n%s",
          module,
          err
        )
      )
    end
  end
end
