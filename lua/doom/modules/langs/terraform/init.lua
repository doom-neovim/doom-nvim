local terraform = {}

terraform.settings = {
}

terraform.autocmds = {
  {
    "FileType",
    "terraform",
    function()
      local langs_utils = require('doom.modules.langs.utils')
      langs_utils.use_lsp('terraformls')

      local ts_install = require("nvim-treesitter.install")
      ts_install.ensure_installed("hcl")
    end,
    once = true,
  },
}

return terraform
