return function()
  local doom_root = require("doom.core.system").doom_root

  -- Default setup for Neorg
  require("neorg").setup({
    -- Tell Neorg what modules to load
    load = {
      ["core.defaults"] = {}, -- Load all the default modules
      ["core.keybinds"] = { -- Configure core.keybinds
        config = {
          default_keybinds = true, -- Generate the default keybinds
          neorg_leader = ",o", -- This is the default if unspecified
        },
      },
      ["core.norg.concealer"] = {}, -- Allows for use of icons
      ["core.norg.dirman"] = { -- Manage your directories with Neorg
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
  })
end
