local fidget = {}

fidget.settings = {
}

fidget.packages = {
  ["fidget.nvim"] = {
    "j-hui/fidget.nvim",
    commit = "cbe0db4f2adfddfd830310e5846f8735d4e068fa",
  },
}

fidget.configure_functions = {}
fidget.configure_functions["fidget.nvim"] = function()
  require("fidget").setup(doom.modules.fidget.settings)
end

return fidget
