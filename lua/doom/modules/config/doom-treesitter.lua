return function()
  local has_value = require("doom.utils").has_value
  local modules = require("doom.core.config.modules").modules
  local is_plugin_disabled = require("doom.utils").is_plugin_disabled

  --- Returns treesitter parsers from doom_modules.langs
  --- @param languages table<number, string>
  --- @return table<number, string>
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

  if packer_plugins and packer_plugins["rest.nvim"] then
    table.insert(modules.langs, "http")
  end

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

  --  Check if user is using clang and notify that it has poor compatibility with treesitter
  --  WARN: 19/11/2021 | issues: #222, #246 clang compatibility could improve in future
  vim.defer_fn(function()
    local log = require("doom.extras.logging")
    local utils = require("doom.utils")
    -- Matches logic from nvim-treesitter
    local compiler = utils.find_executable_in_path({
      vim.fn.getenv("CC"),
      "cc",
      "gcc",
      "clang",
      "cl",
      "zig",
    })
    local version = vim.fn.systemlist(compiler .. (compiler == "cl" and "" or " --version"))[1]

    if version:match("clang") then
      log.warn(
        "doom-treesitter:  clang has poor compatibility compiling treesitter parsers.  We recommend using gcc, see issue #246 for details.  (https://github.com/NTBBloodbath/doom-nvim/issues/246)"
      )
    end
  end, 1000)
end
