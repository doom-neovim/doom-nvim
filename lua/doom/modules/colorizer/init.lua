local colorizer = {}

colorizer.defaults = {
  "*",
  css = { rgb_fn = true },
  html = { names = false },
}

colorizer.packer_config = {}
colorizer.packer_config["nvim-colorizer.lua"] = function()
  require("colorizer").setup(doom.colorizer)
end

return colorizer
