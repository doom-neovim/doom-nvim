local themes = {}

themes.settings = {}

themes.packages = {
  -- https://github.com/folke/lsp-colors.nvim
  ["nightfox.nvim"] = { "EdenEast/nightfox.nvim" },
  ["nvim-transparent"] = { "xiyaowong/nvim-transparent" },
  ["vim-moonfly-colors"] = { "bluz71/vim-moonfly-colors" },
  ["vim-nightfly-guicolors"] = { "bluz71/vim-nightfly-guicolors" },
  ["github-nvim-theme"] = { "projekt0n/github-nvim-theme" },
  ["Catppuccino.nvim"] = { "Pocco81/Catppuccino.nvim" },
  ["sonokai"] = { "sainnhe/sonokai" },
  ["tokyonight.nvim"] = { "folke/tokyonight.nvim" },
  -- ray-x/aurora - A 24-bit dark theme with Tree-sitter and LSP support. TODO: <<<<<<< very nice!!!!!!!!!
  --   tjdevries/gruvbuddy.nvim - Gruvbox colors.
  -- ellisonleao/gruvbox.nvim - Gruvbox community colorscheme Lua port.
  -- metalelf0/jellybeans-nvim - A port of jellybeans colorscheme for Neovim.
  -- lalitmee/cobalt2.nvim - A port of cobalt2 colorscheme for Neovim using colorbuddy.
  -- https://github.com/vigoux/oak
  -- https://github.com/kvrohit/rasmus.nvim
  -- https://github.com/0xsamrath/kyoto.nvim
  -- https://github.com/hamzamemon/sunflower
  -- https://github.com/catppuccin/nvim
  -- shaeinst/roshnivim-cs - Colorscheme for Neovim written in Lua, specially made for roshnivim with Tree-sitter support.
  -- rafamadriz/neon - Customizable colorscheme with excellent italic and bold support, dark and light variants. Made to work and look good with Tree-sitter.
  -- tomasiser/vim-code-dark - A dark color scheme heavily inspired by the look of the Dark+ scheme of Visual Studio Code.
  -- Mofiqul/vscode.nvim - A Lua port of vim-code-dark colorscheme for Neovim with vscode light and dark theme.
  -- marko-cerovac/material.nvim - Material.nvim is a highly configurable colorscheme written in Lua and based on the material palette.
  -- bluz71/vim-nightfly-guicolors - Nightfly is a dark GUI color scheme heavily inspired by Sarah Drasner's Night Owl theme.
  -- bluz71/vim-moonfly-colors - Moonfly is a dark color scheme with Tree-sitter support.
  -- ChristianChiarulli/nvcode-color-schemes.vim - Nvcode, onedark, nord colorschemes with Tree-sitter support.
  -- folke/tokyonight.nvim - A clean, dark and light Neovim theme written in Lua, with support for LSP, Tree-sitter and lots of plugins.
  -- sainnhe/sonokai - High Contrast & Vivid Color Scheme based on Monokai Pro.
  -- kyazdani42/blue-moon - A dark color scheme for Neovim derived from palenight and carbonight.
  -- mhartington/oceanic-next - Oceanic Next theme for Neovim.
  -- glepnir/zephyr-nvim - A dark colorscheme with Tree-sitter support.
  -- rockerBOO/boo-colorscheme-nvim - A colorscheme for Neovim with handcrafted support for LSP, Tree-sitter.
  -- jim-at-jibba/ariake-vim-colors - A port of the great Atom theme. Dark and light with Tree-sitter support.
  -- Th3Whit3Wolf/onebuddy - Light and dark atom one theme.
  -- RishabhRD/nvim-rdark - A dark colorscheme for Neovim written in Lua.
  -- ishan9299/modus-theme-vim - This is a color scheme developed by Protesilaos Stavrou for emacs.
  -- sainnhe/edge - Clean & Elegant Color Scheme inspired by Atom One and Material.
  -- theniceboy/nvim-deus - Vim-deus with Tree-sitter support.
  -- bkegley/gloombuddy - Gloom inspired theme for Neovim.
  -- Th3Whit3Wolf/one-nvim - An Atom One inspired dark and light colorscheme for Neovim.
  -- PHSix/nvim-hybrid - A Neovim colorscheme write in Lua.
  -- Th3Whit3Wolf/space-nvim - A spacemacs inspired dark and light colorscheme for Neovim.
  -- yonlu/omni.vim - Omni color scheme for Vim.
  -- novakne/kosmikoa.nvim - Colorscheme for Neovim.
  -- tanvirtin/monokai.nvim - Monokai theme for Neovim written in Lua.
  -- nekonako/xresources-nvim - Neovim colorscheme based on your xresources color.
  -- savq/melange - Dark color scheme for Neovim and Vim 🗡️.
  -- RRethy/nvim-base16 - Neovim plugin for building base16 colorschemes. Includes support for Treesitter and LSP highlight groups.
  -- fenetikm/falcon - A colour scheme for terminals, Vim and friends.
  -- andersevenrud/nordic.nvim - A nord-esque colorscheme.
  -- shaunsingh/nord.nvim - Neovim theme based off of the Nord Color Palette.
  -- MordechaiHadad/nvim-papadark - My own Neovim colorscheme.
  -- ishan9299/nvim-solarized-lua - Solarized colorscheme in Lua for Neovim 0.5.
  -- shaunsingh/moonlight.nvim - Port of VSCode's Moonlight colorscheme for NeoVim, written in Lua with built-in support for native LSP, Tree-sitter and many more plugins.
  -- navarasu/onedark.nvim - A One Dark Theme for Neovim 0.5 written in Lua based on Atom's One Dark Theme.
  -- lourenci/github-colors - GitHub colors leveraging Tree-sitter to get 100% accuracy.
  -- sainnhe/gruvbox-material - Gruvbox modification with softer contrast and Tree-sitter support.
  -- sainnhe/everforest - A green based colorscheme designed to be warm, soft and easy on the eyes.
  -- NTBBloodbath/doom-one.nvim - Lua port of doom-emacs' doom-one for Neovim.
  -- dracula/vim - Famous beautiful dark powered theme.
  -- Mofiqul/dracula.nvim - Dracula colorscheme for neovim written in Lua.
  -- yashguptaz/calvera-dark.nvim - A port of VSCode Calvara Dark Theme to Neovim with Tree-sitter and many other plugins support.
  -- nxvu699134/vn-night.nvim - A dark Neovim colorscheme written in Lua. Support built-in LSP and Tree-sitter.
  -- adisen99/codeschool.nvim - Codeschool colorscheme for Neovim written in Lua with Tree-sitter and built-in lsp support.
  -- projekt0n/github-nvim-theme - A GitHub theme for Neovim, kitty, alacritty written in Lua. Support built-in LSP and Tree-sitter.
  -- kdheepak/monochrome.nvim - A 16 bit monochrome colorscheme that uses hsluv for perceptually distinct gray colors, with support for Tree-sitter and other commonly used plugins.
  -- rose-pine/neovim - All natural pine, faux fur and a bit of soho vibes for the classy minimalist.
  -- mcchrish/zenbones.nvim - A collection of vim/neovim colorschemes designed to highlight code using contrasts and font variations.
  -- catppuccin/nvim - Warm mid-tone dark theme to show off your vibrant self! with support for native LSP, Tree-sitter, and more 🍨!
  -- FrenzyExists/aquarium-vim - A dark, yet vibrant colorscheme for Neovim.
  -- EdenEast/nightfox.nvim - A soft dark, fully customizable Neovim theme, with support for lsp, treesitter and a variety of plugins.
  -- kvrohit/substrata.nvim - A cold, dark color scheme for Neovim written in Lua ported from arzg/vim-substrata theme.
  -- ldelossa/vimdark - A minimal Vim theme for night time. Loosely based on vim-monotonic and chrome's dark reader extention. A light theme is included as well for the day time.
  -- mangeshrex/uwu.vim - A beautiful and dark vim colorscheme written in vimscript.
  -- adisen99/apprentice.nvim - Colorscheme for Neovim written in Lua based on the Apprentice color pattete with Tree-sitter and built-in lsp support.
  -- olimorris/onedarkpro.nvim - One Dark Pro theme for Neovim, written in Lua and based on the VS Code theme. Includes dark and light themes with completely customisable colors, styles and highlights.
  -- rmehri01/onenord.nvim - A Neovim theme that combines the Nord and Atom One Dark color palettes for a more vibrant programming experience.
  -- RishabhRD/gruvy - Gruvbuddy without colorbuddy using Lush.
  -- minischeme - Color scheme of echasnovski/mini.nvim which is a variant of base16 with accent colors chosen according to optimal perceptual uniformity.
  -- luisiacc/gruvbox-baby - A modern gruvbox theme with full treesitter support.
  -- titanzero/zephyrium - A zephyr-esque theme, written in Lua, with TreeSitter support.
  -- rebelot/kanagawa.nvim - NeoVim dark colorscheme inspired by the colors of the famous painting by Katsushika Hokusai.
  -- tiagovla/tokyodark.nvim - A clean dark theme written in lua for neovim 0.5 and above.
  -- cpea2506/one_monokai.nvim - One Monokai theme for Neovim written in Lua.
}

