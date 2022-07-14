local c_sharp = {}

c_sharp.settings = {
  language_server_name = "omnisharp",
}

c_sharp.autocmds = {
  {
    "BufWinEnter",
    "*.cs",
    function()
      local langs_utils = require("doom.modules.langs.utils")
      local lsp_util = require("lspconfig.util")
      langs_utils.use_lsp(doom.langs.c_sharp.settings.language_server_name, {
        config = {
          root_dir = function(fname)
            return lsp_util.root_pattern("*.sln")(fname)
              or lsp_util.root_pattern("*.csproj")(fname)
              or lsp_util.root_pattern("ProjectSettings")(fname) -- Add support for unity projects
          end,
        },
      })

      require("nvim-treesitter.install").ensure_installed("c_sharp")
    end,
    once = true,
  },
}

return c_sharp
