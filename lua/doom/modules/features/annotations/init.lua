local annotations = {}

annotations.settings = {
  enabled = true,
  languages = {
    lua = {
      template = {
        annotation_convention = "emmylua",
      },
    },
    typescript = {
      template = {
        annotation_convention = "tsdoc",
      },
    },
  },
}

annotations.packages = {
  ["neogen"] = {
    "danymat/neogen",
    keys = { "<leader>cg" },
    cmd = "Neogen",
    dependencies={
      "nvim-treesitter/nvim-treesitter"
    }
  },
}

annotations.configs = {}
annotations.configs["neogen"] = function()
  require("neogen").setup(doom.features.annotations.settings)
end

annotations.binds = {
  {
    "<leader>c",
    name = "+code",
    {
      {
        "g",
        function()
          require("neogen").generate()
        end,
        name = "Generate annotations",
      },
    },
  },
}

return annotations
