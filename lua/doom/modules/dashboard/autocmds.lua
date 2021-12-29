local autocmds = {
  {
    "FileType",
    "dashboard",
    function()
      require("nest").applyKeymaps({ "q", "<cmd>q<CR>", buffer = true })
    end,
  },
}

return autocmds
