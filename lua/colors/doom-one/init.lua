-- vim:fdm=marker
-- Vim Color File
-- Name:       doom-one
-- Maintainer: http//github.com/NTBBloodbath
-- License:    The MIT License (MIT)
-- Based On:   http//github.com/romgrk/doom-one.vim and the original Doom Emacs one

-- Helpers {{{

require('colors.utils')

-- }}}

-- Customization variables {{{

-- Set default values for doom_one variables if they don't exists
if vim.g.doom_one_cursor_coloring == nil then
	vim.g.doom_one_cursor_coloring = false
end
if vim.g.doom_one_terminal_colors == nil then
	vim.g.doom_one_terminal_colors = false
end
if vim.g.doom_one_enable_treesitter == nil then
	vim.g.doom_one_enable_treesitter = true
end
if vim.g.doom_one_transparent_background == nil then
	vim.g.doom_one_transparent_background = false
end

local transparent_bg = vim.g.doom_one_transparent_background

-- }}}

-- Highlight Functions and Color definitions {{{

local function high_clear(group)
	vim.api.nvim_command('hi! clear ' .. group)
end

local function high_link(group, link)
	vim.api.nvim_command('hi! link ' .. group .. ' ' .. link)
end

local function highlight(group, styles)
	local bg = styles.bg and 'guibg=' .. styles.bg or 'guibg=NONE'
	local fg = styles.fg and 'guifg=' .. styles.fg or 'guifg=NONE'
	local sp = styles.sp and 'guisp=' .. styles.sp or 'guisp=NONE'
	local gui = styles.gui and 'gui=' .. styles.gui or 'gui=NONE'

	vim.api.nvim_command(
		'hi! ' .. group .. ' ' .. bg .. ' ' .. fg .. ' ' .. sp .. ' ' .. gui
	)
end

local function apply_highlight(groups)
	for group, styles in pairs(groups) do
		highlight(group, styles)
	end
end

local base0 = '#1B2229'
local base1 = '#1c1f24'
-- local base2 = '#202328'
-- local base3 = '#23272e'
local base4 = '#3f444a'
local base5 = '#5B6268'
local base6 = '#73797e'
local base7 = '#9ca0a4'
local base8 = '#DFDFDF'
local base9 = '#E6E6E6'

local grey = base4
local red = '#ff6c6b'
local orange = '#da8548'
local green = '#98be65'
local yellow = '#ECBE7B'
local blue = '#51afef'
local dark_blue = '#2257A0'
local magenta = '#c678dd'
local light_magenta = Lighten(magenta, 0.4)
local violet = '#a9a1e1'
local cyan = '#46D9FF'
local white = '#efefef'

local bg = '#282c34'
local bg_alt = '#21242b'
local bg_highlight = '#21252a'
local bg_popup = '#3E4556'
local bg_statusline = bg_popup
local bg_highlighted = '#4A4A45'

local fg = '#bbc2cf'
local fg_alt = '#5B6268'
local fg_highlight = Lighten(fg, 0.2)

local tag = Mix(blue, cyan, 0.5)

local diff_info_fg = blue
local diff_info_bg0 = Mix('#D8EEFD', bg, 0.6)
local diff_info_bg1 = Mix('#D8EEFD', bg, 0.8)

local diff_add_fg = green
local diff_add_fg0 = Mix(green, fg, 0.4)
local diff_add_bg0 = Mix('#506d5b', bg, 0.4)
-- local diff_add_bg1 = Mix('#acf2bd', bg, 0.6)
local diff_add_bg2 = Mix('#acf2bd', bg, 0.8)

local gh_danger_fg = red
local gh_danger_fg0 = Mix(red, fg, 0.6)
-- local gh_danger_bg0 = Mix('#ffdce0', bg, 0.6)
local gh_danger_bg1 = Mix('#ffdce0', bg, 0.8)
local gh_danger_bg2 = Mix('#ffdce0', bg, 0.9)

if vim.g.doom_one_cursor_coloring then
	vim.opt.guicursor =
		'n-v-c:block-Cursor,i-ci-ve:ver25-Cursor,r-cr-o:hor25-Cursor'
end

-- }}}

