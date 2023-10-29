local ranger = {}

ranger.settings = {}

ranger.packages = {
  ["ranger.vim"] = {
    "francoiscabrol/ranger.vim",
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
