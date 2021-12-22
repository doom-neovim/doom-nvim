local neogit = {}

neogit.defaults = {}

neogit.packer_config = {}
neogit.packer_config["neogit"] = function()
  require("neogit").setup(doom.neogit)
end

return neogit
