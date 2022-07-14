local glsl = {}

glsl.settings = {}

glsl.autocmds = {
  {
    "FileType",
    "glsl",
    function()
      pcall(function()
        local langs_utils = require("doom.modules.langs.utils")

        require("nvim-treesitter.install").ensure_installed("glsl")

        -- Setup null-ls
        if doom.features.linter then
          local null_ls = require("null-ls")

          langs_utils.use_null_ls_source({
            null_ls.builtins.formatting.shfmt,
          })
        end
      end)
    end,
    once = true,
  },
  {
    "BufWinEnter",
    "*.glsl,*.vs,*.fs,*.frag,*.vert",
    function()
      vim.bo.filetype = "glsl"
    end,
  },
}

return glsl
