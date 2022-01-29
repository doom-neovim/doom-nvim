return {
  ["firenvim"] = {
    "glacambre/firenvim",
    commit = "1f9159710d98bbe1e3ef2ce60a4886e2e0ec11c9",
    run = function()
      vim.fn["firenvim#install"](0)
    end,
    opt = true,
  },
}
