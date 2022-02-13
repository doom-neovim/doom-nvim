local annotations = {}

annotations.settings = {
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
    commit = "d3e0168e1eb4c0a84b132fd0b554427e62a49552",
    after = "nvim-treesitter",
  },
}

annotations.configure_functions = {}
annotations.configure_functions["neogen"] = function()
  require("neogen").setup(doom.modules.annotations.settings)
end

return annotations
