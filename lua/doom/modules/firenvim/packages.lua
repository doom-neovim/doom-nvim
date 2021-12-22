return {
  ["firenvim"] = {
    "glacambre/firenvim",
    commit = "7320a805f51b4cf03de4e3b30088838d3f84adda",
    run = function()
      vim.fn["firenvim#install"](0)
    end,
    opt = true,
  },
}
