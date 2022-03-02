local doom_reloader = {}

doom_reloader.settings = {
  enabled = true,
  languages = {
    lua = {
      template = {
        annotation_convention = "ldoc",
      },
    },
  },
}

doom_reloader.packages = {}
doom_reloader.configure_functions = {}

doom_reloader.autocommands = {
  { "BufWritePost", "*/doom/**/*.lua", function() require("doom.utils.reloader").full_reload() end },
  {
    "BufWritePost",
    "*/doom-nvim/modules.lua,*/doom-nvim/config.lua",
    function() require("doom.utils.reloader").full_reload() end,
  },
}

return doom_reloader
