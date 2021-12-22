local autocmds = {
  {
    "FileType",
    "dashboard",
    [[lua require("nest").applyKeymaps({ "q", "<cmd>q<CR>", buffer = true })]],
  },
}

return autocmds
