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
    commit = "c5a0c39753808faa41dea009d41dd686732c6774",
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
