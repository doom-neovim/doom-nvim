local linter = {}

linter.defaults = {
  format_on_save = true,
}

linter.packer_config = {}
linter.packer_config["null-ls.nvim"] = function()
  local null_ls = require("null-ls")

  null_ls.setup({
    on_attach = on_attach,
  })
end

return linter