-- General UI {{{

local general_ui = {
	Normal = { fg = fg, bg = transparent_bg and 'NONE' or bg },
	NormalPopup = {
		fg = fg_highlight,
		bg = transparent_bg and 'NONE' or bg_popup,
	},
	NormalPopover = {
		fg = fg_highlight,
		bg = transparent_bg and 'NONE' or bg_popup,
	},
	NormalPopupPrompt = {
		fg = base7,
		bg = transparent_bg and 'NONE' or Darken(bg_popup, 0.3),
		gui = 'bold',
	},
	NormalPopupSubtle = { fg = base6, bg = transparent_bg and 'NONE' or bg_popup },
	EndOfBuffer = { fg = bg, bg = transparent_bg and 'NONE' or bg },

	Visual = { bg = dark_blue },
	VisualBold = { bg = dark_blue, gui = 'bold' },

	LineNr = { fg = grey, bg = transparent_bg and 'NONE' or bg },
	Cursor = { bg = blue },
	CursorLine = { bg = bg_highlight },
	CursorLineNr = { fg = fg, bg = bg_highlight },
	CursorColumn = { bg = bg_highlight },

	Folded = { fg = base7, bg = bg_highlight },
	FoldColumn = { fg = fg_alt, bg = bg },
	SignColumn = { bg = transparent_bg and 'NONE' or bg },
	ColorColumn = { bg = bg_highlight },

	IndentGuide = { fg = grey },
	IndentGuideEven = { fg = grey },
	IndentGuideOdd = { fg = grey },

	TermCursor = { fg = fg, gui = 'reverse' },
	TermCursorNC = { fg = fg_alt, gui = 'reverse' },
	TermNormal = { fg = fg, bg = bg },
	TermNormalNC = { fg = fg, bg = bg },

	WildMenu = { fg = fg, bg = dark_blue },
	Separator = { fg = fg_alt },
	VertSplit = { fg = grey, bg = bg },

	TabLine = {
		fg = base7,
		bg = transparent_bg and 'NONE' or bg_alt,
		gui = 'bold',
	},
	TabLineSel = { fg = blue, bg = bg, gui = 'bold' },
	TabLineFill = { bg = transparent_bg and 'NONE' or base1, gui = 'bold' },

	StatusLine = { fg = base8, bg = bg_popup },
	StatusLineNC = { fg = base6, bg = bg_popup },
	StatusLinePart = { fg = base6, bg = bg_popup, gui = 'bold' },
	StatusLinePartNC = { fg = base6, bg = bg_popup, gui = 'bold' },

	Pmenu = { fg = fg, bg = bg_popup },
	PmenuSel = { fg = base0, bg = blue },
	PmenuSelBold = { fg = base0, bg = blue, gui = 'bold' },
	PmenuSbar = { bg = bg_alt },
	PmenuThumb = { bg = fg },
}

if vim.fn.exists('&pumblend') == 1 then
	vim.cmd('set pumblend=20')
end

apply_highlight(general_ui)

-- }}}

-- Buffers {{{

local buffers_ui = {
	BufferCurrent = { fg = base9, bg = bg },
	BufferCurrentIndex = { fg = base6, bg = bg },
	BufferCurrentMod = { fg = yellow, bg = bg },
	BufferCurrentSign = { fg = blue, bg = bg },
	BufferCurrentTarget = { fg = red, bg = bg, gui = 'bold' },

	BufferVisible = { fg = base7, bg = bg },
	BufferVisibleIndex = { fg = base9, bg = bg },
	BufferVisibleMod = { fg = yellow, bg = bg },
	BufferVisibleSign = { fg = base4, bg = bg },
	BufferVisibleTarget = { fg = red, bg = bg, gui = 'bold' },

	BufferInactive = { fg = base6, bg = base1 },
	BufferInactiveIndex = { fg = base6, bg = base1 },
	BufferInactiveMod = { fg = yellow, bg = base1 },
	BufferInactiveSign = { fg = base4, bg = base1 },
	BufferInactiveTarget = { fg = red, bg = base1, gui = 'bold' },

	BufferTabpages = { fg = blue, bg = bg_statusline, gui = 'bold' },
	BufferTabpageFill = { fg = base4, bg = base1, gui = 'bold' },

	BufferPart = { fg = diff_info_fg, bg = diff_info_bg0, gui = 'bold' },
}

apply_highlight(buffers_ui)

-- }}}

