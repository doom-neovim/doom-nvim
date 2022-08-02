local dockerfile = {}

dockerfile.settings = {
  --- Enable/Disable linting via hadolint
  --- @type boolean
  disable_linter = true,
  --- Language server name
  --- @type string
  language_server_name = "dockerls",
}

dockerfile.autocmds = {
  {
    "FileType",
    "dockerfile",
    function()
      local settings = doom.langs.dockerfile.settings
      local langs_utils = require("doom.modules.langs.utils")
      langs_utils.use_lsp(settings.language_server_name)

      vim.defer_fn(function()
        require("nvim-treesitter.install").ensure_installed("dockerfile")
      end, 0)

      -- Setup null-ls
      if doom.features.linter and not settings.disable_linter then
        local null_ls = require("null-ls")

        langs_utils.use_null_ls_source({
          null_ls.builtins.diagnostics.hadolint,
        })
      end
    end,
    once = true,
  },
}

return dockerfile
