local utils = require("doom.utils")
local config = require("doom.core.config").config
local is_plugin_disabled = require("doom.core.functions").is_plugin_disabled

-- Additional options for mappings
local opts = { silent = true }

-- Set Space key as leader
utils.map("n", "<Space>", "<Nop>", opts, "Editor", "open_whichkey", "Open WhichKey menu")
vim.g.mapleader = " "

-- Fast exit from Doom Nvim
utils.map(
  "n",
  "ZZ",
  '<cmd>lua require("doom.core.functions").quit_doom(true, true)<CR>',
  opts,
  "Editor",
  "fast_exit",
  "Fast exit from Doom Nvim"
)

-- ESC to turn off search highlighting
utils.map("n", "<esc>", ":noh<CR>", opts, "Editor", "no_highlight", "Turn off search highlighting")

---[[-----------------]]---
--     Disable keys      --
---]]-----------------[[---
-- Disable accidentally pressing ctrl-z and suspending
utils.map("n", "<c-z>", "<Nop>", opts, "Editor", "disable_suspending", "Disable suspending")

-- Disable ex mode
utils.map("n", "Q", "<Nop>", opts, "Editor", "disable_ex", "Disable ex mode")

-- Disable recording macros
if config.doom.disable_macros then
  utils.map("n", "q", "<Nop>", opts, "Editor", "disable_macros", "Disable macros")
end

---[[-----------------]]---
--     Escape Remaps     --
---]]-----------------[[---
utils.map("i", "jk", "<ESC>", opts, "Editor", "exit_insert", "Exit insert mode")
utils.map("i", "kj", "<ESC>", opts, "Editor", "exit_insert_alt", "Exit insert mode")

---[[-----------------]]---
--    Make inclusive     --
---]]-----------------[[---
-- BUG: my nvim freezes from this when which key shows up
-- NOTE: IMO inclusive is better
-- utils.map("o", "T", "vT", opts, "Editor", "occurence_backw_inclusive", "Backwards occurence inclusive")
-- utils.map("o", "F", "vF", opts, "Editor", "occurence_backw_till_inclusive", "Backwards occurence till inclusive")

---[[------------------]]---
--    F<n> keybindings    --
---]]------------------[[---
if not is_plugin_disabled("symbols") then
  utils.map(
    "n",
    "<F2>",
    ":SymbolsOutline<CR>",
    opts,
    "Editor",
    "open_symbols",
    "Toggle SymbolsOutline (LSP tags)"
  )
end
if not is_plugin_disabled("explorer") then
  utils.map("n", "<F3>", ":NvimTreeToggle<CR>", opts, "Editor", "open_tree", "Toggle file explorer")
end
if not is_plugin_disabled("minimap") then
  utils.map(
    "n",
    "<F5>",
    ":MinimapToggle<CR>",
    opts,
    "Editor",
    "open_minimap",
    "Toggle code minimap"
  )
end
if not is_plugin_disabled("zen") then
  utils.map("n", "<F6>", ":TZAtaraxis<CR>", opts, "Editor", "open_zen", "Toggle Zen mode")
end
if not is_plugin_disabled("restclient") then
  utils.map(
    "n",
    "<F7>",
    ":<Plug>RestNvim<CR>",
    opts,
    "Editor",
    "exec_http",
    "Execute http client under cursor"
  )
end
