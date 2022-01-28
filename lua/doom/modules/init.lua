-- Doom modules, where all the magic goes
--
-- NOTE: We do not provide other LSP integration like coc.nvim, please refer
--       to our FAQ to see why.

local is_plugin_disabled = require("doom.utils").is_plugin_disabled
local use_floating_win_packer = require("doom.core.config").config.doom.use_floating_win_packer

-- Freeze dependencies and helper function for clean code
local freeze_dependencies = require("doom.core.config").config.doom.freeze_dependencies
local pin_commit = function(commit_sha)
  return freeze_dependencies and commit_sha or nil
end

---- Packer Bootstrap ---------------------------
-------------------------------------------------
local packer_path = vim.fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"

if vim.fn.empty(vim.fn.glob(packer_path)) > 0 then
  require("doom.extras.logging").info("Bootstrapping packer.nvim, please wait ...")
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
  display = {
    open_fn = use_floating_win_packer and function()
      return require("packer.util").float({ border = "single" })
    end or nil,
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
    commit = "02460d4230eb095f7010ecda79650ca25c982923",
    opt = true,
    run = ":TSUpdate",
    config = require("doom.modules.config.doom-treesitter"),
  })
  use({
    "JoosepAlviste/nvim-ts-context-commentstring",
    commit = pin_commit("097df33c9ef5bbd3828105e4bee99965b758dc3f"),
    after = "nvim-treesitter",
  })
  use({
    "nvim-treesitter/nvim-tree-docs",
    commit = pin_commit("4a81ea9426500dca9a103d8ed458185f12344436"),
    after = "nvim-treesitter",
  })
  use({
    "windwp/nvim-ts-autotag",
    commit = pin_commit("32bc46ee8b21f88f87d97b976ae6674595b311b5"),
    after = "nvim-treesitter",
  })

  -- Aniseed, required by some treesitter modules
  use({
    "Olical/aniseed",
    commit = pin_commit("7968693e841ea9d2b4809e23e8ec5c561854b6d6"),
    module_pattern = "aniseed",
  })

  -- Neorg
  local disabled_neorg = is_plugin_disabled("neorg")
  use({
    "nvim-neorg/neorg",
    commit = pin_commit("faffb7600d82bc1be084aa8c58c3ec023ae55342"),
    config = require("doom.modules.config.doom-neorg"),
    disable = disabled_neorg,
    after = { "nvim-treesitter" },
  })

  -- Sessions
  local disabled_sessions = is_plugin_disabled("auto-session")
  use({
    "folke/persistence.nvim",
    commit = pin_commit("77cf5a6ee162013b97237ff25450080401849f85"),
    config = require("doom.modules.config.doom-persistence"),
    -- event = "VimEnter",
    disable = disabled_sessions,
  })

  -----[[------------]]-----
  ---     UI Related     ---
  -----]]------------[[-----
  -- Fancy start screen
  local disabled_dashboard = is_plugin_disabled("dashboard")
  use({
    "glepnir/dashboard-nvim",
    commit = pin_commit("ba98ab86487b8eda3b0934b5423759944b5f7ebd"),
    config = require("doom.modules.config.doom-dashboard"),
    disable = disabled_dashboard,
  })

  -- Doom Colorschemes
  local disabled_doom_themes = is_plugin_disabled("doom-themes")
  use({
    "GustavoPrietoP/doom-themes.nvim",
    commit = pin_commit("03d417d3eab71c320744f8da22251715ba6cee53"),
    disable = disabled_doom_themes,
  })

  -- Development icons
  use({
    "kyazdani42/nvim-web-devicons",
    commit = pin_commit("634e26818f2bea9161b7efa76735746838971824"),
    module = "nvim-web-devicons",
  })

  -- File tree
  local disabled_tree = is_plugin_disabled("explorer")
    and require("doom.core.config").config.doom.use_netrw
  use({
    "kyazdani42/nvim-tree.lua",
    commit = pin_commit("2dfed89af7724f9e71d2fdbe3cde791a93e9b9e0"),
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
  local disabled_ranger = is_plugin_disabled("ranger")
  use({
    "francoiscabrol/ranger.vim",
    commit = pin_commit("91e82debdf566dfaf47df3aef0a5fd823cedf41c"),
    requires = "rbgrouleff/bclose.vim",
    disable = disabled_ranger,
  })

  -- Statusline
  -- can be disabled to use your own statusline
  local disabled_statusline = is_plugin_disabled("statusline")
  use({
    "NTBBloodbath/galaxyline.nvim",
    commit = pin_commit("4d4f5fc8e20a10824117e5beea7ec6e445466a8f"),
    config = require("doom.modules.config.doom-eviline"),
    disable = disabled_statusline,
  })

  -- Tabline
  -- can be disabled to use your own tabline
  local disabled_tabline = is_plugin_disabled("tabline")
  use({
    "akinsho/bufferline.nvim",
    commit = pin_commit("7451dfc97d28e6783dbeb1cdcff12619a9323c98"),
    config = require("doom.modules.config.doom-bufferline"),
    disable = disabled_tabline,
    event = "BufWinEnter",
  })

  -- Better terminal
  -- can be disabled to use your own terminal plugin
  local disabled_terminal = is_plugin_disabled("terminal")
  use({
    "akinsho/toggleterm.nvim",
    commit = pin_commit("d2ceb2ca3268d09db3033b133c0ee4642e07f059"),
    config = require("doom.modules.config.doom-toggleterm"),
    disable = disabled_terminal,
    module = { "toggleterm", "toggleterm.terminal" },
    cmd = { "ToggleTerm", "TermExec" },
    keys = { "n", "<F4>" },
  })

  -- Viewer & finder for LSP symbols and tags
  local disabled_outline = is_plugin_disabled("symbols")
  use({
    "simrat39/symbols-outline.nvim",
    commit = pin_commit("034792838579c4b1515c8a5037aba58ecd1d9b35"),
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
  local disabled_minimap = is_plugin_disabled("minimap")
  use({
    "wfxr/minimap.vim",
    commit = pin_commit("e5707899509be893a530d44b9bed8cff4cda65e1"),
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
  local disabled_whichkey = is_plugin_disabled("which-key")
  use({
    "folke/which-key.nvim",
    commit = pin_commit("28d2bd129575b5e9ebddd88506601290bb2bb221"),
    opt = true,
    config = require("doom.modules.config.doom-whichkey"),
    disable = disabled_whichkey,
  })

  -- popup that shows contents of each register
  local disabled_show_registers = is_plugin_disabled("show_registers")
  use({
    "tversteeg/registers.nvim",
    commit = pin_commit("3a8b22157ad5b68380ee1b751bd87edbd6d46471"),
    disable = disabled_show_registers,
  })

  -- Distraction free environment
  local disabled_zen = is_plugin_disabled("zen")
  use({
    "Pocco81/TrueZen.nvim",
    commit = pin_commit("508b977d71650da5c9243698614a9a1416f116d4"),
    config = require("doom.modules.config.doom-zen"),
    disable = disabled_zen,
    module = "true-zen",
    event = "BufWinEnter",
  })

  -- Highlight other uses of the word under the cursor like VSC
  local disabled_illuminate = is_plugin_disabled("illuminated")
  use({
    "RRethy/vim-illuminate",
    commit = pin_commit("db98338285574265a6ce54370b54d9f939e091bb"),
    setup = function()
      vim.g.Illuminate_ftblacklist = {
        "help",
        "dashboard",
        "packer",
        "norg",
        "DoomInfo",
        "NvimTree",
        "Outline",
        "toggleterm",
      }
    end,
    disable = disabled_illuminate,
    event = "BufRead",
  })

  -----[[--------------]]-----
  ---     Fuzzy Search     ---
  -----]]--------------[[-----
  use({
    "nvim-lua/plenary.nvim",
    commit = pin_commit("563d9f6d083f0514548f2ac4ad1888326d0a1c66"),
    module = "plenary",
  })
  use({
    "nvim-lua/popup.nvim",
    commit = pin_commit("b7404d35d5d3548a82149238289fa71f7f6de4ac"),
    module = "popup",
  })

  local disabled_telescope = is_plugin_disabled("telescope")
  use({
    "nvim-telescope/telescope.nvim",
    commit = pin_commit("0011b1148d3975600f5a9f0be8058cdaac4e30d9"),
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
    commit = pin_commit("e11e852bafa41a4a2c160fcd2d38779add423db9"),
    config = function()
      local doom_root, sep = require("doom.core.system").doom_root, require("doom.core.system").sep
      require("nvim-mapper").setup({
        -- do not assign the default keymap (<leader>MM)
        no_map = true,
        -- where should ripgrep look for your keybinds definitions.
        -- Default config search path is ~/.config/nvim/lua
        search_path = string.format("%s%slua", doom_root, sep),
        -- what should be done with the selected keybind when pressing enter.
        -- Available actions:
        --   * "definition" - Go to keybind definition (default)
        --   * "execute" - Execute the keybind command
        action_on_enter = "execute",
      })
    end,
    disable = disabled_telescope,
  })

  -----[[-------------]]-----
  ---     GIT RELATED     ---
  -----]]-------------[[-----
  -- Git gutter better alternative, written in Lua
  -- can be disabled to use your own git gutter plugin
  local disabled_gitsigns = is_plugin_disabled("gitsigns")
  use({
    "lewis6991/gitsigns.nvim",
    commit = pin_commit("4a2d30f5fb77750c7a42be9bb58a9cc2c6c7f31d"),
    config = require("doom.modules.config.doom-gitsigns"),
    disable = disabled_gitsigns,
    requires = "plenary.nvim",
    event = "BufRead",
  })

  -- Neogit
  local disabled_neogit = is_plugin_disabled("neogit")
  use({
    "TimUntersberger/neogit",
    commit = pin_commit("c8a320359cea86834f62225849a75632258a7503"),
    config = function()
      require("neogit").setup({})
    end,
    disable = disabled_neogit,
    cmd = "Neogit",
    module = "neogit",
  })

  -- LazyGit integration
  local disabled_lazygit = is_plugin_disabled("lazygit")
  use({
    "kdheepak/lazygit.nvim",
    commit = pin_commit("2ee9f4d0fcba6c3645a2cb52eb5fb2f23c7607eb"),
    requires = "plenary.nvim",
    disable = disabled_lazygit,
    cmd = { "LazyGit", "LazyGitConfig" },
  })

  -----[[------------]]-----
  ---     Completion     ---
  -----]]------------[[-----
  local disabled_lsp = is_plugin_disabled("lsp")
  -- Built-in LSP Config
  use({
    "neovim/nvim-lspconfig",
    commit = pin_commit("c51096481dc13193991571b7132740d762902355"),
    config = require("doom.modules.config.doom-lspconfig"),
    disable = disabled_lsp,
  })

  -- Snippets
  local disabled_snippets = is_plugin_disabled("snippets")

  -- Autopairs
  -- can be disabled to use your own autopairs
  local disabled_autopairs = is_plugin_disabled("autopairs")

  -- Completion plugin
  -- can be disabled to use your own completion plugin
  use({
    "hrsh7th/nvim-cmp",
    commit = pin_commit("d93104244c3834fbd8f3dd01da9729920e0b5fe7"),
    wants = { "LuaSnip" },
    requires = {
      {
        "L3MON4D3/LuaSnip",
        commit = pin_commit("09e3bc6da5376aa87a29fde222f321f518e6c120"),
        event = "BufReadPre",
        wants = "friendly-snippets",
        config = require("doom.modules.config.doom-luasnip"),
        disable = disabled_snippets,
        requires = { "rafamadriz/friendly-snippets" },
      },
      {
        "windwp/nvim-autopairs",
        commit = pin_commit("e6b1870cd2e319f467f99188f99b1c3efc5824d2"),
        config = require("doom.modules.config.doom-autopairs"),
        disable = disabled_autopairs,
        event = "BufReadPre",
      },
    },
    config = require("doom.modules.config.doom-cmp"),
    disable = disabled_lsp,
    event = "InsertEnter",
  })
  use({
    "hrsh7th/cmp-nvim-lua",
    commit = pin_commit("d276254e7198ab7d00f117e88e223b4bd8c02d21"),
    disable = disabled_lsp,
    after = "nvim-cmp",
  })
  use({
    "hrsh7th/cmp-nvim-lsp",
    commit = pin_commit("ebdfc204afb87f15ce3d3d3f5df0b8181443b5ba"),
    disable = disabled_lsp,
    after = "nvim-cmp",
  })
  use({
    "hrsh7th/cmp-path",
    commit = pin_commit("c5230cb439df9547294678d0f1c1465ad7989e5f"),
    disable = disabled_lsp,
    after = "nvim-cmp",
  })
  use({
    "hrsh7th/cmp-buffer",
    commit = pin_commit("f83773e2f433a923997c5faad7ea689ec24d1785"),
    disable = disabled_lsp,
    after = "nvim-cmp",
  })
  use({
    "saadparwaiz1/cmp_luasnip",
    commit = pin_commit("d6f837f4e8fe48eeae288e638691b91b97d1737f"),
    disable = disabled_lsp,
    after = "nvim-cmp",
  })

  -- Manage Language serverss with ease.
  use({
    "williamboman/nvim-lsp-installer",
    commit = pin_commit("cb84dcf0d2c274dd0794341ae1366c60ee4c2079"),
    config = require("doom.modules.config.doom-lsp-installer"),
    disable = disabled_lsp,
  })

  -- Show function signature when you type
  use({
    "ray-x/lsp_signature.nvim",
    commit = pin_commit("1178ad69ce5c2a0ca19f4a80a4048a9e4f748e5f"),
    config = require("doom.modules.config.doom-lsp-signature"),
    after = "nvim-lspconfig",
    event = "InsertEnter",
  })

  -- Setup for Lua development in Neovim
  use({
    "folke/lua-dev.nvim",
    commit = pin_commit("a0ee77789d9948adce64d98700cc90cecaef88d5"),
    disable = disabled_lsp,
    module = "lua-dev",
  })

  -----[[-----------]]-----
  ---     Debugging     ---
  -----]]-----------[[-----
  local disabled_dap = is_plugin_disabled("dap")
  use({
    "mfussenegger/nvim-dap",
    commit = pin_commit("c9a58267524f560112ecb6faa36ab2b5bc2f78a3"),
    disable = disabled_dap,
    event = "BufWinEnter",
  })

  use({
    "rcarriga/nvim-dap-ui",
    commit = pin_commit("ae3b003af6c6646832dfe704a1137fd9110ab064"),
    config = require("doom.modules.config.doom-dap-ui"),
    disable = disabled_dap,
    after = "nvim-dap",
  })

  use({
    "Pocco81/DAPInstall.nvim",
    commit = pin_commit("24923c3819a450a772bb8f675926d530e829665f"),
    config = require("doom.modules.config.doom-dap-install"),
    disable = disabled_dap,
    after = "nvim-dap",
  })

  -----[[--------------]]-----
  ---     File Related     ---
  -----]]--------------[[-----
  -- Write / Read files without permissions (e.vim.g. /etc files) without having
  -- to use `sudo nvim /path/to/file`
  local disabled_suda = is_plugin_disabled("suda")
  use({
    "lambdalisue/suda.vim",
    commit = pin_commit("0290c93c148a14eab2b661a1933003d86436f6ec"),
    disable = disabled_suda,
    cmd = { "SudaRead", "SudaWrite" },
  })

  -- File formatting
  -- can be disabled to use your own file formatter
  local disabled_formatter = is_plugin_disabled("formatter")
  use({
    "lukas-reineke/format.nvim",
    commit = pin_commit("29a7dccbdee6d657380104958b4b8e81d316803d"),
    config = require("doom.modules.config.doom-format"),
    disable = disabled_formatter,
    cmd = { "Format", "FormatWrite" },
  })

  -- Linting
  local disabled_linter = is_plugin_disabled("linter")
  use({
    "mfussenegger/nvim-lint",
    commit = pin_commit("e83f80295737e8f470329d768f6ae325bcd0bb23"),
    config = require("doom.modules.config.doom-lint"),
    disable = disabled_linter,
    module = "lint",
  })

  -- Indent Lines
  local disabled_indent_lines = is_plugin_disabled("indentlines")
  use({
    "lukas-reineke/indent-blankline.nvim",
    commit = pin_commit("2e35f7dcdc72f39b37c21e43cdb538d7a41c7e07"),
    config = require("doom.modules.config.doom-blankline"),
    disable = disabled_indent_lines,
    event = "ColorScheme",
  })

  -- EditorConfig support
  local disabled_editorconfig = is_plugin_disabled("editorconfig")
  use({
    "editorconfig/editorconfig-vim",
    commit = pin_commit("a8e3e66deefb6122f476c27cee505aaae93f7109"),
    disable = disabled_editorconfig,
  })

  -- Comments
  -- can be disabled to use your own comments plugin
  local disabled_kommentary = is_plugin_disabled("kommentary")
  use({
    "b3nj5m1n/kommentary",
    commit = pin_commit("a190d052fca4ce74ffddb1c87c87ccf15f9111d5"),
    disable = disabled_kommentary,
    event = "BufWinEnter",
  })

  local disabled_contrib = is_plugin_disabled("contrib")
  -- Lua 5.1 docs
  use({
    "milisims/nvim-luaref",
    commit = pin_commit("dc40d606549db7df1a6e23efa743c90c178333d4"),
    disable = disabled_contrib,
  })
  -- LibUV docs
  use({
    "nanotee/luv-vimdocs",
    commit = pin_commit("fb04e1088a21eefcc396d5a5299468d8742d27a2"),
    disable = disabled_contrib,
  })

  -----[[-------------]]-----
  ---     Web Related     ---
  -----]]-------------[[-----
  -- Fastest colorizer without external dependencies!
  local disabled_colorizer = is_plugin_disabled("colorizer")
  use({
    "norcalli/nvim-colorizer.lua",
    commit = pin_commit("36c610a9717cc9ec426a07c8e6bf3b3abcb139d6"),
    config = require("doom.modules.config.doom-colorizer"),
    disable = disabled_colorizer,
    event = "ColorScheme",
  })

  -- HTTP Client support
  -- Depends on bayne/dot-http to work!
  local disabled_restclient = is_plugin_disabled("restclient")
  use({
    "NTBBloodbath/rest.nvim",
    commit = pin_commit("2826f6960fbd9adb1da9ff0d008aa2819d2d06b3"),
    requires = "plenary.nvim",
    config = function()
      require("rest-nvim").setup()
    end,
    disable = disabled_restclient,
    event = "BufWinEnter",
  })

  local disabled_range_highlight = is_plugin_disabled("range-highlight")
  use({
    "winston0410/range-highlight.nvim",
    commit = pin_commit("8b5e8ccb3460b2c3675f4639b9f54e64eaab36d9"),
    requires = {
      { "winston0410/cmd-parser.nvim", module = "cmd-parser" },
    },
    config = function()
      require("range-highlight").setup()
    end,
    disable = disabled_range_highlight,
    event = "BufRead",
  })

  local disabled_firenvim = is_plugin_disabled("firenvim")
  use({
    "glacambre/firenvim",
    commit = pin_commit("1f9159710d98bbe1e3ef2ce60a4886e2e0ec11c9"),
    disable = disabled_firenvim,
    run = function()
      vim.fn["firenvim#install"](0)
    end,
    config = require("doom.modules.config.doom-fire"),
  })

  local disabled_todo = is_plugin_disabled("todo_comments")
  use({
    "folke/todo-comments.nvim",
    commit = pin_commit("98b1ebf198836bdc226c0562b9f906584e6c400e"),
    requires = "nvim-lua/plenary.nvim",
    config = require("doom.modules.config.doom-todo"),
    disable = disabled_todo,
    event = "ColorScheme",
  })

  local disabled_trouble = is_plugin_disabled("trouble")
  use({
    "folke/trouble.nvim",
    commit = pin_commit("20469be985143d024c460d95326ebeff9971d714"),
    cmd = { "Trouble", "TroubleClose", "TroubleRefresh", "TroubleToggle" },
    requires = "kyazdani42/nvim-web-devicons",
    config = require("doom.modules.config.doom-trouble"),
    disable = disabled_trouble,
  })

  local disabled_superman = is_plugin_disabled("superman")
  use({
    "jez/vim-superman",
    commit = pin_commit("19d307446576d9118625c5d9d3c7a4c9bec5571a"),
    cmd = "SuperMan",
    disable = disabled_superman,
  })

  -----[[----------------]]-----
  ---     Custom Plugins     ---
  -----]]----------------[[-----
  -- If there are custom plugins then also require them
  local custom_plugins = require("doom.core.config.userplugins").plugins

  for _, plug in pairs(custom_plugins or {}) do
    packer.use(plug)
  end
end)