-- Search, Highlight. Conceal, Messgaes {{{

local search_high_ui = {
	Search = { fg = fg, bg = dark_blue, gui = 'bold' },
	IncSearch = { fg = fg, bg = dark_blue, gui = 'bold' },
	IncSearchCursor = { gui = 'reverse' },

	Conceal = { fg = grey, gui = 'none' },
	SpecialKey = { fg = violet, gui = 'bold' },
	NonText = { fg = fg_alt, gui = 'bold' },
	MatchParen = { fg = red, gui = 'bold' },
	Whitespace = { fg = grey },

	Highlight = { bg = bg_highlighted },
	HighlightSubtle = { bg = bg_highlighted },

	Question = { fg = green, gui = 'bold' },

	File = { fg = fg },
	Directory = { fg = violet, gui = 'bold' },
	Title = { fg = violet, gui = 'bold' },

	Bold = { gui = 'bold' },
	Emphasis = { fg = green, gui = 'bold' },
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
		['Text' .. key] = {
			fg = text_colors[key],
		},
	})
	apply_highlight({
		['Text' .. key .. 'Bold'] = {
			fg = text_colors[key],
			gui = 'bold',
		},
	})
end

high_link('Msg', 'TextSuccess')
high_link('MoreMsg', 'TextInfo')
high_link('WarningMsg', 'TextWarning')
high_link('Error', 'TextError')
high_link('ErrorMsg', 'TextError')
high_link('ModeMsg', 'TextSpecial')
high_link('Todo', 'TextWarningBold')

-- }}}

-- Main Syntax {{{

local main_syntax = {
	Tag = { fg = tag, gui = 'bold' },
	Link = { fg = tag, sp = 'undercurl' },
	URL = { fg = tag, sp = 'undercurl' },
	Underlined = { fg = tag, sp = 'underline' },

	Comment = { fg = base5 },
	CommentBold = { fg = base5, gui = 'bold' },
	SpecialComment = { fg = base7, gui = 'bold' },

	Macro = { fg = violet },
	Define = { fg = violet, gui = 'bold' },
	Include = { fg = violet, gui = 'bold' },
	PreProc = { fg = violet, gui = 'bold' },
	PreCondit = { fg = violet, gui = 'bold' },

	Label = { fg = blue },
	Repeat = { fg = blue },
	Keyword = { fg = blue },
	Operator = { fg = blue },
	Delimiter = { fg = blue },
	Statement = { fg = blue },
	Exception = { fg = blue },
	Conditional = { fg = blue },

	Variable = { fg = '#8B93E6' },
	VariableBuiltin = { fg = '8B93E6', gui = 'bold' },
	Constant = { fg = violet, gui = 'bold' },

	Number = { fg = orange },
	Float = { fg = orange },
	Boolean = { fg = orange, gui = 'bold' },
	Enum = { fg = orange },

	Character = { fg = violet, gui = 'bold' },
	SpecialChar = { fg = base8, gui = 'bold' },

	String = { fg = green },
	StringDelimiter = { fg = green },

	Special = { fg = violet },
	SpecialBold = { fg = violet, gui = 'bold' },

	Field = { fg = violet },
	Argument = { fg = light_magenta },
	Attribute = { fg = light_magenta },
	Identifier = { fg = light_magenta },
	Property = { fg = orange },
	Function = { fg = magenta },
	FunctionBuiltin = { fg = light_magenta, gui = 'bold' },
	KeywordFunction = { fg = blue },
	Method = { fg = violet },

	Type = { fg = yellow },
	TypeBuiltin = { fg = yellow, gui = 'bold' },
	StorageClass = { fg = blue },
	Class = { fg = blue },
	Structure = { fg = blue },
	Typedef = { fg = blue },

	Regexp = { fg = '#dd0093' },
	RegexpSpecial = { fg = '#a40073' },
	RegexpDelimiter = { fg = '#540063', gui = 'bold' },
	RegexpKey = { fg = '#5f0041', gui = 'bold' },
}

apply_highlight(main_syntax)
high_link('CommentURL', 'URL')
high_link('CommentLabel', 'CommentBold')
high_link('CommentSection', 'CommentBold')
high_link('Noise', 'Comment')

-- }}}

