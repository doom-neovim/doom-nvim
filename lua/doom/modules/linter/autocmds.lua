local autocmds = {
  {
    "BufWinEnter,BufWritePost",
    "<buffer>",
    function()
      require("lint").try_lint()
    end,
  },
}

return autocmds
