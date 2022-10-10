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
    commit = "967b280d7d7ade52d97d06e868ec4d9a0bc59282",
    after = "nvim-treesitter",
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
