local neorg = {}

local doom_root = require("doom.core.system").doom_root

neorg.settings = {
  load = {
    ["core.settings"] = {},
    ["core.keybinds"] = {
      config = {
        default_keybinds = true,
        neorg_leader = ",o",
      },
    },
    ["core.norg.concealer"] = {},
    ["core.norg.dirman"] = {
      config = {
        workspaces = {
          default_workspace = "~/neorg",
          gtd = "~/neorg/gtd",
          doom_docs = string.format("%s/doc", doom_root),
        },
      },
    },
    ["core.gtd.base"] = {
      config = {
        workspace = "gtd",
      },
    },
  },
}

neorg.packages = {
  ["neorg"] = {
    "nvim-neorg/neorg",
    commit = "acfa3929971d488afac9c392fb34b80bac4f4c71",
    opt = "true",
    cmd = "NeorgStart"
  }
}

neorg.configure_functions = {}
neorg.configure_functions["neorg"] = function()
  require("neorg").setup(doom.modules.neorg.settings)
end

neorg.binds = {
  "<leader>",
  name = "+prefix",
  {
    {
      "o",
      name = "+open/close",
      {
        { "g", "<cmd>Neogit<CR>", name = "Neogit" },
      },
    },
    {
      "g",
      name = "+git",
      {
        { "g", "<cmd>Neogit<CR>", name = "Open neogit" },
      },
    },
  },
}

return neorg
