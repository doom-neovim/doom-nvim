return function()
  local has_value = require("doom.utils").has_value
  local modules = require("doom.core.config.modules").modules
  local is_plugin_disabled = require("doom.utils").is_plugin_disabled

  local function get_ts_parsers(languages)
    local langs = {}

    for _, lang in ipairs(languages) do
      -- If the lang is config then add parsers for JSON, YAML and TOML
      if lang == "config" then
        table.insert(langs, "json")
        table.insert(langs, "yaml")
        table.insert(langs, "toml")
      else
        lang = lang:gsub("%s+%+lsp(%(%a+%))", ""):gsub("%s+%+lsp", ""):gsub("%s+%+debug", "")
        table.insert(langs, lang)
      end
    end

    -- Add TSX parser if TypeScript is enabled
    if has_value(langs, "typescript") then
      table.insert(langs, "tsx")
    end
    return langs
  end

  -- Set up treesitter for Neorg
  local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()
  parser_configs.norg = {
    install_info = {
      url = "https://github.com/nvim-neorg/tree-sitter-norg",
      files = { "src/parser.c", "src/scanner.cc" },
      branch = "main",
    },
  }
  if packer_plugins and packer_plugins["neorg"] then
    table.insert(modules.langs, "norg")
  end

  -- Set up treesitter for HTTP
  parser_configs.http = {
    install_info = {
      url = "https://github.com/NTBBloodbath/tree-sitter-http",
      files = { "src/parser.c" },
      branch = "main",
    },
  }
  if packer_plugins and packer_plugins["rest.nvim"] then
    table.insert(modules.langs, "http")
  end

  -- macos uses wrong c version
  require("nvim-treesitter.install").compilers = { "gcc" }

  require("nvim-treesitter.configs").setup({
    ensure_installed = get_ts_parsers(modules.langs),
    highlight = { enable = true },
    autopairs = {
      enable = is_plugin_disabled("autopairs") and false or true,
    },
    indent = { enable = true },
    playground = { enable = true },
    tree_docs = { enable = true },
    context_commentstring = { enable = true },
    autotag = {
      enable = true,
      filetypes = {
        "html",
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "svelte",
        "vue",
        "markdown",
      },
    },
  })
end
