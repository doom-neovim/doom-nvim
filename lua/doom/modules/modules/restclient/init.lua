local restclient = {}

restclient.settings = {}

restclient.packages = {
  ["rest.nvim"] = {
    "NTBBloodbath/rest.nvim",
    commit = "e5f68db73276c4d4d255f75a77bbe6eff7a476ef",
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
