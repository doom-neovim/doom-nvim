local ranger = {}

ranger.defaults = {}

ranger.packages = {
  ["ranger.vim"] = {
    "francoiscabrol/ranger.vim",
    commit = "91e82debdf566dfaf47df3aef0a5fd823cedf41c",
    requires = {
      { "rbgrouleff/bclose.vim", opt = true },
    },
    opt = true,
    cmd = {
      "Ranger",
      "RangerNewTab",
      "RangerWorkingDirectory",
      "RangerWorkingDirectoryNewTab",
    },
  },
}
 
ranger.configure_functions = {}

ranger.binds = {
  "<leader>",
  name = "+prefix",
  {
    {
      "o",
      name = "+open/close",
      {
        { "r", "<cmd>Ranger<CR>", name = "Ranger" },
      },
    },
  },
}

return ranger
