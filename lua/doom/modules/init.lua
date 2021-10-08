-- Doom modules, where all the magic goes
--
-- NOTE: We do not provide other LSP integration like coc.nvim, please refer
--       to our FAQ to see why.

local is_plugin_disabled = require("doom.utils").is_plugin_disabled
local use_floating_win_packer = require("doom.core.config").config.doom.use_floating_win_packer

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
    opt = true,
    run = ":TSUpdate",
    branch = vim.fn.has("nvim-0.6.0") == 1 and "master" or "0.5-compat",
    config = require("doom.modules.config.doom-treesitter"),
  })
  use({
    "JoosepAlviste/nvim-ts-context-commentstring",
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

  -- Aniseed, required by some treesitter modules
  use({
    "Olical/aniseed",
    module_pattern = "aniseed",
  })

  -- Neorg
  local disabled_neorg = is_plugin_disabled("neorg")
  use({
    "nvim-neorg/neorg",
    branch = "pandoc-integration",
    config = require("doom.modules.config.doom-neorg"),
    disable = disabled_neorg,
    after = { "nvim-treesitter" },
  })

  -- Sessions
  local disabled_sessions = is_plugin_disabled("auto-session")
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
  local disabled_dashboard = is_plugin_disabled("dashboard")
  use({
    "glepnir/dashboard-nvim",
    config = require("doom.modules.config.doom-dashboard"),
    disable = disabled_dashboard,
  })

  -- Doom Colorschemes
  local disabled_doom_themes = is_plugin_disabled("doom-themes")
  use({
    "GustavoPrietoP/doom-themes.nvim",
    disable = disabled_doom_themes,
  })

  -- Development icons
  use({
    "kyazdani42/nvim-web-devicons",
    module = "nvim-web-devicons",
  })

  -- File tree
  local disabled_tree = is_plugin_disabled("explorer")
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
  local disabled_ranger = is_plugin_disabled("ranger")
  use({
    "francoiscabrol/ranger.vim",
    requires = "rbgrouleff/bclose.vim",
    disable = disabled_ranger,
  })

  -- Statusline
  -- can be disabled to use your own statusline
  local disabled_statusline = is_plugin_disabled("statusline")
  use({
    "NTBBloodbath/galaxyline.nvim",
    config = require("doom.modules.config.doom-eviline"),
    disable = disabled_statusline,
  })

  -- Tabline
  -- can be disabled to use your own tabline
  local disabled_tabline = is_plugin_disabled("tabline")
  use({
    "akinsho/bufferline.nvim",
    config = require("doom.modules.config.doom-bufferline"),
    disable = disabled_tabline,
    event = "BufWinEnter",
  })

  -- Better terminal
  -- can be disabled to use your own terminal plugin
  local disabled_terminal = is_plugin_disabled("terminal")
  use({
    "akinsho/toggleterm.nvim",
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
    opt = true,
    config = require("doom.modules.config.doom-whichkey"),
    disable = disabled_whichkey,
  })

  -- popup that shows contents of each register
  local disabled_show_registers = is_plugin_disabled("show_registers")
  use({
    "tversteeg/registers.nvim",
    disable = disabled_show_registers,
  })

  -- Distraction free environment
  local disabled_zen = is_plugin_disabled("zen")
  use({
    "kdav5758/TrueZen.nvim",
    config = require("doom.modules.config.doom-zen"),
    disable = disabled_zen,
    module = "true-zen",
    event = "BufWinEnter",
  })

  -- Highlight other uses of the word under the cursor like VSC
  local disabled_illuminate = is_plugin_disabled("illuminated")
  use({
    "RRethy/vim-illuminate",
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
    module = "plenary",
  })
  use({
    "nvim-lua/popup.nvim",
    module = "popup",
  })

  local disabled_telescope = is_plugin_disabled("telescope")
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
    config = require("doom.modules.config.doom-gitsigns"),
    disable = disabled_gitsigns,
    requires = "plenary.nvim",
    event = "BufRead",
  })

  -- Neogit
  local disabled_neogit = is_plugin_disabled("neogit")
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
  local disabled_lazygit = is_plugin_disabled("lazygit")
  use({
    "kdheepak/lazygit.nvim",
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
    wants = { "LuaSnip" },
    requires = {
      {
        "L3MON4D3/LuaSnip",
        event = "BufReadPre",
        wants = "friendly-snippets",
        config = require("doom.modules.config.doom-luasnip"),
        disable = disabled_snippets,
        requires = { "rafamadriz/friendly-snippets" },
      },
      {
        "windwp/nvim-autopairs",
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
    disable = disabled_lsp,
    after = "nvim-cmp",
  })
  use({
    "hrsh7th/cmp-nvim-lsp",
    disable = disabled_lsp,
    after = "nvim-cmp",
  })
  use({
    "hrsh7th/cmp-path",
    disable = disabled_lsp,
    after = "nvim-cmp",
  })
  use({
    "hrsh7th/cmp-buffer",
    disable = disabled_lsp,
    after = "nvim-cmp",
  })
  use({
    "saadparwaiz1/cmp_luasnip",
    disable = disabled_lsp,
    after = "nvim-cmp",
  })

  -- provides the missing `:LspInstall` for `nvim-lspconfig`.
  use({
    "kabouzeid/nvim-lspinstall",
    config = require("doom.modules.config.doom-lspinstall"),
    disable = disabled_lsp,
  })

  -- Show function signature when you type
  use({
    "ray-x/lsp_signature.nvim",
    config = require("doom.modules.config.doom-lsp-signature"),
    after = "nvim-lspconfig",
    event = "InsertEnter",
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
  local disabled_dap = is_plugin_disabled("dap")
  use({
    "mfussenegger/nvim-dap",
    disable = disabled_dap,
    event = "BufWinEnter",
  })

  use({
    "rcarriga/nvim-dap-ui",
    config = require("doom.modules.config.doom-dap-ui"),
    disable = disabled_dap,
    after = "nvim-dap",
  })

  use({
    "Pocco81/DAPInstall.nvim",
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
    disable = disabled_suda,
    cmd = { "SudaRead", "SudaWrite" },
  })

  -- File formatting
  -- can be disabled to use your own file formatter
  local disabled_formatter = is_plugin_disabled("formatter")
  use({
    "lukas-reineke/format.nvim",
    config = require("doom.modules.config.doom-format"),
    disable = disabled_formatter,
    cmd = { "Format", "FormatWrite" },
  })

  -- Linting
  local disabled_linter = is_plugin_disabled("linter")
  use({
    "mfussenegger/nvim-lint",
    config = require("doom.modules.config.doom-lint"),
    disable = disabled_linter,
    module = "lint",
  })

  -- Indent Lines
  local disabled_indent_lines = is_plugin_disabled("indentlines")
  use({
    "lukas-reineke/indent-blankline.nvim",
    config = require("doom.modules.config.doom-blankline"),
    disable = disabled_indent_lines,
    event = "ColorScheme",
  })

  -- EditorConfig support
  local disabled_editorconfig = is_plugin_disabled("editorconfig")
  use({
    "editorconfig/editorconfig-vim",
    disable = disabled_editorconfig,
  })

  -- Comments
  -- can be disabled to use your own comments plugin
  local disabled_kommentary = is_plugin_disabled("kommentary")
  use({
    "b3nj5m1n/kommentary",
    disable = disabled_kommentary,
    event = "BufWinEnter",
  })

  local disabled_contrib = is_plugin_disabled("contrib")
  -- Lua 5.1 docs
  use({
    "milisims/nvim-luaref",
    disable = disabled_contrib,
  })
  -- LibUV docs
  use({
    "nanotee/luv-vimdocs",
    disable = disabled_contrib,
  })

  -----[[-------------]]-----
  ---     Web Related     ---
  -----]]-------------[[-----
  -- Fastest colorizer without external dependencies!
  local disabled_colorizer = is_plugin_disabled("colorizer")
  use({
    "norcalli/nvim-colorizer.lua",
    config = require("doom.modules.config.doom-colorizer"),
    disable = disabled_colorizer,
    event = "ColorScheme",
  })

  -- HTTP Client support
  -- Depends on bayne/dot-http to work!
  local disabled_restclient = is_plugin_disabled("restclient")
  use({
    "NTBBloodbath/rest.nvim",
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
    disable = disabled_firenvim,
    run = function()
      vim.fn["firenvim#install"](0)
    end,
    config = require("doom.modules.config.doom-fire"),
  })

  local disabled_todo = is_plugin_disabled("todo_comments")
  use({
    "folke/todo-comments.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = require("doom.modules.config.doom-todo"),
    disable = disabled_todo,
    event = "ColorScheme",
  })

  local disabled_trouble = is_plugin_disabled("trouble")
  use({
    "folke/trouble.nvim",
    cmd = { "Trouble", "TroubleClose", "TroubleRefresh", "TroubleToggle" },
    requires = "kyazdani42/nvim-web-devicons",
    config = require("doom.modules.config.doom-trouble"),
    disable = disabled_trouble,
  })

  local disabled_superman = is_plugin_disabled("superman")
  use({
    "jez/vim-superman",
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
