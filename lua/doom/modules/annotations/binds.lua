local binds = {
    "<leader>",
  {
    name = "+prefix",
    {
      {
        "c",
        name = "+code",
        {
          {
            "g",
            function()
              require("neogen").generate()
            end,
            name = "Generate annotations"
          },
        },
      },
    },
  },
}

return binds
