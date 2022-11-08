local DoomModule = require('doom.modules').DoomModule

---@toc doom.features.annotations
---@text # Code annotations
---
--- Adds the ability to generate annotations from function, class or variable
--- signatures.
---

local annotations = DoomModule.new("annotations")

---@eval return doom.core.doc_gen.generate_settings_documentation(MiniDoc.current.eval_section, "features.annotations")
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
---minidoc_afterlines_end

---@eval return doom.core.doc_gen.generate_packages_documentation("features.annotations")
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

---@eval return doom.core.doc_gen.generate_keybind_documentation("features.annotations")
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
