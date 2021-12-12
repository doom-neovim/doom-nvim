return function()
  local linters = require("doom.core.config").config.doom.linters

  require("lint").linters_by_ft = {
    c = linters.c,
    cpp = linters.cpp,
    css = linters.css,
    html = linters.html,
    javascript = linters.javascript,
    lua = linters.lua,
    markdown = linters.markdown,
    nix = linters.nix,
    python = linters.python,
    ruby = linters.ruby,
    sh = linters.sh,
    typescript = linters.typescript,
  }
end
