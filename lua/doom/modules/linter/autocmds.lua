local autocmds = {
  { "BufWinEnter,BufWritePost", "<buffer>", [[lua require("lint").try_lint()]] },
}

return autocmds
