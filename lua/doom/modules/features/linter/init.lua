local linter = {}

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
      if
        client.server_capabilities.documentFormattingProvider
        and doom.features.linter.settings.format_on_save
      then
        vim.cmd([[
        augroup LspFormatting
          autocmd! * <buffer>
          autocmd BufWritePre <buffer> lua if vim.lsp.buf.format ~= nil then vim.lsp.buf.format() else vim.lsp.buf.formatting_sync() end
        augroup END
        ]])
      end
    end,
  }))
end

linter.binds = {
  {
    "<leader>cf",
    function()
      local null_ls_settings = doom.features.linter.settings.null_ls_settings
      if vim.lsp.buf.format ~= nil then
        vim.lsp.buf.format({
          timeout_ms = null_ls_settings.default_timeout,
        })
      else
        vim.lsp.buf.formatting_sync(nil, null_ls_settings.default_timeout)
      end
    end,
    name = "Format/Fix",
  },
}

return linter
