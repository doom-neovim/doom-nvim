local terraform = {}

terraform.settings = {
  --- Disables auto installing the treesitter
  --- @type boolean
  disable_treesitter = false,
  --- Treesitter grammars to install
  --- @type string|string[]
  treesitter_grammars = "hcl",

  --- Disables default LSP config
  --- @type boolean
  disable_lsp = false,
  --- Name of the language server
  --- @type string
  lsp_name = "terraformls",

  --- Disables null-ls formatting sources
  --- @type boolean
  disable_formatting = false,
  --- Mason.nvim package to auto install the formatter from
  --- @type nil
  formatting_package = nil,
  --- String to access the null_ls diagnositcs provider
  --- @type string
  formatting_provider = "builtins.formatting.terraform_fmt",
  --- Function to configure null-ls formatter
  --- @type function|nil
  formatting_config = nil,
}

local langs_utils = require("doom.modules.langs.utils")
terraform.autocmds = {
  {
    "BufWinEnter",
    "*.hcl,*.tf,*.tfvars,*.nomad",
    langs_utils.wrap_language_setup("terraform", function()
      if not terraform.settings.disable_lsp then
        langs_utils.use_lsp_mason(terraform.settings.lsp_name)
      end

      if not terraform.settings.disable_treesitter then
        langs_utils.use_tree_sitter(terraform.treesitter_grammars)
      end

      if not terraform.settings.disable_formatting then
        langs_utils.use_null_ls(
          terraform.settings.diagnostics_package,
          terraform.settings.formatting_provider,
          terraform.settings.formatting_config
        )
      end
    end),
    once = true,
  },
}

return terraform
