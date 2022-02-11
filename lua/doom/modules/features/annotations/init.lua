local annotations = {}

annotations.defaults = {
  enabled = true,
  languages = {
    lua = {
      template = {
        annotation_convention = "ldoc",
      },
    },
  },
}

annotations.packages = {
  ["neogen"] = {
    "danymat/neogen",
    commit = "7a2e69b660218e1fdc412d9822ead873eb58d85e",
    after = "nvim-treesitter",
  },
}

annotations.configure_functions = {}
annotations.configure_functions["neogen"] = function()
  require("neogen").setup(doom.annotations)
end

return annotations
