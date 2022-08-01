local ocaml = {}

ocaml.settings = {
  language_server_name = "ocamllsp",
}

ocaml.autocmds = {
  {
    "Filetype",
    "ocaml,ocaml_interface,ocamllex",
    function()
      local langs_utils = require("doom.modules.langs.utils")
      langs_utils.use_lsp(doom.langs.ocaml.settings.language_server_name)

      vim.schedule(function()
        require("nvim-treesitter.install").ensure_installed("ocaml", "ocaml_interface")
        if vim.fn.executable("tree-sitter-cli") == 1 then
          require("nvim-treesitter.install").ensure_installed("ocamllex")
        end
      end)
    end,
    once = true,
  },
}

return ocaml
