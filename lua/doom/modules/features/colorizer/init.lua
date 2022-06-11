local colorizer = {}

colorizer.settings = {
  "*",
  css = { rgb_fn = true },
  html = { names = false },
}

colorizer.packages = {
  ["nvim-colorizer.lua"] = {
    "norcalli/nvim-colorizer.lua",
    commit = "36c610a9717cc9ec426a07c8e6bf3b3abcb139d6",
    event = "WinEnter",
  },
}

colorizer.configs = {}
colorizer.configs["nvim-colorizer.lua"] = function()
  require("colorizer").setup(doom.features.colorizer.settings)
end

return colorizer