-- Diff {{{

local diff = {
	diffLine = { fg = base8, bg = diff_info_bg1 },
	diffSubName = { fg = base8, bg = diff_info_bg1 },

	DiffAdd = { bg = diff_add_bg2 },
	DiffChange = { bg = diff_add_bg2 },
	DiffText = { bg = diff_add_bg0 },
	DiffDelete = { bg = gh_danger_bg1 },

	DiffAdded = { fg = diff_add_fg0, bg = diff_add_bg2 },
	DiffModified = { fg = fg, bg = diff_info_bg0 },
	DiffRemoved = { fg = gh_danger_fg0, bg = gh_danger_bg2 },

	DiffAddedGutter = { fg = diff_add_fg, gui = 'bold' },
	DiffModifiedGutter = { fg = diff_info_fg, gui = 'bold' },
	DiffRemovedGutter = { fg = gh_danger_fg, gui = 'bold' },

	DiffAddedGutterLineNr = { fg = grey },
	DiffModifiedGutterLineNr = { fg = grey },
	DiffRemovedGutterLineNr = { fg = grey },
}

high_clear('DiffAdd')
high_clear('DiffChange')
high_clear('DiffText')
high_clear('DiffDelete')
apply_highlight(diff)

-- }}}

-- Plugins {{{

-- Gitgutter {{{

high_link('GitGutterAdd', 'DiffAddedGutter')
high_link('GitGutterChange', 'DiffModifiedGutter')
high_link('GitGutterDelete', 'DiffRemovedGutter')
high_link('GitGutterChangeDelete', 'DiffModifiedGutter')

high_link('GitGutterAddLineNr', 'DiffAddedGutterLineNr')
high_link('GitGutterChangeLineNr', 'DiffModifiedGutterLineNr')
high_link('GitGutterDeleteLineNr', 'DiffRemovedGutterLineNr')
high_link('GitGutterChangeDeleteLineNr', 'DiffModifiedGutterLineNr')

-- }}}

-- Gitsigns {{{

high_link('GitSignsAdd', 'DiffAddedGutter')
high_link('GitSignsChange', 'DiffModifiedGutter')
high_link('GitSignsDelete', 'DiffRemovedGutter')
high_link('GitSignsChangeDelete', 'DiffModifiedGutter')

-- }}}

-- Telescope {{{

local telescope = {
	TelescopeSelection = { fg = yellow, gui = 'bold' },
	TelescopeSelectionCaret = { fg = blue },
	TelescopeMultiSelection = { fg = grey },
	TelescopeNormal = { fg = fg },
	TelescopeMatching = { fg = green, gui = 'bold' },
	TelescopePromptPrefix = { fg = blue },
	TelescopeBorder = { fg = blue },
	TelescopePromptBorder = { fg = blue },
	TelescopeResultsBorder = { fg = blue },
	TelescopePreviewBorder = { fg = blue },
}

apply_highlight(telescope)
high_link('TelescopePrompt', 'TelescopeNormal')

-- }}}

-- NvimTree {{{

local nvim_tree = {
	NvimTreeFolderName = { fg = blue, gui = 'bold' },
	NvimTreeRootFolder = { fg = green },
	NvimTreeEmptyFolderName = { fg = fg_alt, gui = 'bold' },
	NvimTreeSymlink = { fg = fg, sp = 'underline' },
	NvimTreeExecFile = { fg = green, gui = 'bold' },
	NvimTreeImageFile = { fg = blue },
	NvimTreeOpenedFile = { fg = fg_alt },
	NvimTreeSpecialFile = { fg = fg, sp = 'underline' },
	NvimTreeMarkdownFile = { fg = fg, sp = 'underline' },
}

apply_highlight(nvim_tree)
high_link('NvimTreeGitDirty', 'DiffModifiedGutter')
high_link('NvimTreeGitStaged', 'DiffModifiedGutter')
high_link('NvimTreeGitMerge', 'DiffModifiedGutter')
high_link('NvimTreeGitRenamed', 'DiffModifiedGutter')
high_link('NvimTreeGitNew', 'DiffAddedGutter')
high_link('NvimTreeGitDeleted', 'DiffRemovedGutter')

high_link('NvimTreeIndentMarker', 'IndentGuide')
high_link('NvimTreeOpenedFolderName', 'NvimTreeFolderName')

-- }}}

-- }}}

