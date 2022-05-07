local neorg = {}

local doom_root = require("doom.core.system").doom_root

neorg.settings = {
  load = {
    ["core.defaults"] = {},
    ["core.keybinds"] = {
      config = {
        default_keybinds = true,
        neorg_leader = ",o",
      },
    },
    ["core.norg.concealer"] = {},
    ["core.norg.qol.toc"] = {},
    ["core.norg.dirman"] = {
      config = {
        workspaces = {
          main = "~/neorg",
          gtd = "~/neorg/gtd",
          doom_docs = string.format("%s/doc", doom_root),
        },
        autodetect = true,
        autochdir = true,
      },
    },
    ["core.norg.esupports.metagen"] = {
      config = { type = "auto" },
    },
    ["core.export"] = {},
    ["core.export.markdown"] = {
      config = { extensions = "all" },
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
    commit = "633dfc9f0c3a00a32ee89d4ab826da2eecfe9bd8",
    after = "nvim-treesitter",
  }
}

neorg.configs = {}
neorg.configs["neorg"] = function()
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
