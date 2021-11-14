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
    commit = vim.fn.has("nvim-0.6.0") == 1 and pin_commit(
      "a47df48e7d4232fd771f2537a4fb43f582c026c9"
    ) or pin_commit("47cfda2c6711077625c90902d7722238a8294982"),
    opt = true,
    run = ":TSUpdate",
    branch = vim.fn.has("nvim-0.6.0") == 1 and "master" or "0.5-compat",
    config = require("doom.modules.config.doom-treesitter"),
  })
  use({
    "JoosepAlviste/nvim-ts-context-commentstring",
    commit = pin_commit("ce74852c36008b11dda451bfe6c2ed71c535152b"),
    after = "nvim-treesitter",
  })
  use({
    "nvim-treesitter/nvim-tree-docs",
    commit = pin_commit("864c2f5023fa7399aa084fd81c0e2f8dedfd32e3"),
    after = "nvim-treesitter",
  })
  use({
    "windwp/nvim-ts-autotag",
    commit = pin_commit("80d427af7b898768c8d8538663d52dee133da86f"),
    after = "nvim-treesitter",
  })

  -- Aniseed, required by some treesitter modules
  use({
    "Olical/aniseed",
    commit = pin_commit("4bb3a4c1a1e329ebefa7ff022f7b3947770f7f26"),
    module_pattern = "aniseed",
  })

  -- Neorg
  local disabled_neorg = is_plugin_disabled("neorg")
  use({
    "nvim-neorg/neorg",
    commit = --[[NO AUTO UPDATE]] pin_commit("17602389089d56907bbfc026c3dba19f9d24c2dd"),
    branch = "unstable",
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
    commit = pin_commit("f936ff3e1f9d58ec0caf0bd398e9675b54fe292e"),
    module = "nvim-web-devicons",
  })

  -- File tree
  local disabled_tree = is_plugin_disabled("explorer")
    and require("doom.core.config").config.doom.use_netrw
  use({
    "kyazdani42/nvim-tree.lua",
    commit = pin_commit("5d8453dfbd34ab00cb3e8ce39660f9a54cdd35f3"),
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
    commit = pin_commit("7b812cfddfcac7d9031e2f8e03f2b71fe8b2558d"),
    config = require("doom.modules.config.doom-eviline"),
    disable = disabled_statusline,
  })

  -- Tabline
  -- can be disabled to use your own tabline
  local disabled_tabline = is_plugin_disabled("tabline")
  use({
    "akinsho/bufferline.nvim",
    commit = pin_commit("782fab8a2352e872dc991c42f806dae18e848b2d"),
    config = require("doom.modules.config.doom-bufferline"),
    disable = disabled_tabline,
    event = "BufWinEnter",
  })

  -- Better terminal
  -- can be disabled to use your own terminal plugin
  local disabled_terminal = is_plugin_disabled("terminal")
  use({
    "akinsho/toggleterm.nvim",
    commit = pin_commit("0b6d65d8b45e261bc17176e86abb3f631c88fc1b"),
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
    commit = pin_commit("552b67993ed959993279e0b0f8a1da9f3c5e6fc0"),
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
    commit = pin_commit("5c54258d34b8ae4be70a8fbc09b400eb7be0bee8"),
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
    commit = pin_commit("d3032b6d3e0adb667975170f626cb693bfc66baa"),
    opt = true,
    config = require("doom.modules.config.doom-whichkey"),
    disable = disabled_whichkey,
  })

  -- popup that shows contents of each register
  local disabled_show_registers = is_plugin_disabled("show_registers")
  use({
    "tversteeg/registers.nvim",
    commit = pin_commit("4d1f3525c6f9be4297e99e6aed515af3677d7241"),
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
    commit = pin_commit("084b012ce5bc1bf302b69eb73562146afe0a9756"),
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
    commit = pin_commit("1c31adb35fcebe921f65e5c6ff6d5481fa5fa5ac"),
    module = "plenary",
  })
  use({
    "nvim-lua/popup.nvim",
    commit = pin_commit("f91d80973f80025d4ed00380f2e06c669dfda49d"),
    module = "popup",
  })

  local disabled_telescope = is_plugin_disabled("telescope")
  use({
    "nvim-telescope/telescope.nvim",
    commit = pin_commit("729492406ec3b545c4ecf2beadf7bd30c81e70e4"),
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
    commit = pin_commit("bfc4543262442a336e257d2d9fac16aa1de532a9"),
    config = require("doom.modules.config.doom-gitsigns"),
    disable = disabled_gitsigns,
    requires = "plenary.nvim",
    event = "BufRead",
  })

  -- Neogit
  local disabled_neogit = is_plugin_disabled("neogit")
  use({
    "TimUntersberger/neogit",
    commit = pin_commit("807e4a795dc6c2383b281fc27bd1bc6c197d98cd"),
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
    commit = pin_commit("bcd111df61abe90b133cb08ea577c02af44ca5ce"),
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
    commit = pin_commit("4191b1fca3bafe759ae5606d19e0f0e54e9fc83b"),
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
    commit = pin_commit("753f5b7c92da0302efffc5ce6780dffe0602bdf3"),
    wants = { "LuaSnip" },
    requires = {
      {
        "L3MON4D3/LuaSnip",
        commit = pin_commit("a54b21aee0423dbdce121c858ad6a88a58ef6e0f"),
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
    commit = pin_commit("134117299ff9e34adde30a735cd8ca9cf8f3db81"),
    disable = disabled_lsp,
    after = "nvim-cmp",
  })
  use({
    "hrsh7th/cmp-path",
    commit = pin_commit("98ded32b9c4d95aa95af70b9979b767f39073f0e"),
    disable = disabled_lsp,
    after = "nvim-cmp",
  })
  use({
    "hrsh7th/cmp-buffer",
    commit = pin_commit("2d85e76c725a389b72067f86fc3c65f3868b9a59"),
    disable = disabled_lsp,
    after = "nvim-cmp",
  })
  use({
    "saadparwaiz1/cmp_luasnip",
    commit = pin_commit("16832bb50e760223a403ffa3042859845dd9ef9d"),
    disable = disabled_lsp,
    after = "nvim-cmp",
  })

  -- Manage Language serverss with ease.
  use({
    "williamboman/nvim-lsp-installer",
    commit = pin_commit("35d4b08d60c17b79f8e16e9e66f0d7693c99d612"),
    config = require("doom.modules.config.doom-lsp-installer"),
    disable = disabled_lsp,
  })

  -- Show function signature when you type
  use({
    "ray-x/lsp_signature.nvim",
    commit = pin_commit("600111e6249bcc948e2b811ef09adf4ea84ebfc1"),
    config = require("doom.modules.config.doom-lsp-signature"),
    after = "nvim-lspconfig",
    event = "InsertEnter",
  })

  -- Setup for Lua development in Neovim
  use({
    "folke/lua-dev.nvim",
    commit = pin_commit("6a7abb62af1b6a4411a3f5ea5cf0cb6b47878cc0"),
    disable = disabled_lsp,
    module = "lua-dev",
  })

  -----[[-----------]]-----
  ---     Debugging     ---
  -----]]-----------[[-----
  local disabled_dap = is_plugin_disabled("dap")
  use({
    "mfussenegger/nvim-dap",
    commit = pin_commit("1a87456d280e8e308df7983650a5ea2b5a6bfb63"),
    disable = disabled_dap,
    event = "BufWinEnter",
  })

  use({
    "rcarriga/nvim-dap-ui",
    commit = pin_commit("649e0fee4f0b8dc6305dd29065c7623c3dc6a032"),
    config = require("doom.modules.config.doom-dap-ui"),
    disable = disabled_dap,
    after = "nvim-dap",
  })

  use({
    "Pocco81/DAPInstall.nvim",
    commit = pin_commit("dd09e9dd3a6e29f02ac171515b8a089fb82bb425"),
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
    commit = pin_commit("c46ab8b46100e26fce4d6ce69a94d4cea8b9f4d7"),
    config = require("doom.modules.config.doom-format"),
    disable = disabled_formatter,
    cmd = { "Format", "FormatWrite" },
  })

  -- Linting
  local disabled_linter = is_plugin_disabled("linter")
  use({
    "mfussenegger/nvim-lint",
    commit = pin_commit("0116b78963fd24643faa34fa1bc02f8d425a73ef"),
    config = require("doom.modules.config.doom-lint"),
    disable = disabled_linter,
    module = "lint",
  })

  -- Indent Lines
  local disabled_indent_lines = is_plugin_disabled("indentlines")
  use({
    "lukas-reineke/indent-blankline.nvim",
    commit = pin_commit("9f663d31d4ee0672f24cd5b26ca3863665048a25"),
    config = require("doom.modules.config.doom-blankline"),
    disable = disabled_indent_lines,
    event = "ColorScheme",
  })

  -- EditorConfig support
  local disabled_editorconfig = is_plugin_disabled("editorconfig")
  use({
    "editorconfig/editorconfig-vim",
    commit = pin_commit("3078cd10b28904e57d878c0d0dab42aa0a9fdc89"),
    disable = disabled_editorconfig,
  })

  -- Comments
  -- can be disabled to use your own comments plugin
  local disabled_kommentary = is_plugin_disabled("kommentary")
  use({
    "b3nj5m1n/kommentary",
    commit = pin_commit("8f1cd74ad28de7d7c4fda5d8e8557ff240904b42"),
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
    commit = pin_commit("759bf5b1a8cd15ecf6ecf2407a826d4be6ec3414"),
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
    commit = pin_commit("0ff2821cc0a561ac79596f358b26674c87483efa"),
    disable = disabled_firenvim,
    run = function()
      vim.fn["firenvim#install"](0)
    end,
    config = require("doom.modules.config.doom-fire"),
  })

  local disabled_todo = is_plugin_disabled("todo_comments")
  use({
    "folke/todo-comments.nvim",
    commit = pin_commit("9983edc5ef38c7a035c17c85f60ee13dbd75dcc8"),
    requires = "nvim-lua/plenary.nvim",
    config = require("doom.modules.config.doom-todo"),
    disable = disabled_todo,
    event = "ColorScheme",
  })

  local disabled_trouble = is_plugin_disabled("trouble")
  use({
    "folke/trouble.nvim",
    commit = pin_commit("756f09de113a775ab16ba6d26c090616b40a999d"),
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