-- LSP {{{

local msg_underline = {
	ErrorMsgUnderline = { fg = red, sp = 'undercurl' },
	WarningMsgUnderline = { fg = yellow, sp = 'undercurl' },
	MoreMsgUnderline = { fg = blue, sp = 'undercurl' },
	MsgUnderline = { fg = green, sp = 'undercurl' },
}

apply_highlight(msg_underline)
high_link('LspDiagnosticsFloatingError', 'ErrorMsg')
high_link('LspDiagnosticsFloatingWarning', 'Warning')
high_link('LspDiagnosticsFloatingInformation', 'MoreMsg')
high_link('LspDiagnosticsFloatingHint', 'Msg')
high_link('LspDiagnosticsDefaultError', 'ErrorMsg')
high_link('LspDiagnosticsDefaultWarning', 'WarningMsg')
high_link('LspDiagnosticsDefaultInformation', 'MoreMsg')
high_link('LspDiagnosticsDefaultHint', 'Msg')
high_link('LspDiagnosticsVirtualTextError', 'ErrorMsg')
high_link('LspDiagnosticsVirtualTextWarning', 'WarningMsg')
high_link('LspDiagnosticsVirtualTextInformation', 'MoreMsg')
high_link('LspDiagnosticsVirtualTextHint', 'Msg')
high_link('LspDiagnosticsUnderlineError', 'ErrorMsgUnderline')
high_link('LspDiagnosticsUnderlineWarning', 'WarningMsgUnderline')
high_link('LspDiagnosticsUnderlineInformation', 'MoreMsgUnderline')
high_link('LspDiagnosticsUnderlineHint', 'MsgUnderline')
high_link('LspDiagnosticsSignError', 'ErrorMsg')
high_link('LspDiagnosticsSignWarning', 'WarningMsg')
high_link('LspDiagnosticsSignInformation', 'MoreMsg')
high_link('LspDiagnosticsSignHint', 'Msg')
high_link('LspReferenceText', 'Bold')
high_link('LspReferenceRead', 'Bold')
high_link('LspReferenceWrite', 'Bold')
high_link('TermCursor', 'Cursor')
high_link('healthError', 'ErrorMsg')
high_link('healthSuccess', 'Msg')
high_link('healthWarning', 'WarningMsg')

-- LspSaga {{{

local lspsaga = {
	SagaShadow = { bg = bg },
	LspSagaDiagnosticHeader = { fg = red },
}

apply_highlight(lspsaga)
high_link('LspSagaDiagnosticBorder', 'Normal')
high_link('LspSagaDiagnosticTruncateLine', 'Normal')
high_link('LspFloatWinBorder', 'Normal')
high_link('LspSagaBorderTitle', 'Title')
high_link('TargetWord', 'Error')
high_link('ReferencesCount', 'Title')
high_link('ReferencesIcon', 'Special')
high_link('DefinitionCount', 'Title')
high_link('TargetFileName', 'Comment')
high_link('DefinitionIcon', 'Special')
high_link('ProviderTruncateLine', 'Normal')
high_link('LspSagaFinderSelection', 'Search')
high_link('DiagnosticTruncateLine', 'Normal')
high_link('DiagnosticError', 'LspDiagnosticsDefaultError')
high_link('DiagnosticWarning', 'LspDiagnosticsDefaultWarning')
high_link('DiagnosticInformation', 'LspDiagnosticsDefaultInformation')
high_link('DiagnosticHint', 'LspDiagnosticsDefaultHint')
high_link('DefinitionPreviewTitle', 'Title')
high_link('LspSagaShTruncateLine', 'Normal')
high_link('LspSagaDocTruncateLine', 'Normal')
high_link('LineDiagTuncateLine', 'Normal')
high_link('LspSagaCodeActionTitle', 'Title')
high_link('LspSagaCodeActionTruncateLine', 'Normal')
high_link('LspSagaCodeActionContent', 'Normal')
high_link('LspSagaRenamePromptPrefix', 'Normal')
high_link('LspSagaRenameBorder', 'Bold')
high_link('LspSagaHoverBorder', 'Bold')
high_link('LspSagaSignatureHelpBorder', 'Bold')
high_link('LspSagaCodeActionBorder', 'Bold')
high_link('LspSagaDefPreviewBorder', 'Bold')
high_link('LspLinesDiagBorder', 'Bold')

-- }}}

-- }}}

