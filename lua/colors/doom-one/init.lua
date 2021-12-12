-- vim:fdm=marker
-- Vim Color File
-- Name:            doom-one
-- Maintainer:      https://github.com/NTBBloodbath
-- License:         The MIT License (MIT)
-- Based On:        https://github.com/romgrk/doom-one.vim and the original Doom Emacs one

-- Helpers {{{

local doom_one = {}

local utils = require("colors.utils")
local config = require("colors.doom-one.config")

-- }}}

local configuration = config.get()

--- Establish the user configurations
--- @param user_configs table
doom_one.setup = function(user_configs)
  configuration = config.set(user_configs or {})
  -- Reload colorscheme with user configurations override
  doom_one.load_colorscheme()
end

-- Customization variables {{{

local transparent_bg = configuration.transparent_background

if configuration.cursor_coloring then
  vim.opt.guicursor = "n-v-c:block-Cursor,i-ci-ve:ver25-Cursor,r-cr-o:hor25-Cursor"
end

if configuration.pumblend.enable then
  vim.opt.pumblend = configuration.pumblend.transparency_amount
end

-- }}}

-- Highlight Functions and Color definitions {{{

local function high_clear(group)
  vim.api.nvim_command("hi! clear " .. group)
end

local function high_link(group, link)
  vim.api.nvim_command("hi! link " .. group .. " " .. link)
end

local function highlight(group, styles)
  local bg = styles.bg and "guibg=" .. styles.bg or "guibg=NONE"
  local fg = styles.fg and "guifg=" .. styles.fg or "guifg=NONE"
  local sp = styles.sp and "guisp=" .. styles.sp or "guisp=NONE"
  local gui = styles.gui and "gui=" .. styles.gui or "gui=NONE"

  vim.api.nvim_command("hi! " .. group .. " " .. bg .. " " .. fg .. " " .. sp .. " " .. gui)
end

local function apply_highlight(groups)
  for group, styles in pairs(groups) do
    highlight(group, styles)
  end
end

-- Change the colorscheme colors depending on the current background, defaults to
-- doom-one dark variant colors
local current_bg = vim.opt.background:get()
local light_bg = false

local base0 = "#1B2229"
local base1 = "#1c1f24"
local base2 = "#202328"
local base3 = "#23272e"
local base4 = "#3f444a"
local base5 = "#5B6268"
local base6 = "#73797e"
local base7 = "#9ca0a4"
local base8 = "#DFDFDF"
local base9 = "#E6E6E6"

local grey = base4
local red = "#ff6c6b"
local orange = "#da8548"
local green = "#98be65"
local yellow = "#ECBE7B"
local blue = "#51afef"
local dark_blue = "#2257A0"
local magenta = "#c678dd"
local light_magenta = utils.Lighten(magenta, 0.4)
local violet = "#a9a1e1"
local dark_violet = "#4e4f67"
local cyan = "#46D9FF"
local white = "#efefef"

local bg = "#282c34"
local bg_alt = "#21242b"
local bg_highlight = "#21252a"
local bg_popup = "#3E4556"
local bg_statusline = bg_popup
local bg_highlighted = "#4A4A45"

local fg = "#bbc2cf"
local fg_alt = "#5B6268"
local fg_highlight = utils.Lighten(fg, 0.2)

local tag = utils.Mix(blue, cyan, 0.5)

local diff_info_fg = orange
local diff_info_bg0 = utils.Mix("#D8EEFD", bg, 0.6)
local diff_info_bg1 = utils.Mix("#D8EEFD", bg, 0.8)

local diff_add_fg = green
local diff_add_fg0 = utils.Mix(green, fg, 0.4)
local diff_add_bg0 = utils.Mix("#506d5b", bg, 0.6)
local diff_add_bg1 = utils.Mix("#acf2bd", bg, 0.8)

local ng_add_fg = "#799850"
local ng_add_fg_hl = green
local ng_add_bg = "#333a38"
local ng_add_bg_hl = "#3e493d"

local ng_delete_fg = "#cc5655"
local ng_delete_fg_hl = red
local ng_delete_bg = "#392d34"
local ng_delete_bg_hl = "#3f343a"

local ng_header_bg = dark_violet
local ng_header_bg_hl = violet

local gh_danger_fg = red
local gh_danger_fg0 = utils.Mix(red, fg, 0.6)
local gh_danger_bg0 = utils.Mix("#ffdce0", bg, 0.6)
local gh_danger_bg1 = utils.Mix("#ffdce0", bg, 0.8)

if current_bg == "light" then
  light_bg = true

  base0 = "#f0f0f0"
  base1 = "#e7e7e7"
  base2 = "#dfdfdf"
  base3 = "#c6c7c7"
  base4 = "#9ca0a4"
  base5 = "#383a42"
  base6 = "#202328"
  base7 = "#23272e"
  base8 = "#1c1f24"
  base9 = "#1B2229"

  grey = base4
  red = "#e45649"
  orange = "#da8548"
  green = "#50a14f"
  yellow = "#986801"
  blue = "#4078f2"
  dark_blue = "#a0bcf8"
  magenta = "#a626a4"
  light_magenta = utils.Darken(magenta, 0.36)
  violet = "#b751b6"
  dark_violet = "#e5c7e5"
  cyan = "#0184bc"
  white = "#efefef"

  bg = "#fafafa"
  bg_alt = "#f0f0f0"
  bg_highlight = utils.Darken(bg, 0.3)
  bg_popup = bg_alt
  bg_statusline = bg_popup

  fg = base5
  fg_alt = base3
  fg_highlight = utils.Lighten(fg, 0.2)

  tag = utils.Mix(blue, cyan, 0.5)

  diff_info_fg = orange
  diff_info_bg0 = utils.Mix("#D8EEFD", bg, 0.6)
  diff_info_bg1 = utils.Mix("#D8EEFD", bg, 0.8)

  diff_add_fg = green
  diff_add_fg0 = utils.Mix(green, fg, 0.4)
  diff_add_bg0 = utils.Mix("#506d5b", bg, 0.4)
  diff_add_bg1 = utils.Mix("#acf2bd", bg, 0.8)

  ng_add_fg = "#40803f"
  ng_add_fg_hl = green
  ng_add_bg = "#e9f1e8"
  ng_add_bg_hl = "#d8e8d7"

  ng_delete_fg = "#cc5655"
  ng_delete_fg_hl = red
  ng_delete_bg = "#f7e9e8"
  ng_delete_bg_hl = "#f5d9d6"

  ng_header_bg = dark_violet
  ng_header_bg_hl = violet

  gh_danger_fg = red
  gh_danger_fg0 = utils.Mix(red, fg, 0.6)
  gh_danger_bg0 = utils.Mix("#ffdce0", bg, 0.8)
  gh_danger_bg1 = utils.Mix("#ffdce0", bg, 0.9)
end

-- }}}

