return {
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
