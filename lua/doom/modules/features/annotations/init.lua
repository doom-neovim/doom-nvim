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
    commit = "778a8537865a2c692ba4909b72e1b14ea98999c6",
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
