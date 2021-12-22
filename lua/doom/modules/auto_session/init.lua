local auto_session = {}

auto_session.defaults = {
  dir = vim.fn.stdpath("data") .. "/sessions/",
}

auto_session.packer_config = {}
auto_session.packer_config["persistence.nvim"] = function()
  require("persistence").setup(doom.auto_session)
end

return auto_session
