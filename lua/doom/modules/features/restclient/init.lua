local restclient = {}

restclient.settings = {}

restclient.uses = {
  ["rest.nvim"] = {
    "NTBBloodbath/rest.nvim",
    commit = "2826f6960fbd9adb1da9ff0d008aa2819d2d06b3",
    cmd = {
      "RestNvim",
      "RestNvimPreview",
      "RestNvimLast",
    },
  },
}


restclient.configs = {}
restclient.configs["rest.nvim"] = function()
  require("rest-nvim").setup(doom.modules.restclient.settings)
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
  }
}

return restclient