--- Load the colorscheme
doom_one.load_colorscheme = function()
  -- General UI {{{

  local general_ui = {
    Normal = { fg = fg, bg = transparent_bg and "NONE" or bg },
    NormalPopup = {
      fg = fg_highlight,
      bg = transparent_bg and "NONE" or bg_popup,
    },
    NormalPopover = {
      fg = fg_highlight,
      bg = transparent_bg and "NONE" or bg_popup,
    },
    NormalPopupPrompt = {
      fg = base7,
      bg = transparent_bg and "NONE" or utils.Darken(bg_popup, 0.3),
      gui = "bold",
    },
    NormalPopupSubtle = {
      fg = base6,
      bg = transparent_bg and "NONE" or bg_popup,
    },
    EndOfBuffer = { fg = bg, bg = transparent_bg and "NONE" or bg },

    Visual = { bg = dark_blue },
    VisualBold = { bg = dark_blue, gui = "bold" },

    LineNr = { fg = grey, bg = transparent_bg and "NONE" or bg },
    Cursor = { bg = blue },
    CursorLine = { bg = bg_highlight },
    CursorLineNr = { fg = fg, bg = bg_highlight },
    CursorColumn = { bg = bg_highlight },

    Folded = { fg = base5, bg = bg_highlight },
    FoldColumn = { fg = fg_alt, bg = bg },
    SignColumn = { bg = transparent_bg and "NONE" or bg },
    ColorColumn = { bg = bg_highlight },

    IndentGuide = { fg = grey },
    IndentGuideEven = { fg = grey },
    IndentGuideOdd = { fg = grey },

    TermCursor = { fg = fg, gui = "reverse" },
    TermCursorNC = { fg = fg_alt, gui = "reverse" },
    TermNormal = { fg = fg, bg = bg },
    TermNormalNC = { fg = fg, bg = bg },

    WildMenu = { fg = fg, bg = dark_blue },
    Separator = { fg = fg_alt },
    VertSplit = { fg = grey, bg = bg },

    TabLine = {
      fg = base7,
      bg = bg_alt,
      gui = "bold",
    },
    TabLineSel = { fg = blue, bg = bg, gui = "bold" },
    TabLineFill = { bg = base1, gui = "bold" },

    StatusLine = { fg = base8, bg = base3 },
    StatusLineNC = { fg = base6, bg = bg_popup },
    StatusLinePart = { fg = base6, bg = bg_popup, gui = "bold" },
    StatusLinePartNC = { fg = base6, bg = bg_popup, gui = "bold" },

    Pmenu = { fg = fg, bg = bg_highlight },
    PmenuSel = { fg = base0, bg = blue },
    PmenuSelBold = { fg = base0, bg = blue, gui = "bold" },
    PmenuSbar = { bg = bg_alt },
    PmenuThumb = { bg = fg },
  }

  if vim.opt.pumblend == 1 then
    vim.opt.pumblend = 20
  end

  apply_highlight(general_ui)

  -- }}}

  -- Search, Highlight. Conceal, Messages {{{

  local search_high_ui = {
    Search = { fg = fg, bg = dark_blue, gui = "bold" },
    Substitute = { fg = red, gui = "strikethrough,bold" },
    IncSearch = { fg = fg, bg = dark_blue, gui = "bold" },
    IncSearchCursor = { gui = "reverse" },

    Conceal = { fg = grey, gui = "none" },
    SpecialKey = { fg = violet, gui = "bold" },
    NonText = { fg = fg_alt, gui = "bold" },
    MatchParen = { fg = red, gui = "bold" },
    Whitespace = { fg = grey },

    Highlight = { bg = bg_highlighted },
    HighlightSubtle = { bg = bg_highlighted },
    LspHighlight = { bg = bg_highlight, style = "bold" },

    Question = { fg = green, gui = "bold" },

    File = { fg = fg },
    Directory = { fg = violet, gui = "bold" },
    Title = { fg = violet, gui = "bold" },

    Bold = { gui = "bold" },
    Emphasis = { fg = green, gui = "bold" },
  }

  apply_highlight(search_high_ui)

  -- }}}

  -- Text levels {{{

  local text_colors = {
    Normal = fg,
    Info = blue,
    Success = green,
    Warning = yellow,
    Debug = yellow,
    Error = red,
    Special = violet,
    Muted = base7,
  }

  for key, _ in pairs(text_colors) do
    apply_highlight({
      ["Text" .. key] = {
        fg = text_colors[key],
      },
    })
    apply_highlight({
      ["Text" .. key .. "Bold"] = {
        fg = text_colors[key],
        gui = "bold",
      },
    })
  end

  high_link("Msg", "TextSuccess")
  high_link("MoreMsg", "TextInfo")
  high_link("WarningMsg", "TextWarning")
  high_link("Error", "TextError")
  high_link("ErrorMsg", "TextError")
  high_link("ModeMsg", "TextSpecial")
  high_link("Todo", "TextWarningBold")

  -- }}}

  -- Main Syntax {{{

  local main_syntax = {
    Tag = { fg = tag, gui = "bold" },
    Link = { fg = green, gui = "underline" },
    URL = { fg = green, gui = "underline" },
    Underlined = { fg = tag, gui = "underline" },

    Comment = {
      fg = fg_alt,
      gui = configuration.italic_comments and "italic" or "NONE",
    },
    CommentBold = { fg = fg_alt, gui = "bold" },
    SpecialComment = { fg = base7, gui = "bold" },

    Macro = { fg = violet },
    Define = { fg = violet, gui = "bold" },
    Include = { fg = violet, gui = "bold" },
    PreProc = { fg = violet, gui = "bold" },
    PreCondit = { fg = violet, gui = "bold" },

    Label = { fg = light_bg and orange or blue },
    Repeat = { fg = light_bg and orange or blue },
    Keyword = { fg = light_bg and orange or blue },
    Operator = { fg = light_bg and orange or blue },
    Delimiter = { fg = light_bg and orange or blue },
    Statement = { fg = light_bg and orange or blue },
    Exception = { fg = light_bg and orange or blue },
    Conditional = { fg = light_bg and orange or blue },

    Variable = { fg = "#8B93E6" },
    VariableBuiltin = { fg = "#8B93E6", gui = "bold" },
    Constant = { fg = violet, gui = "bold" },

    Number = { fg = light_bg and yellow or orange },
    Float = { fg = light_bg and yellow or orange },
    Boolean = { fg = light_bg and yellow or orange, gui = "bold" },
    Enum = { fg = light_bg and yellow or orange },

    Character = { fg = violet, gui = "bold" },
    SpecialChar = { fg = base8, gui = "bold" },

    String = { fg = green },
    StringDelimiter = { fg = green },

    Special = { fg = violet },
    SpecialBold = { fg = violet, gui = "bold" },

    Field = { fg = violet },
    Argument = { fg = light_magenta },
    Attribute = { fg = light_magenta },
    Identifier = { fg = light_magenta },
    Property = { fg = magenta },
    Function = { fg = magenta },
    FunctionBuiltin = { fg = light_magenta, gui = "bold" },
    KeywordFunction = { fg = light_bg and orange or blue },
    Method = { fg = violet },

    Type = { fg = yellow },
    TypeBuiltin = { fg = yellow, gui = "bold" },
    StorageClass = { fg = light_bg and orange or blue },
    Class = { fg = light_bg and orange or blue },
    Structure = { fg = light_bg and orange or blue },
    Typedef = { fg = light_bg and orange or blue },

    Regexp = { fg = "#dd0093" },
    RegexpSpecial = { fg = "#a40073" },
    RegexpDelimiter = { fg = "#540063", gui = "bold" },
    RegexpKey = { fg = "#5f0041", gui = "bold" },
  }

  apply_highlight(main_syntax)
  high_link("CommentURL", "URL")
  high_link("CommentLabel", "CommentBold")
  high_link("CommentSection", "CommentBold")
  high_link("Noise", "Comment")

  -- }}}

  -- Diff {{{

  local diff = {
    diffLine = { fg = base8, bg = diff_info_bg1 },
    diffSubName = { fg = base8, bg = diff_info_bg1 },

    DiffAdd = { bg = diff_add_bg1 },
    DiffChange = { bg = diff_add_bg1 },
    DiffText = { bg = diff_add_bg0 },
    DiffDelete = { bg = gh_danger_bg0 },

    DiffAdded = { fg = diff_add_fg0, bg = diff_add_bg1 },
    DiffModified = { fg = fg, bg = diff_info_bg0 },
    DiffRemoved = { fg = gh_danger_fg0, bg = gh_danger_bg1 },

    DiffAddedGutter = { fg = diff_add_fg, gui = "bold" },
    DiffModifiedGutter = { fg = diff_info_fg, gui = "bold" },
    DiffRemovedGutter = { fg = gh_danger_fg, gui = "bold" },

    DiffAddedGutterLineNr = { fg = grey },
    DiffModifiedGutterLineNr = { fg = grey },
    DiffRemovedGutterLineNr = { fg = grey },
  }

  high_clear("DiffAdd")
  high_clear("DiffChange")
  high_clear("DiffText")
  high_clear("DiffDelete")
  apply_highlight(diff)

  -- }}}

  -- Markdown {{{
  local markdown = {
    markdownCode = { bg = bg_highlight },
    markdownCodeBlock = { bg = bg_highlight },
    markdownH1 = { gui = "bold" },
    markdownH2 = { gui = "bold" },
    markdownLinkText = { gui = "underline" },
  }

  apply_highlight(markdown)
  --}}}

  -- Plugins {{{

  -- netrw {{{
  local netrw = {
   netrwClassify = { fg = blue },
   netrwDir = { fg = blue },
   netrwExe = { fg = green },
   netrwMakefile = { fg = yellow },
  }

  apply_highlight(netrw)
  high_link("netrwTreeBar", "Comment")
  -- }}}

  -- barbar.nvim {{{

  if configuration.plugins_integrations.barbar then
    local barbar = {
      BufferCurrent = { fg = base9, bg = bg },
      BufferCurrentIndex = { fg = base6, bg = bg },
      BufferCurrentMod = { fg = yellow, bg = bg },
      BufferCurrentSign = { fg = blue, bg = bg },
      BufferCurrentTarget = { fg = red, bg = bg, gui = "bold" },

      BufferVisible = { fg = base7, bg = bg },
      BufferVisibleIndex = { fg = base9, bg = bg },
      BufferVisibleMod = { fg = yellow, bg = bg },
      BufferVisibleSign = { fg = base4, bg = bg },
      BufferVisibleTarget = { fg = red, bg = bg, gui = "bold" },

      BufferInactive = { fg = base6, bg = base1 },
      BufferInactiveIndex = { fg = base6, bg = base1 },
      BufferInactiveMod = { fg = yellow, bg = base1 },
      BufferInactiveSign = { fg = base4, bg = base1 },
      BufferInactiveTarget = { fg = red, bg = base1, gui = "bold" },

      BufferTabpages = { fg = blue, bg = bg_statusline, gui = "bold" },
      BufferTabpageFill = { fg = base4, bg = base1, gui = "bold" },

      BufferPart = { fg = diff_info_fg, bg = diff_info_bg0, gui = "bold" },
    }

    apply_highlight(barbar)
  end

  -- }}}

  -- BufferLine {{{

  if configuration.plugins_integrations.bufferline and transparent_bg then
    -- NOTE: this is a temporal workaround for using bufferline with a transparent
    --       background and having highlighting, please refer to
    --       https://github.com/NTBBloodbath/doom-one.nvim/issues/8#issuecomment-883737667
    --       for more information about this
    local bufferline = {
      BufferLineTab = { fg = fg, bg = bg },
      BufferLineTabClose = { fg = fg, bg = bg, gui = "bold" },
      BufferLineTabSelected = { fg = blue, bg = bg, gui = "bold,italic" },
      BufferLineBackground = { fg = fg_alt, bg = bg },
      BufferLineBufferSelected = { fg = fg, bg = bg, gui = "bold,italic" },
      BufferLineBufferVisible = { fg = fg, bg = bg },
      BufferLineCloseButton = { fg = fg_alt, bg = bg },
      BufferLineCloseButtonSelected = { fg = fg, bg = bg, gui = "bold" },
      BufferLineCloseButtonVisible = { fg = fg, bg = bg },
      BufferLineModified = { fg = green, bg = bg },
      BufferLineModifiedSelected = { fg = green, bg = bg },
      BufferLineModifiedVisible = { fg = green, bg = bg },
      BufferLineFill = { fg = blue, bg = bg_alt },
      BufferLineIndicatorSelected = { fg = blue, bg = bg },
      BufferLineSeparator = { fg = base0, bg = bg },
      BufferLineSeparatorSelected = { fg = base0, bg = bg },
      BufferLineSeparatorVisible = { fg = base0, bg = bg_alt },
      BufferLinePick = { fg = fg, bg = bg, gui = "bold" },
      BufferLinePickSelected = { fg = blue, bg = bg, gui = "bold,italic" },
      BufferLinePickVisible = { fg = fg, bg = bg_alt },

      BufferLineDiagnostic = { fg = fg, bg = bg, sp = fg },
      BufferLineDiagnosticSelected = { fg = fg, bg = bg, sp = fg },
      BufferLineDiagnosticVisible = { fg = fg, bg = bg, sp = fg },

      BufferLineInfo = { fg = cyan, bg = bg, sp = cyan, gui = "bold" },
      BufferLineInfoSelected = {
        fg = cyan,
        bg = bg,
        sp = cyan,
        gui = "bold,italic",
      },
      BufferLineInfoVisible = { fg = cyan, bg = bg, sp = cyan, gui = "bold" },
      BufferLineInfoDiagnostic = { fg = cyan, bg = bg, sp = cyan },
      BufferLineInfoDiagnosticSelected = { fg = cyan, bg = bg, sp = cyan },
      BufferLineInfoDiagnosticVisible = { fg = cyan, bg = bg, sp = cyan },
      BufferLineError = { fg = red, bg = bg, sp = red, gui = "bold" },
      BufferLineErrorSelected = {
        fg = red,
        bg = bg,
        sp = red,
        gui = "bold,italic",
      },
      BufferLineErrorVisible = { fg = red, bg = bg, sp = red, gui = "bold" },
      BufferLineErrorDiagnostic = { fg = red, bg = bg, sp = red },
      BufferLineErrorDiagnosticSelected = { fg = red, bg = bg, sp = red },
      BufferLineErrorDiagnosticVisible = { fg = red, bg = bg, sp = red },
      BufferLineWarning = {
        fg = yellow,
        bg = bg,
        sp = yellow,
        gui = "bold,italic",
      },
      BufferLineWarningSelected = {
        fg = yellow,
        bg = bg,
        sp = yellow,
        gui = "bold,italic",
      },
      BufferLineWarningVisible = {
        fg = yellow,
        bg = bg,
        sp = yellow,
        gui = "bold",
      },
      BufferLineWarningDiagnostic = { fg = yellow, bg = bg, sp = yellow },
      BufferLineWarningDiagnosticSelected = { fg = yellow, bg = bg, sp = yellow },
      BufferLineWarningDiagnosticVisible = { fg = yellow, bg = bg, sp = yellow },
    }

    apply_highlight(bufferline)
  end

  -- }}}

  -- Gitgutter {{{

  if configuration.plugins_integrations.gitgutter then
    high_link("GitGutterAdd", "DiffAddedGutter")
    high_link("GitGutterChange", "DiffModifiedGutter")
    high_link("GitGutterDelete", "DiffRemovedGutter")
    high_link("GitGutterChangeDelete", "DiffModifiedGutter")

    high_link("GitGutterAddLineNr", "DiffAddedGutterLineNr")
    high_link("GitGutterChangeLineNr", "DiffModifiedGutterLineNr")
    high_link("GitGutterDeleteLineNr", "DiffRemovedGutterLineNr")
    high_link("GitGutterChangeDeleteLineNr", "DiffModifiedGutterLineNr")
  end

  -- }}}

  -- Gitsigns {{{

  if configuration.plugins_integrations.gitsigns then
    high_link("GitSignsAdd", "DiffAddedGutter")
    high_link("GitSignsChange", "DiffModifiedGutter")
    high_link("GitSignsDelete", "DiffRemovedGutter")
    high_link("GitSignsChangeDelete", "DiffModifiedGutter")
  end

  -- }}}

  -- Telescope {{{

  if configuration.plugins_integrations.telescope then
    local telescope = {
      TelescopeSelection = { fg = yellow, gui = "bold" },
      TelescopeSelectionCaret = { fg = light_bg and orange or blue },
      TelescopeMultiSelection = { fg = grey },
      TelescopeNormal = { fg = fg },
      TelescopeMatching = { fg = green, gui = "bold" },
      TelescopePromptPrefix = { fg = light_bg and orange or blue },
      TelescopeBorder = { fg = light_bg and orange or blue },
      TelescopePromptBorder = { fg = light_bg and orange or blue },
      TelescopeResultsBorder = { fg = light_bg and orange or blue },
      TelescopePreviewBorder = { fg = light_bg and orange or blue },
    }

    apply_highlight(telescope)
    high_link("TelescopePrompt", "TelescopeNormal")
  end

  -- }}}

  -- Neogit {{{

  if configuration.plugins_integrations.neogit then
    local neogit = {
      NeogitDiffAdd = { fg = ng_add_fg, bg = ng_add_bg },
      NeogitDiffAddHighlight = { fg = ng_add_fg_hl, bg = ng_add_bg_hl, gui = "bold" },
      NeogitDiffDelete = { fg = ng_delete_fg, bg = ng_delete_bg },
      NeogitDiffDeleteHighlight = { fg = ng_delete_fg_hl, bg = ng_delete_bg_hl, gui = "bold" },
      NeogitDiffContext = { fg = fg_alt, bg = bg },
      NeogitDiffContextHighlight = { fg = fg, bg = bg_alt },
      NeogitHunkHeader = { fg = bg, bg = ng_header_bg },
      NeogitHunkHeaderHighlight = { fg = bg_alt, bg = ng_header_bg_hl, gui = "bold" },
      NeogitStagedChanges = { fg = blue, gui = "bold" },
      NeogitStagedChangesRegion = { bg = bg_highlight },
      NeogitStashes = { fg = blue, gui = "bold" },
      NeogitUnstagedChanges = { fg = blue, gui = "bold" },
      NeogitUntrackedfiles = { fg = blue, gui = "bold" },
    }

    apply_highlight(neogit)
  end

  -- }}}

  -- NvimTree {{{

  if configuration.plugins_integrations.nvim_tree then
    local nvim_tree = {
      NvimTreeFolderName = { fg = light_bg and base9 or blue, gui = "bold" },
      NvimTreeRootFolder = { fg = green },
      NvimTreeEmptyFolderName = { fg = fg_alt, gui = "bold" },
      NvimTreeSymlink = { fg = fg, gui = "underline" },
      NvimTreeExecFile = { fg = green, gui = "bold" },
      NvimTreeImageFile = { fg = light_bg and orange or blue },
      NvimTreeOpenedFile = { fg = fg_alt },
      NvimTreeSpecialFile = { fg = fg, gui = "underline" },
      NvimTreeMarkdownFile = { fg = fg, gui = "underline" },
    }

    apply_highlight(nvim_tree)
    high_link("NvimTreeGitDirty", "DiffModifiedGutter")
    high_link("NvimTreeGitStaged", "DiffModifiedGutter")
    high_link("NvimTreeGitMerge", "DiffModifiedGutter")
    high_link("NvimTreeGitRenamed", "DiffModifiedGutter")
    high_link("NvimTreeGitNew", "DiffAddedGutter")
    high_link("NvimTreeGitDeleted", "DiffRemovedGutter")

    high_link("NvimTreeIndentMarker", "IndentGuide")
    high_link("NvimTreeOpenedFolderName", "NvimTreeFolderName")
  end

  -- }}}

  -- Dashboard {{{

  if configuration.plugins_integrations.dashboard then
    local dashboard = {
      dashboardHeader = { fg = "#586268" },
      dashboardCenter = { fg = light_bg and orange or blue },
      dashboardShortcut = { fg = "#9788b9" },
    }

    apply_highlight(dashboard)
    high_link("dashboardFooter", "dashboardHeader")
  end

  -- }}}

  -- Startify {{{

  if configuration.plugins_integrations.startify then
    local startify = {
      StartifyHeader = { fg = bg_popup },
      StartifyBracket = { fg = bg_popup },
      StartifyNumber = { fg = blue },
      StartifyPath = { fg = violet },
      StartifySlash = { fg = violet },
      StartifyFile = { fg = green },
    }

    apply_highlight(startify)
  end

  -- }}}

  -- WhichKey {{{

  if configuration.plugins_integrations.whichkey then
    local whichkey = {
      WhichKey = { fg = light_bg and orange or blue },
      WhichKeyGroup = { fg = magenta },
      WhichKeyDesc = { fg = magenta },
      WhichKeySeparator = { fg = base5 },
      WhichKeyFloat = { bg = base2 },
      WhichKeyValue = { fg = grey },
    }

    apply_highlight(whichkey)
  end

  -- }}}

  -- indent-blankline {{{

  if configuration.plugins_integrations.indent_blankline then
    local indent_blankline = {
      IndentBlanklineChar = {
        fg = base4,
        cterm = "nocombine",
        gui = "nocombine",
      },
      IndentBlanklineContextChar = {
        fg = blue,
        cterm = "nocombine",
        gui = "nocombine",
      },
      IndentBlanklineSpaceChar = {
        fg = base4,
        cterm = "nocombine",
        gui = "nocombine",
      },
      IndentBlanklineSpaceCharBlankline = {
        fg = base4,
        cterm = "nocombine",
        gui = "nocombine",
      },
    }

    apply_highlight(indent_blankline)
  end

  -- }}}

  -- vim-illuminate {{{

  if configuration.plugins_integrations.vim_illuminate then
    local illuminated = {
      illuminatedWord = {
        cterm = "underline",
        gui = "underline",
      },
    }

    apply_highlight(illuminated)
  end

  -- }}}

  -- LspSaga {{{

  if configuration.plugins_integrations.lspsaga then
    local lspsaga = {
      SagaShadow = { bg = bg },
      LspSagaDiagnosticHeader = { fg = red },
    }

    apply_highlight(lspsaga)
    high_link("LspSagaDiagnosticBorder", "Normal")
    high_link("LspSagaDiagnosticTruncateLine", "Normal")
    high_link("LspFloatWinBorder", "Normal")
    high_link("LspSagaBorderTitle", "Title")
    high_link("TargetWord", "Error")
    high_link("ReferencesCount", "Title")
    high_link("ReferencesIcon", "Special")
    high_link("DefinitionCount", "Title")
    high_link("TargetFileName", "Comment")
    high_link("DefinitionIcon", "Special")
    high_link("ProviderTruncateLine", "Normal")
    high_link("LspSagaFinderSelection", "Search")
    high_link("DiagnosticTruncateLine", "Normal")
    high_link("DiagnosticError", "LspDiagnosticsDefaultError")
    high_link("DiagnosticWarn", "LspDiagnosticsDefaultWarning")
    high_link("DiagnosticInfo", "LspDiagnosticsDefaultInformation")
    high_link("DiagnosticHint", "LspDiagnosticsDefaultHint")
    high_link("DefinitionPreviewTitle", "Title")
    high_link("LspSagaShTruncateLine", "Normal")
    high_link("LspSagaDocTruncateLine", "Normal")
    high_link("LineDiagTuncateLine", "Normal")
    high_link("LspSagaCodeActionTitle", "Title")
    high_link("LspSagaCodeActionTruncateLine", "Normal")
    high_link("LspSagaCodeActionContent", "Normal")
    high_link("LspSagaRenamePromptPrefix", "Normal")
    high_link("LspSagaRenameBorder", "Bold")
    high_link("LspSagaHoverBorder", "Bold")
    high_link("LspSagaSignatureHelpBorder", "Bold")
    high_link("LspSagaCodeActionBorder", "Bold")
    high_link("LspSagaDefPreviewBorder", "Bold")
    high_link("LspLinesDiagBorder", "Bold")
  end

  -- }}}

  -- Neorg {{{

  if configuration.plugins_integrations.neorg then
    local neorg = {
      -- Colors are for nested quotes
      Blue = { fg = cyan },
      Yellow = { fg = yellow },
      Red = { fg = red },
      Green = { fg = green },
      Brown = { fg = orange },
    }

    apply_highlight(neorg)
  end

  -- }}}

  -- }}}

  -- LSP {{{

  local msg_underline = {
    ErrorMsgUnderline = { fg = red, gui = "underline" },
    WarningMsgUnderline = { fg = yellow, gui = "underline" },
    MoreMsgUnderline = { fg = blue, gui = "underline" },
    MsgUnderline = { fg = green, gui = "underline" },
  }

  apply_highlight(msg_underline)
  high_link("LspDiagnosticsFloatingError", "ErrorMsg")
  high_link("LspDiagnosticsFloatingWarning", "WarningMsg")
  high_link("LspDiagnosticsFloatingInformation", "MoreMsg")
  high_link("LspDiagnosticsFloatingHint", "Msg")
  high_link("LspDiagnosticsDefaultError", "ErrorMsg")
  high_link("LspDiagnosticsDefaultWarning", "WarningMsg")
  high_link("LspDiagnosticsDefaultInformation", "MoreMsg")
  high_link("LspDiagnosticsDefaultHint", "Msg")
  high_link("LspDiagnosticsVirtualTextError", "ErrorMsg")
  high_link("LspDiagnosticsVirtualTextWarning", "WarningMsg")
  high_link("LspDiagnosticsVirtualTextInformation", "MoreMsg")
  high_link("LspDiagnosticsVirtualTextHint", "Msg")
  high_link("LspDiagnosticsUnderlineError", "ErrorMsgUnderline")
  high_link("LspDiagnosticsUnderlineWarning", "WarningMsgUnderline")
  high_link("LspDiagnosticsUnderlineInformation", "MoreMsgUnderline")
  high_link("LspDiagnosticsUnderlineHint", "MsgUnderline")
  high_link("LspDiagnosticsSignError", "ErrorMsg")
  high_link("LspDiagnosticsSignWarning", "WarningMsg")
  high_link("LspDiagnosticsSignInformation", "MoreMsg")
  high_link("LspDiagnosticsSignHint", "Msg")
  high_link("DiagnosticFloatingError", "ErrorMsg")
  high_link("DiagnosticFloatingWarn", "WarningMsg")
  high_link("DiagnosticFloatingInfo", "MoreMsg")
  high_link("DiagnosticFloatingHint", "Msg")
  high_link("DiagnosticDefaultError", "ErrorMsg")
  high_link("DiagnosticDefaultWarn", "WarningMsg")
  high_link("DiagnosticDefaultInfo", "MoreMsg")
  high_link("DiagnosticDefaultHint", "Msg")
  high_link("DiagnosticVirtualTextError", "ErrorMsg")
  high_link("DiagnosticVirtualTextWarn", "WarningMsg")
  high_link("DiagnosticVirtualTextInfo", "MoreMsg")
  high_link("DiagnosticVirtualTextHint", "Msg")
  high_link("DiagnosticUnderlineError", "ErrorMsgUnderline")
  high_link("DiagnosticUnderlineWarn", "WarningMsgUnderline")
  high_link("DiagnosticUnderlineInfo", "MoreMsgUnderline")
  high_link("DiagnosticUnderlineHint", "MsgUnderline")
  high_link("DiagnosticSignError", "ErrorMsg")
  high_link("DiagnosticSignWarning", "WarningMsg")
  high_link("DiagnosticSignInformation", "MoreMsg")
  high_link("DiagnosticSignHint", "Msg")
  high_link("LspReferenceText", "LspHighlight")
  high_link("LspReferenceRead", "LspHighlight")
  high_link("LspReferenceWrite", "LspHighlight")
  high_link("TermCursor", "Cursor")
  high_link("healthError", "ErrorMsg")
  high_link("healthSuccess", "Msg")
  high_link("healthWarning", "WarningMsg")

  -- }}}

  -- TreeSitter {{{

  if configuration.enable_treesitter then
    -- We will set a special definition for TSStrike here
    local treesitter = {
      TSStrike = { fg = utils.Darken(violet, 0.2), cterm = "strikethrough", gui = "strikethrough" },
    }

    apply_highlight(treesitter)
    high_link("TSException", "Exception")
    high_link("TSAnnotation", "PreProc")
    high_link("TSAttribute", "Attribute")
    high_link("TSConditional", "Conditional")
    high_link("TSComment", "Comment")
    high_link("TSConstructor", "Structure")
    high_link("TSConstant", "Constant")
    high_link("TSConstBuiltin", "Constant")
    high_link("TSConstMacro", "Macro")
    high_link("TSError", "Error")
    high_link("TSField", "Field")
    high_link("TSFloat", "Float")
    high_link("TSFunction", "Function")
    high_link("TSFuncBuiltin", "FunctionBuiltin")
    high_link("TSFuncMacro", "Macro")
    high_link("TSInclude", "Include")
    high_link("TSKeyword", "Keyword")
    high_link("TSKeywordFunction", "KeywordFunction")
    high_link("TSLabel", "Label")
    high_link("TSMethod", "Method")
    high_link("TSNamespace", "Directory")
    high_link("TSNumber", "Number")
    high_link("TSOperator", "Operator")
    high_link("TSParameter", "Argument")
    high_link("TSParameterReference", "Argument")
    high_link("TSProperty", "Property")
    high_link("TSPunctDelimiter", "Delimiter")
    high_link("TSPunctBracket", "Delimiter")
    high_link("TSPunctSpecial", "Delimiter")
    high_link("TSRepeat", "Repeat")
    high_link("TSString", "String")
    high_link("TSStringRegex", "StringDelimiter")
    high_link("TSStringEscape", "StringDelimiter")
    high_link("TSTag", "Tag")
    high_link("TSTagDelimiter", "Delimiter")
    high_link("TSStrong", "Bold")
    high_link("TSURI", "URL")
    high_link("TSWarning", "WarningMsg")
    high_link("TSDanger", "ErrorMsg")
    high_link("TSType", "Type")
    high_link("TSTypeBuiltin", "TypeBuiltin")
    high_link("TSVariable", "None")
    high_link("TSVariableBuiltin", "VariableBuiltin")
  end

  -- }}}

  -- Neovim Terminal Colors {{{

  if configuration.terminal_colors then
    vim.g.terminal_color_0 = bg
    vim.g.terminal_color_1 = red
    vim.g.terminal_color_2 = green
    vim.g.terminal_color_3 = yellow
    vim.g.terminal_color_4 = blue
    vim.g.terminal_color_5 = violet
    vim.g.terminal_color_6 = cyan
    vim.g.terminal_color_7 = fg
    vim.g.terminal_color_8 = grey
    vim.g.terminal_color_9 = red
    vim.g.terminal_color_10 = green
    vim.g.terminal_color_11 = orange
    vim.g.terminal_color_12 = blue
    vim.g.terminal_color_13 = violet
    vim.g.terminal_color_14 = cyan
    vim.g.terminal_color_15 = white
    vim.g.terminal_color_background = bg_alt
    vim.g.terminal_color_foreground = fg_alt
  end

  -- }}}
end

return doom_one
