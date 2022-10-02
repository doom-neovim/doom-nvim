local nix = {}

nix.settings = {
  formatter = "nixpkgs_fmt",
  code_actions = {
    statix = true,
  },
  diagnostic = {
    statix = true,
    deadnix = true,
  },
}

nix.autocmds = {
  {
    "BufWinEnter",
    "*.nix",
    function()
      local utils = require("doom.utils")
      local langs_utils = require("doom.modules.langs.utils")

      require("nvim-treesitter.install").ensure_installed("nix")

      langs_utils.use_lsp("rnix-lsp")

      -- Setup null-ls
      if utils.is_module_enabled("features", "linter") then
        local null_ls = require("null-ls")

        local null_ls_source = {}

        if null_ls.builtins.formatting[nix.settings.formatter] then
          table.insert(null_ls_source, null_ls.builtins.formatting[nix.settings.formatter])
        end

        if nix.settings.code_actions.statix then
          table.insert(null_ls_source, null_ls.builtins.code_actions.statix)
        end

        if nix.settings.diagnostic.statix then
          table.insert(null_ls_source, null_ls.builtins.diagnostics.statix)
        end

        if nix.settings.diagnostic.deadnix then
          table.insert(null_ls_source, null_ls.builtins.diagnostics.deadnix)
        end

        langs_utils.use_null_ls_source(null_ls_source)
      end
    end,
    once = true,
  },
}

return nix
