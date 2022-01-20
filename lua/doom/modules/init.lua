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
      "afed686e6a8fc1035475d8c56c1b5ff252c346e5"
    ) or pin_commit("47cfda2c6711077625c90902d7722238a8294982"),
    opt = true,
    run = ":TSUpdate",
    branch = vim.fn.has("nvim-0.6.0") == 1 and "master" or "0.5-compat",
    config = require("doom.modules.config.doom-treesitter"),
  })
  use({
    "JoosepAlviste/nvim-ts-context-commentstring",
    commit = pin_commit("9f5e422e1030e7073e593ad32c5354aa0bcb0176"),
    after = "nvim-treesitter",
  })
  use({
    "nvim-treesitter/nvim-tree-docs",
    commit = pin_commit("15135bd18c8f0c4d67dd1b36d3b2cd64579aab6f"),
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
    commit = pin_commit("9c8f2cd17d454a38b11cedd323579b579ee27f9c"),
    module_pattern = "aniseed",
  })

  -- Neorg
  local disabled_neorg = is_plugin_disabled("neorg")
  use({
    "nvim-neorg/neorg",
    --[[NO AUTO UPDATE]]
    commit = pin_commit("1a4759d799a382838d793adc55c1faf02236c90a"),
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
    commit = pin_commit("8df4988ecf8599fc1f8f387bbf2eae790e4c5ffb"),
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
    commit = pin_commit("00a98203a38dd38b670aa70ef965c4e9be5573ef"),
    config = require("doom.modules.config.doom-bufferline"),
    disable = disabled_tabline,
    event = "BufWinEnter",
  })

  -- Better terminal
  -- can be disabled to use your own terminal plugin
  local disabled_terminal = is_plugin_disabled("terminal")
  use({
    "akinsho/toggleterm.nvim",
    commit = pin_commit("ff168c8218b963cc7fc9d80b684d840488839bb5"),
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
    commit = pin_commit("35c0dd759938459d866aba1bdf0f1fc0b670ed61"),
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
    commit = pin_commit("387fd676d3f9b419d38890820f6e262dc0fadb46"),
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
    commit = pin_commit("2beae0581caa66cf8c09fad7c7c557f92d49d2bd"),
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
    commit = pin_commit("b7404d35d5d3548a82149238289fa71f7f6de4ac"),
    module = "popup",
  })

  local disabled_telescope = is_plugin_disabled("telescope")
  use({
    "nvim-telescope/telescope.nvim",
    commit = pin_commit("1c57cc6140644695f0d9bd71b63de45feeca6ae7"),
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
    commit = pin_commit("95845ef39ce0a98f68cdfdcf7dd586c5e965acc7"),
    config = require("doom.modules.config.doom-gitsigns"),
    disable = disabled_gitsigns,
    requires = "plenary.nvim",
    event = "BufRead",
  })

  -- Neogit
  local disabled_neogit = is_plugin_disabled("neogit")
  use({
    "TimUntersberger/neogit",
    commit = pin_commit("ab772d21b108127ad6c703f7457c279f5817f379"),
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
    commit = pin_commit("497ef5578e15f6c79deef1cad71adedd1c80abd4"),
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
    commit = pin_commit("1cb8583d186d28f2959eac5d74a74dc745fae099"),
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
    commit = pin_commit("2e4270d02843d15510b3549354e238788ca07ca5"),
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
    commit = pin_commit("81518cf6ae29f5f0c79cd47770ae90ff5225ee13"),
    disable = disabled_lsp,
    after = "nvim-cmp",
  })
  use({
    "hrsh7th/cmp-buffer",
    commit = pin_commit("a706dc69c49110038fe570e5c9c33d6d4f67015b"),
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
    commit = pin_commit("bcce5db53b966e2dbd97fc8d1bbfa7db4a405f13"),
    config = require("doom.modules.config.doom-lsp-installer"),
    disable = disabled_lsp,
  })

  -- Show function signature when you type
  use({
    "ray-x/lsp_signature.nvim",
    commit = pin_commit("c7b2b2e14b597c077804ae201f1ec9a7dac76ad0"),
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
    commit = pin_commit("4e8bb7ca12dc8ca6f7a500cbb4ecea185665c7f1"),
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
    commit = pin_commit("c3c8a247fda421b0db1f2cbf50ab4340ba0ffc61"),
    config = require("doom.modules.config.doom-lint"),
    disable = disabled_linter,
    module = "lint",
  })

  -- Indent Lines
  local disabled_indent_lines = is_plugin_disabled("indentlines")
  use({
    "lukas-reineke/indent-blankline.nvim",
    commit = pin_commit("caf7f61e94525bbd97e32f118efd6c0722430616"),
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
    commit = pin_commit("e1c34175ee0b2293e8b9c06c11f2fc63f4262918"),
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
    commit = pin_commit("7320a805f51b4cf03de4e3b30088838d3f84adda"),
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
