return function()
  require("lint").linters_by_ft = {
    c = { "clangtidy" },
    cpp = { "cppcheck" },
    css = { "stylelint" },
    html = { "tidy", "eslint" },
    javascript = { "eslint" },
    lua = { "luacheck" },
    markdown = { "vale", "markdownlint" },
    nix = { "nix" },
    python = { "pylint", "flake8", "pycodestyle" },
    ruby = { "ruby", "standardrb" },
    sh = { "shellcheck" },
    typescript = { "eslint" },
  }
end
