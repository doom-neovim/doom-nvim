local ranger = {}

ranger.settings = {}

ranger.packages = {
  ["ranger.vim"] = {
    "francoiscabrol/ranger.vim",
    commit = "91e82debdf566dfaf47df3aef0a5fd823cedf41c",
    dependencies = {
      "rbgrouleff/bclose.vim"
    },
    lazy = true,
    cmd = {
      "Ranger",
      "RangerNewTab",
      "RangerWorkingDirectory",
      "RangerWorkingDirectoryNewTab",
    },
  },
}

ranger.configs = {}

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
