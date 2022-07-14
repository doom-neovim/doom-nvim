local fish = {}

fish.settings = {}
fish.autocmds = {
  {
    "BufWinEnter",
    "*.fish",
    function()
      require("nvim-treesitter.install").ensure_installed("fish")

      -- Setup null-ls
      if doom.features.linter then
        local null_ls = require("null-ls")
        local langs_utils = require("doom.modules.langs.utils")
        langs_utils.use_null_ls_source({
          null_ls.builtins.formatting.fish_indent,
          null_ls.builtins.diagnostics.fish,
        })
      end
    end,
    once = true,
  },
}

return fish
