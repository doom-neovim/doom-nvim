local linter = {}

linter.utils = {
  format_buffer = function()
    local null_ls_settings = doom.features.linter.settings.null_ls_settings
    if type(vim.lsp.buf.format) == "function" then
      vim.lsp.buf.format({
        timeout_ms = null_ls_settings.default_timeout,
      })
    else
      vim.lsp.buf.formatting_sync(nil, null_ls_settings.default_timeout)
    end
  end,
}

linter.settings = {
  format_on_save = false,
  null_ls_settings = {
    default_timeout = 2000,
    diagnostics_format = "#{m} (#{s})",
  },
}

linter.requires_modules = { "features.lsp" }

linter.packages = {
  ["null-ls.nvim"] = {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies={"neovim/nvim-lspconfig"},
    lazy = true,
  },
}

linter.configs = {}
linter.configs["null-ls.nvim"] = function()
  local null_ls = require("null-ls")

  local null_ls_settings = doom.features.linter.settings.null_ls_settings
  null_ls.setup(vim.tbl_deep_extend("force", null_ls_settings, {
    on_attach = function(client)
      if client.server_capabilities.documentFormattingProvider
          and doom.features.linter.settings.format_on_save
      then
        local lsp_formatting_group = vim.api.nvim_create_augroup("LspFormatting", { clear = true })
        vim.api.nvim_create_autocmd({ "BufWritePre" }, {
          group = lsp_formatting_group,
          callback = doom.features.linter.utils.format_buffer,
        })
      end
    end,
  }))
end

linter.binds = {
  {
    "<leader>cf",
    linter.utils.format_buffer,
    name = "Format/Fix",
  },
}

return linter
