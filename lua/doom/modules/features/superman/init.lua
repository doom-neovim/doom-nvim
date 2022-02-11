local superman = {}

superman.defaults = {}

superman.packages = {
  ["vim-superman"] = {
    "jez/vim-superman",
    commit = "19d307446576d9118625c5d9d3c7a4c9bec5571a",
    cmd = "SuperMan",
    opt = true,
  },
}

superman.configure_functions = {}

return superman
