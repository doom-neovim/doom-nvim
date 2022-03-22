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

annotations.uses = {
  ["neogen"] = {
    "danymat/neogen",
    commit = "b7d2ce8c1d17a0b90f557e5f94372f42193291a5",
    after = "nvim-treesitter",
  },
}

annotations.configs = {}
annotations.configs["neogen"] = function()
  require("neogen").setup(doom.modules.annotations.settings)
end

annotations.binds = {
  { '<leader>c', name = '+code', {
    { 'g', function() require('neogen').generate() end}
  }}
}

return annotations
