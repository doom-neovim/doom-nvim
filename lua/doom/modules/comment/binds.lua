local binds = {
  { 'gcc', '<CMD>lua require("Comment.api").call("toggle_current_linewise_op")<CR>g@$', name = 'Comment Line' },
  { 'gc', '<CMD>lua require("Comment.api").call("toggle_linewise_op")<CR>g@', name = 'Comment Motion' },
  { 'gcA', '<CMD>lua require("Comment.api").insert_linewise_eol(cfg)<CR>', name = 'Comment end of line' },
  { 'gc', '<ESC><CMD>lua require("Comment.api").toggle_blockwise_op(vim.fn.visualmode())<CR>', name = 'Comment Line (Visual)', mode = 'v' },
}
return binds
