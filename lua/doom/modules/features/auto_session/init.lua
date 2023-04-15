local auto_session = {}

auto_session.settings = {
  dir = vim.fn.stdpath("data") .. "/sessions/",
}

auto_session.packages = {
  ["persistence.nvim"] = {
    "folke/persistence.nvim",
    commit = "8484fdaa284207f77ec69b9627316bf334ad653f",
  },
}

auto_session.configs = {}
auto_session.configs["persistence.nvim"] = function()
  require("persistence").setup(doom.features.auto_session.settings)
end

auto_session.binds = {
  "<leader>",
  name = "+prefix",
  {
    {
      "q",
      name = "+quit",
      {
        {
          "r",
          function()
            require("persistence").load({ last = true })
          end,
          name = "Restore session",
        },
      },
    },
  },
}

return auto_session
