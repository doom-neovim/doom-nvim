return function()
  require("persistence").setup({
    dir = vim.fn.stdpath("data") .. "/sessions/",
  })
end
