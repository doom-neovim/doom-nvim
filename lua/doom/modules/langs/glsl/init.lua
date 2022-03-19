local glsl = {}

glsl.settings = {
  language_server_name = 'bashls',
}

glsl.autocmds = {
  {
    "FileType",
    "glsl,vs,fs,frag,vert",
    function()
      local langs_utils = require('doom.modules.langs.utils')
      langs_utils.use_lsp(doom.modules.glsl.settings.language_server_name)

      vim.defer_fn(function()
        require("nvim-treesitter.install").ensure_installed("glsl")
      end, 0)

      -- Setup null-ls
      if doom.modules.linter then
        local null_ls = require("null-ls")

        langs_utils.use_null_ls_source({
          null_ls.builtins.formatting.shfmt
        })
      end

    end,
    once = true,
  },
}

return glsl
