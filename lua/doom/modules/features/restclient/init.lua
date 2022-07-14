local restclient = {}

restclient.settings = {}

restclient.packages = {
  ["rest.nvim"] = {
    "NTBBloodbath/rest.nvim",
    commit = "d902996de965d5d491f122e69ba9d03f9c673eb0",
    cmd = {
      "RestNvim",
      "RestNvimPreview",
      "RestNvimLast",
    },
  },
}

restclient.configs = {}
restclient.configs["rest.nvim"] = function()
  require("rest-nvim").setup(doom.features.restclient.settings)
end

restclient.binds = {
  { "<F7>", "<cmd>RestNvim<CR>", name = "Open http client" },
  {
    "<leader>",
    name = "+prefix",
    {
      {
        "o",
        name = "+open/close",
        {
          { "h", "<cmd>RestNvim<CR>", name = "Http" },
        },
      },
    },
  },
}

return restclient