-- TreeSitter {{{

if vim.g.doom_one_enable_treesitter then
	high_link('TSException', 'Exception')
	high_link('TSAnnotation', 'PreProc')
	high_link('TSAttribute', 'Attribute')
	high_link('TSConditional', 'Conditional')
	high_link('TSComment', 'Comment')
	high_link('TSConstructor', 'Structure')
	high_link('TSConstant', 'Constant')
	high_link('TSConstBuiltin', 'Constant')
	high_link('TSConstMacro', 'Macro')
	high_link('TSError', 'Error')
	high_link('TSField', 'Field')
	high_link('TSFloat', 'Float')
	high_link('TSFunction', 'Function')
	high_link('TSFuncBuiltin', 'FunctionBuiltin')
	high_link('TSFuncMacro', 'Macro')
	high_link('TSInclude', 'Include')
	high_link('TSKeyword', 'Keyword')
	high_link('TSKeywordFunction', 'KeywordFunction')
	high_link('TSLabel', 'Label')
	high_link('TSMethod', 'Method')
	high_link('TSNamespace', 'Directory')
	high_link('TSNumber', 'Number')
	high_link('TSOperator', 'Operator')
	high_link('TSParameter', 'Argument')
	high_link('TSParameterReference', 'Argument')
	high_link('TSProperty', 'Property')
	high_link('TSPunctDelimiter', 'Delimiter')
	high_link('TSPunctBracket', 'Delimiter')
	high_link('TSPunctSpecial', 'Delimiter')
	high_link('TSRepeat', 'Repeat')
	high_link('TSString', 'String')
	high_link('TSStringRegex', 'StringDelimiter')
	high_link('TSStringEscape', 'StringDelimiter')
	high_link('TSTag', 'Tag')
	high_link('TSTagDelimiter', 'Delimiter')
	high_link('TSStrong', 'Bold')
	high_link('TSURI', 'URL')
	high_link('TSWarning', 'Warning')
	high_link('TSDanger', 'Error')
	high_link('TSType', 'Type')
	high_link('TSTypeBuiltin', 'TypeBuiltin')
	high_link('TSVariable', 'Variable')
	high_link('TSVariableBuiltin', 'VariableBuiltin')
end

-- }}}

-- Neovim Terminal Colors {{{

if vim.g.doom_one_terminal_colors then
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
