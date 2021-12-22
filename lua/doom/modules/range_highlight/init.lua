local range_highlight = {}

range_highlight.defaults = {}

range_highlight.packer_config = {}
range_highlight.packer_config["range-highlight.nvim"] = function()
  require("range-highlight").setup(doom.range_highlight)
end

return range_highlight
