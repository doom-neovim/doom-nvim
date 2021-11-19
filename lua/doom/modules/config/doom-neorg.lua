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

  --  Check if user is using clang and notify that it has poor compatibility with treesitter
  --  WARN: 19/11/2021 | issues: #222, #246 clang compatibility could improve in future
  vim.defer_fn(function()
    local log = require("doom.extras.logging")
    local utils = require("doom.utils")
    -- Matches logic from nvim-treesitter
    local compiler = utils.find_executable_in_path({
      vim.fn.getenv("CC"),
      "cc",
      "gcc",
      "clang",
      "cl",
      "zig",
    })
    local version = vim.fn.systemlist(compiler .. (compiler == "cl" and "" or " --version"))[1]

    if version:match("clang") then
      log.warn(
        "doom-neorg:  clang has poor compatibility compiling treesitter parsers.  We recommend using gcc instead, see issue #246 for details.  (https://github.com/NTBBloodbath/doom-nvim/issues/246)"
      )
    end
  end, 1000)
end
