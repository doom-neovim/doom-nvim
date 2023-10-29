local colorizer = {}

colorizer.settings = {
  "*",
  css = { rgb_fn = true },
  html = { names = false },
}

colorizer.packages = {
  ["nvim-colorizer.lua"] = {
    "norcalli/nvim-colorizer.lua",
    event = "VeryLazy",
  },
}

colorizer.configs = {}
colorizer.configs["nvim-colorizer.lua"] = function()
  require("colorizer").setup(doom.features.colorizer.settings)
end

return colorizer
