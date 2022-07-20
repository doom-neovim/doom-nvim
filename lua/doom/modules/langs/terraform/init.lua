local terraform = {}

terraform.settings = {
  language_server_name = "terraformls",
}

terraform.autocmds = {
  {
    "BufWinEnter",
    "*.hcl,*.tf,*.tfvars,*.nomad",
    function()
      local langs_utils = require("doom.modules.langs.utils")
      langs_utils.use_lsp(doom.langs.terraform.settings.language_server_name)

      local ts_install = require("nvim-treesitter.install")
      ts_install.ensure_installed("hcl")
      --
      -- Setup null-ls
      if doom.features.linter then
        local null_ls = require("null-ls")
        langs_utils.use_null_ls_source({
          null_ls.builtins.formatting.terraform_fmt,
        })
      end
    end,
    once = true,
  },
}

return terraform
