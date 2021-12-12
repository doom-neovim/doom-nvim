local mappings = require("doom.utils.mappings")

-- Additional options for mappings
local opts = { silent = true }

-- TAB to cycle buffers too, why not?
mappings.map("n", "<Tab>", ":bnext<CR>", opts, "Movement", "cycle_next_buffer", "Goto next buffer")
mappings.map(
  "n",
  "<S-Tab>",
  ":bprevious<CR>",
  opts,
  "Movement",
  "cycle_prev_buffer",
  "Goto prev buffer"
)

---[[-------------------------]]---
--     Window Movements keys     --
---]]-------------------------]]---
mappings.map("n", "<C-h>", "<C-w>h", opts, "Movement", "left_window", "Goto left window")
mappings.map("n", "<C-j>", "<C-w>j", opts, "Movement", "down_window", "Goto down window")
mappings.map("n", "<C-k>", "<C-w>k", opts, "Movement", "up_window", "Goto upper window")
mappings.map("n", "<C-l>", "<C-w>l", opts, "Movement", "right_window", "Goto right window")

---[[-----------------]]---
--       Move Lines      --
---]]-----------------[[---
mappings.map(
  "n",
  "<a-j>",
  ":m .+1<CR>==",
  opts,
  "Editor",
  "normal_move_line_down",
  "Normal Move line down"
)
mappings.map(
  "n",
  "<a-k>",
  ":m .-2<CR>==",
  opts,
  "Editor",
  "normal_move_line_up",
  "Normal Move line up"
)
mappings.map(
  "i",
  "<a-j>",
  "<esc>:m .+1<CR>==gi",
  opts,
  "Editor",
  "instert_move_line_down",
  "Insert Move line down"
)
mappings.map(
  "i",
  "<a-k>",
  "<esc>:m .-2<CR>==gi",
  opts,
  "Editor",
  "instert_move_line_up",
  "Insert Move line up"
)
mappings.map(
  "v",
  "<a-j>",
  ":m '>+1<CR>gv=gv",
  opts,
  "Editor",
  "visual_move_line_down",
  "Visual Move line down"
)
mappings.map(
  "v",
  "<a-k>",
  ":m '<-2<CR>gv=gv",
  opts,
  "Editor",
  "visual_move_line_up",
  "Visual Move line up"
)

---[[-----------------]]---
--    Select Movement    --
---]]-----------------[[---
mappings.map(
  "x",
  "K",
  ":move '<-2<CR>gv-gv",
  opts,
  "Editor",
  "select_right",
  "Move selection right"
)
mappings.map("x", "J", ":move '>+1<CR>gv-gv", opts, "Editor", "select_left", "Move selection left")

-- stay in visual mode after indenting with < or >
mappings.map(
  "v",
  ">",
  ">gv",
  opts,
  "Editor",
  "stay_vselect_indent",
  "Stay in visual mode after indenting a selection"
)
mappings.map(
  "v",
  "<",
  "<gv",
  opts,
  "Editor",
  "stay_vselect_deindent",
  "Stay in visual mode after unindenting a selection"
)

-- get out of terminal insert mode into normal mode with Esc
mappings.map(
  "t",
  "<Esc>",
  "<C-\\><C-n>",
  opts,
  "Editor",
  "exit_insert_term",
  "Exit insert mode (inside a terminal)"
)

---[[-----------------]]---
--    Resizing Splits    --
---]]-----------------[[---
mappings.map(
  "n",
  "<C-Up>",
  ":resize +2<CR>",
  opts,
  "Window",
  "resize_up",
  "Resize window (increase width)"
)
mappings.map(
  "n",
  "<C-Down>",
  ":resize -2<CR>",
  opts,
  "Window",
  "resize_down",
  "Resize window (decrease width)"
)
mappings.map(
  "n",
  "<C-Right>",
  ":vertical resize -2<CR>",
  opts,
  "Window",
  "resize_right",
  "Resize window (decrease height)"
)
mappings.map(
  "n",
  "<C-Left>",
  ":vertical resize +2<CR>",
  opts,
  "Window",
  "resize_left",
  "Resize window (increase height)"
)
