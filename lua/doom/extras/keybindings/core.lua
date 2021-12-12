local mappings = require("doom.utils.mappings")
local config = require("doom.core.config").config
local is_plugin_disabled = require("doom.utils").is_plugin_disabled

-- Additional options for mappings
local opts = { silent = true }

-- Fast exit from Doom Nvim
mappings.map(
  "n",
  "ZZ",
  '<cmd>lua require("doom.core.functions").quit_doom(true, true)<CR>',
  opts,
  "Editor",
  "fast_exit",
  "Fast exit from Doom Nvim"
)

-- ESC to turn off search highlighting
mappings.map(
  "n",
  "<esc>",
  ":noh<CR>",
  opts,
  "Editor",
  "no_highlight",
  "Turn off search highlighting"
)

---[[-----------------]]---
--     Disable keys      --
---]]-----------------[[---
-- Disable accidentally pressing ctrl-z and suspending
mappings.map("n", "<c-z>", "<Nop>", opts, "Editor", "disable_suspending", "Disable suspending")

-- Disable ex mode
mappings.map("n", "Q", "<Nop>", opts, "Editor", "disable_ex", "Disable ex mode")

-- Disable recording macros
if config.doom.disable_macros then
  mappings.map("n", "q", "<Nop>", opts, "Editor", "disable_macros", "Disable macros")
end

---[[-----------------]]---
--     Escape Remaps     --
---]]-----------------[[---
for _, esc_seq in pairs(config.doom.escape_sequences or { "jk", "kj" }) do
  mappings.map(
    "i",
    esc_seq,
    "<ESC>",
    opts,
    "Editor",
    "exit_insert" .. esc_seq,
    "Exit insert mode `" .. esc_seq .. "`"
  )
end

---[[-----------------]]---
--    Make inclusive     --
---]]-----------------[[---
-- BUG: my nvim freezes from this when which key shows up
-- NOTE: IMO inclusive is better
-- mappings.map("o", "T", "vT", opts, "Editor", "occurence_backw_inclusive", "Backwards occurence inclusive")
-- mappings.map("o", "F", "vF", opts, "Editor", "occurence_backw_till_inclusive", "Backwards occurence till inclusive")

---[[------------------]]---
--    F<n> keybindings    --
---]]------------------[[---
if not is_plugin_disabled("symbols") then
  mappings.map(
    "n",
    "<F2>",
    ":SymbolsOutline<CR>",
    opts,
    "Editor",
    "open_symbols",
    "Toggle SymbolsOutline (LSP tags)"
  )
end
if not is_plugin_disabled("explorer") and not config.doom.use_netrw then
  mappings.map(
    "n",
    "<F3>",
    ":NvimTreeToggle<CR>",
    opts,
    "Editor",
    "open_tree",
    "Toggle file explorer"
  )
else
  mappings.map(
    "n",
    "<F3>",
    string.format(":Lexplore%s<CR>", config.doom.explorer_right and "!" or ""),
    opts,
    "Editor",
    "open_tree",
    "Toggle file explorer"
  )
end
if not is_plugin_disabled("minimap") then
  mappings.map(
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
  mappings.map("n", "<F6>", ":TZAtaraxis<CR>", opts, "Editor", "open_zen", "Toggle Zen mode")
end
if not is_plugin_disabled("restclient") then
  mappings.map(
    "n",
    "<F7>",
    ":<Plug>RestNvim<CR>",
    opts,
    "Editor",
    "exec_http",
    "Execute http client under cursor"
  )
end
