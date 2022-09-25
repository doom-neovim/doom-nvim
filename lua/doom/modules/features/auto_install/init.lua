--- Auto installer module
--- Most logic for this module is inside of `lua/doom/modules/langs/utils`
local auto_install = {}

auto_install.packages = {
  ["mason.nvim"] = {
    "williamboman/mason.nvim",
    commit = "75860d253f9e66d08c9289dc43fae790882eb136",
  },
  ["mason-lspconfig"] = {
    "williamboman/mason-lspconfig",
    commit = "b70dedab5ceb5f3f84c6bc9ceea013292a14f8dc",
  },
}

auto_install.configs = {}
auto_install.configs["mason.nvim"] = function()
  require("mason").setup()
end

return auto_install
