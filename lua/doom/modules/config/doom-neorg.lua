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

  --  If MacOS, check if user is using clang and notify that it has poor compatibility with treesitter
  --  WARN: We probably won't need this forever.
  vim.defer_fn(function()
    local log = require('doom.extras.logging')
    -- Matches logic from nvim-treesitter
    local compilers = { vim.fn.getenv "CC", "cc", "gcc", "clang", "cl", "zig" }
    function select_executable(executables)
      return vim.tbl_filter(function(c)
        return c ~= vim.NIL and vim.fn.executable(c) == 1
      end, executables)[1]
    end
    local cc = select_executable(compilers)
    local version = vim.fn.systemlist(cc .. (cc == "cl" and "" or " --version"))[1]

    if (version:match('Apple clang')) then
      log.warn('doom-neorg:  clang has poor compatibility compiling treesitter parsers.  We recommend using gcc on MacOS, see issue #246 for details.')
    end
  end, 1000)
end
