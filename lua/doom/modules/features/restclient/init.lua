local restclient = {}

restclient.settings = {}

restclient.packages = {
  ["rest.nvim"] = {
    "rest-nvim/rest.nvim",
    commit = "090e253c114b6d5448bac5869a28a6623c195e3a",
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
