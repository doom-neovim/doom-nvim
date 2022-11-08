local DoomModule = require('doom.modules').DoomModule

local linter = DoomModule.new("linter")

---@toc doom.features.linter
---@text # Linter / Formatter
---
--- Adds support for extra linting, formatting and code action providers for LSPs
--- using null-ls.  This module does not setup any language LSPs, those are
--- configured within the language modules.  Instead this module sets up and
--- and configures the null-ls plugin that is shared by language modules.

linter.requires_modules = { "features.lsp" }

---@eval return doom.core.doc_gen.generate_settings_documentation(MiniDoc.current.eval_section, "features.linter")
linter.settings = {
  -- Enable automatic formatting on save
  format_on_save = false,
  -- Passed into require("null-ls").setup()
  null_ls_settings = {
    -- Timeout duration before showing an error (ms)
    default_timeout = 2000,
    -- Formatting of diagnostics, see
    diagnostics_format = "#{m} (#{s})",
  },
}

---@eval return doom.core.doc_gen.generate_packages_documentation("features.linter")
linter.packages = {
  ["null-ls.nvim"] = {
    "jose-elias-alvarez/null-ls.nvim",
    commit = "8be9f4f2aca1cafac1e57234bed202bb274d03ee",
    after = "nvim-lspconfig",
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
          autocmd BufWritePre <buffer> lua type(vim.lsp.buf.format) == "function" and vim.lsp.buf.format() or vim.lsp.buf.formatting_sync()
        augroup END
        ]])
      end
    end,
  }))
end

---@eval return doom.core.doc_gen.generate_keybind_documentation("features.linter")
linter.binds = {
  {
    "<leader>cf",
    function()
      local null_ls_settings = doom.features.linter.settings.null_ls_settings
      if type(vim.lsp.buf.format) == "function" then
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
