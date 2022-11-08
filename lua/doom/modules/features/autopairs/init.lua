local DoomModule = require('doom.modules').DoomModule

---@toc doom.features.autopairs
---@text # Autopairs
---
--- Automatically completes pairs of characters such as quotes and brackets.
---

local autopairs = DoomModule.new("autopairs")

---@eval return doom.core.doc_gen.generate_settings_documentation(MiniDoc.current.eval_section, "features.autopairs")
autopairs.settings = {
  enable_afterquote = true,
  enable_check_bracket_line = true,
  enable_moveright = true,
}
---minidoc_afterlines_end

---@eval return doom.core.doc_gen.generate_packages_documentation("features.autopairs")
autopairs.packages = {
  ["nvim-autopairs"] = {
    "windwp/nvim-autopairs",
    commit = "4fc96c8f3df89b6d23e5092d31c866c53a346347",
    event = "BufReadPost",
  },
}

autopairs.configs = {}
autopairs.configs["nvim-autopairs"] = function()
  require("nvim-autopairs").setup(
    vim.tbl_deep_extend("force", doom.features.autopairs.settings, { check_ts = true })
  )
end

---@eval return doom.core.doc_gen.generate_keybind_documentation("features.autopairs")
autopairs.binds = {
  "<leader>",
  name = "+prefix",
  {
    {
      "t",
      name = "+tweak",
      {
        {
          "p",
          function()
            local autopairs_plugin = require("nvim-autopairs")
            if autopairs_plugin.state.disabled then
              autopairs_plugin.enable()
            else
              autopairs_plugin.disable()
            end
          end,
          name = "Toggle autopairs",
        },
      },
    },
  },
}
return autopairs
