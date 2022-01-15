local binds = {
  {
    "gc",
    [[<cmd>lua require("Comment.api").call("toggle_linewise_op")<CR>g@]],
    name = "Comment motion",
  },
  {
    "gc",
    [[<Esc><cmd>lua require("Comment.api").toggle_linewise_op(vim.fn.visualmode())<CR>]],
    name = "Comment line",
    mode = "v",
  },
  {
    "gb",
    [[<Esc><cmd>lua require("Comment.api").toggle_blockwise_op(vim.fn.visualmode())<CR>]],
    name = "Comment block",
    mode = "v",
  },
  {
    "gcc",
    [[<cmd>lua require("Comment.api").call("toggle_current_linewise_op")<CR>g@$]],
    name = "Comment line",
  },
  {
    "gcA",
    [[<cmd>lua require("Comment.api").insert_linewise_eol()<CR>]],
    name = "Comment end of line",
  },
}

return binds
