local gdscript = {}

gdscript.settings = {
  language_server_name = "gdscript",
}

gdscript.autocmds = {
  {
    "BufWinEnter",
    "*.gd",
    function()
      print("gdscript")
      local langs_utils = require("doom.modules.langs.utils")
      langs_utils.use_lsp(doom.modules.langs.gdscript.settings.language_server_name, {
        no_installer = true,
        config = {
          flags = {
            debounce_text_changes = 150,
          },
        },
      })
      if doom.features.linter then
        local null_ls = require("null-ls")

        langs_utils.use_null_ls_source({
          null_ls.builtins.formatting.gdformat,
          null_ls.builtins.diagnostics.gdlint,
        })
      end

      require("nvim-treesitter.install").ensure_installed("gdscript", "godot_resource")
    end,
    once = true,
  },
}

return gdscript
