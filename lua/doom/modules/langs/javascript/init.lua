local javascript = {}

javascript.defaults = {}

javascript.autocommands = {
  {
    "BufNewFile,BufRead",
    "*.js",
    function()
      local utils = require("doom.utils")
      local is_plugin_disabled = utils.is_plugin_disabled
      local langs_utils = require('doom.modules.langs.utils')
      
      local config = vim.tbl_deep_extend("force", {
        capabilities = utils.get_capabilities(),
        on_attach = function(client)
          if not is_plugin_disabled("illuminate") then
            utils.illuminate_attach(client)
          end
          if type(doom.lua.on_attach) == "function" then
            doom.lua.on_attach(client)
          end
        end,
      })
      
      langs_utils.use_lsp('tsserver', {
        config = config,
      })
      
      vim.defer_fn(function()
        require("nvim-treesitter.install").ensure_installed("css")
      end, 0)
      
      -- Setup null-ls
      if doom.linter then
        local null_ls = require("null-ls")
      
        langs_utils.use_null_ls_source({
          null_ls.builtins.formatting.eslint_d,
          null_ls.builtins.code_actions.eslint_d,
          null_ls.builtins.diagnostics.eslint_d,
        })
      end
    end,
    once = true,
  },
}

return javascript
