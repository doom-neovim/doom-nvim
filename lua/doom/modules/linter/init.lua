local linter = {}

linter.defaults = {
  c = { "clang-tidy" },
  cpp = {},
  css = {},
  html = { "tidy" },
  javascript = { "eslint" },
  lua = {},
  markdown = { "markdownlint" },
  nix = { "nix" },
  python = {},
  ruby = {},
  sh = {},
  typescript = { "eslint" },
}

linter.packer_config = {}
linter.packer_config["nvim-lint"] = function()
  require("lint").linters_by_ft = doom.linter
end

return linter