themes.configs = {}
themes.configs["tokyonight.nvim"] = function()
  vim.g.material_style = "palenight"
  vim.g.material_italic_comments = 1
  vim.g.material_italic_keywords = 1
  vim.g.material_italic_functions = 1
  vim.g.material_lsp_underline = 1
  vim.g.sonokai_style = "atlantis"
  vim.g.sonokai_enable_italic = 1
  vim.g.sonokai_disable_italic_comment = 1
  vim.g.sonokai_diagnostic_virtual_text = "colored"
  vim.g.edge_style = "neon"
  vim.g.edge_enable_italic = 1
  vim.g.edge_disable_italic_comment = 0
  vim.g.edge_transparent_background = 0
  vim.g.embark_terminal_italics = 1
  vim.g.nightflyTransparent = 0
  vim.g.nvcode_termcolors = 256
  vim.o.background = "dark"
  vim.g.tokyonight_dev = false
  vim.g.tokyonight_style = "storm"
  vim.g.tokyonight_sidebars = {
    "qf",
    "vista_kind",
    "terminal",
    "packer",
    "spectre_panel",
    "NeogitStatus",
    "help",
  }
  vim.g.tokyonight_cterm_colors = false
  vim.g.tokyonight_terminal_colors = true
  vim.g.tokyonight_italic_comments = true
  vim.g.tokyonight_italic_keywords = true
  vim.g.tokyonight_italic_functions = false
  vim.g.tokyonight_italic_variables = false
  vim.g.tokyonight_transparent = true
  vim.g.tokyonight_hide_inactive_statusline = true
  vim.g.tokyonight_dark_sidebar = true
  vim.g.tokyonight_dark_float = true
  vim.g.tokyonight_colors = {}
  -- vim.g.tokyonight_colors = { border = "orange" }
  -- require("tokyonight").colorscheme()
  -- vim.cmd("colorscheme tokyonight") -- Put your favorite colorscheme here
