local trouble = {}

trouble.defaults = {}

trouble.packer_config = {}
trouble.packer_config["trouble.nvim"] = function()
  require("trouble").setup(doom.trouble)
end

return trouble
