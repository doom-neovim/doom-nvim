local utils = require("doom.utils")

-- Additional options for mappings
local opts = { silent = true }

-- TAB to cycle buffers too, why not?
utils.map("n", "<Tab>", ":bnext<CR>", opts, "Movement", "cycle_next_buffer", "Goto next buffer")
utils.map(
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
utils.map("n", "<C-h>", "<C-w>h", opts, "Movement", "left_window", "Goto left window")
utils.map("n", "<C-j>", "<C-w>j", opts, "Movement", "down_window", "Goto down window")
utils.map("n", "<C-k>", "<C-w>k", opts, "Movement", "up_window", "Goto upper window")
utils.map("n", "<C-l>", "<C-w>l", opts, "Movement", "right_window", "Goto right window")

---[[-----------------]]---
--       Move Lines      --
---]]-----------------[[---
utils.map(
  "n",
  "<a-j>",
  ":m .+1<CR>==",
  opts,
  "Editor",
  "normal_move_line_down",
  "Normal Move line down"
)
utils.map(
  "n",
  "<a-k>",
  ":m .-2<CR>==",
  opts,
  "Editor",
  "normal_move_line_up",
  "Normal Move line up"
)
utils.map(
  "i",
  "<a-j>",
  "<esc>:m .+1<CR>==gi",
  opts,
  "Editor",
  "instert_move_line_down",
  "Insert Move line down"
)
utils.map(
  "i",
  "<a-k>",
  "<esc>:m .-2<CR>==gi",
  opts,
  "Editor",
  "instert_move_line_up",
  "Insert Move line up"
)
utils.map(
  "v",
  "<a-j>",
  ":m '>+1<CR>gv=gv",
  opts,
  "Editor",
  "visual_move_line_down",
  "Visual Move line down"
)
utils.map(
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
utils.map("x", "K", ":move '<-2<CR>gv-gv", opts, "Editor", "select_right", "Move selection right")
utils.map("x", "J", ":move '>+1<CR>gv-gv", opts, "Editor", "select_left", "Move selection left")

-- get out of terminal insert mode into normal mode with Esc
utils.map(
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
utils.map(
  "n",
  "<C-Up>",
  ":resize +2<CR>",
  opts,
  "Window",
  "resize_up",
  "Resize window (increase width)"
)
utils.map(
  "n",
  "<C-Down>",
  ":resize -2<CR>",
  opts,
  "Window",
  "resize_down",
  "Resize window (decrease width)"
)
utils.map(
  "n",
  "<C-Right>",
  ":vertical resize -2<CR>",
  opts,
  "Window",
  "resize_right",
  "Resize window (decrease height)"
)
utils.map(
  "n",
  "<C-Left>",
  ":vertical resize +2<CR>",
  opts,
  "Window",
  "resize_left",
  "Resize window (increase height)"
)
