-- Doom modules, where all the magic goes
--
-- NOTE: We do not provide other LSP integration like coc.nvim, please refer
--       to our FAQ to see why.

local utils = require("doom.utils")
local system = require("doom.core.system")
local functions = require("doom.core.functions")

---- Packer Bootstrap ---------------------------
-------------------------------------------------
local packer_path = vim.fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"

if vim.fn.empty(vim.fn.glob(packer_path)) > 0 then
  vim.fn.system({
    "git",
    "clone",
    "https://github.com/wbthomason/packer.nvim",
    packer_path,
  })
end

-- Load packer
vim.cmd([[ packadd packer.nvim ]])
local packer = require("packer")

-- Change some defaults
packer.init({
  git = {
    clone_timeout = 300, -- 5 mins
    subcommands = {
      -- Prevent packer from downloading all branches metadata to reduce cloning cost
      -- for heavy size plugins like plenary (removed the '--no-single-branch' git flag)
      install = "clone --depth %i --progress",
    },
  },
  profile = {
    enable = true,
  },
})

packer.startup(function(use)
  -----[[------------]]-----
  ---     Essentials     ---
  -----]]------------[[-----
  -- Plugins manager
  use({
    "wbthomason/packer.nvim",
    opt = true,
  })

  -- Tree-Sitter
  use({
    "nvim-treesitter/nvim-treesitter",
    opt = true,
    run = ":TSUpdate",
    config = require("doom.modules.config.doom-treesitter"),
  })
  use({
    "JoosepAlviste/nvim-ts-context-commentstring",
    requires = { "Olical/aniseed" },
    after = "nvim-treesitter",
  })
  use({
    "nvim-treesitter/nvim-tree-docs",
    after = "nvim-treesitter",
  })
  use({
    "windwp/nvim-ts-autotag",
    after = "nvim-treesitter",
  })

  -- Neorg
  local disabled_neorg = functions.is_plugin_disabled("neorg")
  use({
    "nvim-neorg/neorg",
    branch = "unstable",
    config = require("doom.modules.config.doom-neorg"),
    disable = disabled_neorg,
    after = { "nvim-treesitter" },
  })

  -- Sessions
  local disabled_sessions = functions.is_plugin_disabled("auto-session")
  use({
    "folke/persistence.nvim",
    config = require("doom.modules.config.doom-persistence"),
    -- event = "VimEnter",
    disable = disabled_sessions,
  })

  -----[[------------]]-----
  ---     UI Related     ---
  -----]]------------[[-----
  -- Fancy start screen
  local disabled_dashboard = functions.is_plugin_disabled("dashboard")
  use({
    "glepnir/dashboard-nvim",
    config = require("doom.modules.config.doom-dashboard"),
    disable = disabled_dashboard,
  })

  -- Doom Colorschemes
  local disabled_doom_themes = functions.is_plugin_disabled("doom-themes")
  use({
    "GustavoPrietoP/doom-themes.nvim",
    disable = disabled_doom_themes,
    event = "ColorSchemePre",
  })

  -- Development icons
  use({
    "kyazdani42/nvim-web-devicons",
    module = "nvim-web-devicons",
  })

  -- File tree
  local disabled_tree = functions.is_plugin_disabled("explorer")
  use({
    "kyazdani42/nvim-tree.lua",
    requires = "nvim-web-devicons",
    config = require("doom.modules.config.doom-tree"),
    disable = disabled_tree,
    cmd = {
      "NvimTreeClipboard",
      "NvimTreeClose",
      "NvimTreeFindFile",
      "NvimTreeOpen",
      "NvimTreeRefresh",
      "NvimTreeToggle",
    },
  })

  -- Ranger File Browser
  local disabled_ranger = functions.is_plugin_disabled("ranger")
  use({
    "francoiscabrol/ranger.vim",
    requires = "rbgrouleff/bclose.vim",
    disable = disabled_ranger,
  })

  -- Statusline
  -- can be disabled to use your own statusline
  local disabled_statusline = functions.is_plugin_disabled("statusline")
  use({
    "glepnir/galaxyline.nvim",
    config = require("doom.modules.config.doom-eviline"),
    disable = disabled_statusline,
    event = "ColorScheme",
  })

  -- Tabline
  -- can be disabled to use your own tabline
  local disabled_tabline = functions.is_plugin_disabled("tabline")
  use({
    "akinsho/bufferline.nvim",
    config = require("doom.modules.config.doom-bufferline"),
    disable = disabled_tabline,
    event = "ColorScheme",
  })

  -- Better terminal
  -- can be disabled to use your own terminal plugin
  local disabled_terminal = functions.is_plugin_disabled("terminal")
  use({
    "akinsho/toggleterm.nvim",
    config = require("doom.modules.config.doom-toggleterm"),
    disable = disabled_terminal,
    module = { "toggleterm", "toggleterm.terminal" },
    cmd = { "ToggleTerm", "TermExec" },
    keys = { "n", "<F4>" },
  })

  -- Viewer & finder for LSP symbols and tags
  local disabled_outline = functions.is_plugin_disabled("symbols")
  use({
    "simrat39/symbols-outline.nvim",
    config = require("doom.modules.config.doom-symbols"),
    disable = disabled_outline,
    cmd = {
      "SymbolsOutline",
      "SymbolsOutlineOpen",
      "SymbolsOutlineClose",
    },
  })

  -- Minimap
  -- Depends on wfxr/code-minimap to work!
  local disabled_minimap = functions.is_plugin_disabled("minimap")
  use({
    "wfxr/minimap.vim",
    disable = disabled_minimap,
    cmd = {
      "Minimap",
      "MinimapClose",
      "MinimapToggle",
      "MinimapRefresh",
      "MinimapUpdateHighlight",
    },
  })

  -- Keybindings menu like Emacs's guide-key
  local disabled_whichkey = functions.is_plugin_disabled("which-key")
  use({
    "folke/which-key.nvim",
    opt = true,
    config = require("doom.modules.config.doom-whichkey"),
    disable = disabled_whichkey,
  })

  -- popup that shows contents of each register
  local disabled_show_registers = functions.is_plugin_disabled("show_registers")
  use({
    "tversteeg/registers.nvim",
    disable = disabled_show_registers,
  })

  -- Distraction free environment
  local disabled_zen = functions.is_plugin_disabled("zen")
  use({
    "kdav5758/TrueZen.nvim",
    config = require("doom.modules.config.doom-zen"),
    disable = disabled_zen,
    module = "true-zen",
    event = "BufWinEnter",
  })

  -----[[--------------]]-----
  ---     Fuzzy Search     ---
  -----]]--------------[[-----
  use({
    "nvim-lua/plenary.nvim",
    module = "plenary",
  })
  use({
    "nvim-lua/popup.nvim",
    module = "popup",
  })

  local disabled_telescope = functions.is_plugin_disabled("telescope")
  use({
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    module = "telescope",
    requires = {
      "popup.nvim",
      "plenary.nvim",
    },
    config = require("doom.modules.config.doom-telescope"),
    disable = disabled_telescope,
  })
  use({
    "lazytanuki/nvim-mapper",
    config = function()
      local doom_root, sep = require("doom.core.system").doom_root, require("doom.core.system").sep
      require("nvim-mapper").setup({
        -- do not assign the default keymap (<leader>MM)
        no_map = false,
        -- default config search path is ~/.config/nvim/lua
        search_path = string.format("%s%slua", doom_root, sep),
      })
    end,
    module = "nvim-mapper",
    disable = disabled_telescope,
  })

  -----[[-------------]]-----
  ---     GIT RELATED     ---
  -----]]-------------[[-----
  -- Git gutter better alternative, written in Lua
  -- can be disabled to use your own git gutter plugin
  local disabled_gitsigns = functions.is_plugin_disabled("gitsigns")
  use({
    "lewis6991/gitsigns.nvim",
    config = require("doom.modules.config.doom-gitsigns"),
    disable = disabled_gitsigns,
    requires = "plenary.nvim",
    event = "BufRead",
  })

  -- Neogit
  local disabled_neogit = functions.is_plugin_disabled("neogit")
  use({
    "TimUntersberger/neogit",
    config = function()
      require("neogit").setup({})
    end,
    disable = disabled_neogit,
    cmd = "Neogit",
    module = "neogit",
  })

  -- LazyGit integration
  local disabled_lazygit = functions.is_plugin_disabled("lazygit")
  use({
    "kdheepak/lazygit.nvim",
    requires = "plenary.nvim",
    disable = disabled_lazygit,
    cmd = { "LazyGit", "LazyGitConfig" },
  })

  -----[[------------]]-----
  ---     Completion     ---
  -----]]------------[[-----
  local disabled_lsp = functions.is_plugin_disabled("lsp")
  -- Built-in LSP Config
  use({
    "neovim/nvim-lspconfig",
    config = require("doom.modules.config.doom-lspconfig"),
    disable = disabled_lsp,
    event = "ColorScheme",
  })

  -- Completion plugin
  -- can be disabled to use your own completion plugin
  use({
    "hrsh7th/nvim-compe",
    requires = {
      {
        "ray-x/lsp_signature.nvim",
        config = require("doom.modules.config.doom-lsp-signature"),
      },
    },
    config = require("doom.modules.config.doom-compe"),
    disable = disabled_lsp,
    opt = true,
    after = "nvim-lspconfig",
  })

  -- Snippets
  local disabled_snippets = functions.is_plugin_disabled("snippets")
  use({
    "L3MON4D3/LuaSnip",
    config = require("doom.modules.config.doom-luasnip"),
    disable = disabled_snippets,
    requires = { "rafamadriz/friendly-snippets" },
    event = "BufWinEnter",
  })

  -- provides the missing `:LspInstall` for `nvim-lspconfig`.
  use({
    "kabouzeid/nvim-lspinstall",
    config = require("doom.modules.config.doom-lspinstall"),
    disable = disabled_lsp,
    after = "nvim-lspconfig",
  })

  -- Setup for Lua development in Neovim
  use({
    "folke/lua-dev.nvim",
    disable = disabled_lsp,
    module = "lua-dev",
  })

  -----[[-----------]]-----
  ---     Debugging     ---
  -----]]-----------[[-----
  local disabled_dap = functions.is_plugin_disabled("dap")
  use({
    "mfussenegger/nvim-dap",
    disable = disabled_dap,
    event = "ColorScheme",
  })

  use({
    "rcarriga/nvim-dap-ui",
    config = require("doom.modules.config.doom-dap-ui"),
    disable = disabled_dap,
    after = "nvim-dap",
  })

  use({
    "Pocco81/DAPInstall.nvim",
    disable = disabled_dap,
    after = "nvim-dap",
  })

  -----[[--------------]]-----
  ---     File Related     ---
  -----]]--------------[[-----
  -- Write / Read files without permissions (e.vim.g. /etc files) without having
  -- to use `sudo nvim /path/to/file`
  local disabled_suda = functions.is_plugin_disabled("suda")
  use({
    "lambdalisue/suda.vim",
    disable = disabled_suda,
    cmd = { "SudaRead", "SudaWrite" },
  })

  -- File formatting
  -- can be disabled to use your own file formatter
  local disabled_formatter = functions.is_plugin_disabled("formatter")
  use({
    "lukas-reineke/format.nvim",
    config = require("doom.modules.config.doom-format"),
    disable = disabled_formatter,
    event = "BufWinEnter",
  })

  -- Autopairs
  -- can be disabled to use your own autopairs
  local disabled_autopairs = functions.is_plugin_disabled("autopairs")
  use({
    "windwp/nvim-autopairs",
    config = require("doom.modules.config.doom-autopairs"),
    disable = disabled_autopairs,
    event = "InsertEnter",
  })

  -- Indent Lines
  local disabled_indent_lines = functions.is_plugin_disabled("indentlines")
  use({
    "lukas-reineke/indent-blankline.nvim",
    config = require("doom.modules.config.doom-blankline"),
    disable = disabled_indent_lines,
    event = "ColorScheme",
  })

  -- EditorConfig support
  local disabled_editorconfig = functions.is_plugin_disabled("editorconfig")
  use({
    "editorconfig/editorconfig-vim",
    disable = disabled_editorconfig,
  })

  -- Comments
  -- can be disabled to use your own comments plugin
  local disabled_kommentary = functions.is_plugin_disabled("kommentary")
  use({
    "b3nj5m1n/kommentary",
    disable = disabled_kommentary,
    event = "BufWinEnter",
  })

  -----[[-------------]]-----
  ---     Web Related     ---
  -----]]-------------[[-----
  -- Fastest colorizer without external dependencies!
  local disabled_colorizer = functions.is_plugin_disabled("colorizer")
  use({
    "norcalli/nvim-colorizer.lua",
    config = require("doom.modules.config.doom-colorizer"),
    disable = disabled_colorizer,
    event = "ColorScheme",
  })

  -- HTTP Client support
  -- Depends on bayne/dot-http to work!
  local disabled_restclient = functions.is_plugin_disabled("restclient")
  use({
    "NTBBloodbath/rest.nvim",
    requires = "plenary.nvim",
    config = function()
      require("rest-nvim").setup()
    end,
    disable = disabled_restclient,
    event = "BufWinEnter",
  })

  local disabled_range_highlight = functions.is_plugin_disabled("range-highlight")
  use({
    "winston0410/range-highlight.nvim",
    requires = {
      { "winston0410/cmd-parser.nvim", module = "cmd-parser" },
    },
    config = function()
      require("range-highlight").setup()
    end,
    disable = disabled_range_highlight,
    event = "BufRead",
  })

  local disabled_firenvim = functions.is_plugin_disabled("firenvim")
  use({
    "glacambre/firenvim",
    disable = disabled_firenvim,
    run = function()
      vim.fn["firenvim#install"](0)
    end,
    config = require("doom.modules.config.doom-fire"),
  })

  use({
    "folke/todo-comments.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = require("doom.modules.config.doom-todo"),
  })
  use({
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = require("doom.modules.config.doom-trouble"),
  })
  use({ "jez/vim-superman" })

  -----[[----------------]]-----
  ---     Custom Plugins     ---
  -----]]----------------[[-----
  -- If there are custom plugins then also require them
  local custom_plugins
  if utils.file_exists(string.format("%s%splugins.lua", system.doom_configs_root, system.sep)) then
    custom_plugins = dofile(string.format("%s%splugins.lua", system.doom_configs_root, system.sep))
  else
    custom_plugins = dofile(string.format("%s%splugins.lua", system.doom_root, system.sep))
  end

  for _, plug in pairs(custom_plugins or {}) do
    packer.use(plug)
  end
end)
