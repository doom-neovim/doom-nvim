local restclient = {}

restclient.defaults = {}

restclient.packer_config = {}
restclient.packer_config["rest.nvim"] = function()
  require("rest-nvim").setup(doom.restclient)
end

return restclient
