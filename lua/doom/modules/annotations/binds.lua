local binds = {
  {
    "<leader>",
    name = "+prefix",
    {
      {
        "c",
        name = "+code",
        {
          { "g", require("neogen").generate, name = "Generate annotations" },
        },
      },
    },
  },
}

return binds