end

themes.configs["nvim-transparent"] = function()
  require("transparent").setup({
    enable = false, -- boolean: enable transparent
    extra_groups = { -- table/string: additional groups that should be clear
      -- In particular, when you set it to 'all', that means all avaliable groups
      -- example of akinsho/nvim-bufferline.lua
      "BufferLineTabClose",
      "BufferlineBufferSelected",
      "BufferLineFill",
      "BufferLineBackground",
      "BufferLineSeparator",
      "BufferLineIndicatorSelected",
    },
    exclude = {}, -- table: groups you don't want to clear
  })
end

themes.configs["nightfox.nvim"] = function()
  local options = {
    dim_inactive = true,
  }
  local palette = {
    dawnfox = {
      bg2 = "#F9EFEC",
      bg3 = "#ECE3DE",
      sel1 = "#EEF1F1",
      sel2 = "#D8DDDD",
    },
  }
  local specs = {}
  local groups = {
    TelescopeNormal = { fg = "fg0", bg = "bg0" },
    TelescopePromptTitle = { fg = "pallet.green", bg = "bg1" },
    TelescopePromptBorder = { fg = "bg1", bg = "bg1" },
    TelescopePromptNormal = { fg = "fg1", bg = "bg1" },
    TelescopePromptPrefix = { fg = "fg1", bg = "bg1" },

    TelescopeResultsTitle = { fg = "pallet.green", bg = "bg2" },
    TelescopeResultsBorder = { fg = "bg2", bg = "bg2" },
    TelescopeResultsNormal = { fg = "fg1", bg = "bg2" },

    TelescopePreviewTitle = { fg = "pallet.green", bg = "bg1" },
    TelescopePreviewNormal = { bg = "bg1" },
    TelescopePreviewBorder = { fg = "bg1", bg = "bg1" },
    TelescopeMatching = { fg = "error" },
    CursorLine = { bg = "sel1", link = "" },
  }
  require("nightfox").setup({
    options = options,
    palette = palette,
    specs = specs,
    groups = groups,
  })
end

-- set my theme here
doom.colorscheme = "tokyonight"

return themes
