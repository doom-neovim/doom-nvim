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
    commit = {
      ["nvim-0.7"] = "d93126cfcc2b5f90c063676f8669fed9b0806bcd",
      ["latest"] = "07eafea0312379f6adb327cbdb69594108e2dd57",
    },
    cmd = "Neorg",
    after = "nvim-treesitter",
  },
}

neorg.configs = {}
neorg.configs["neorg"] = function()
  require("neorg").setup(doom.features.neorg.settings)
end

neorg.autocmds = {
  {
    "BufWinEnter",
    "*.norg",
    function()
      -- Manually add norg parser to be always up-to-date
      -- and add additional (opt-in) neorg parsers
      local parsers = require("nvim-treesitter.parsers").get_parser_configs()

      parsers.norg = {
        install_info = {
          url = "https://github.com/nvim-neorg/tree-sitter-norg",
          files = { "src/parser.c", "src/scanner.cc" },
          branch = "main",
        },
      }
      parsers.norg_meta = {
        install_info = {
          url = "https://github.com/nvim-neorg/tree-sitter-norg-meta",
          files = { "src/parser.c" },
          branch = "main",
        },
      }
      parsers.norg_table = {
        install_info = {
          url = "https://github.com/nvim-neorg/tree-sitter-norg-table",
          files = { "src/parser.c" },
          branch = "main",
        },
      }

      vim.defer_fn(function()
        local ensure_installed = require("nvim-treesitter.install").ensure_installed
        ensure_installed("norg")
        ensure_installed("norg_meta")
        ensure_installed("norg_table")
      end, 0)
    end,
  },
}

return neorg
