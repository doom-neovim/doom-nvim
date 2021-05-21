" !::exe [So]

" Load lua color utilities
lua require('color')

if &background != 'dark'
  set background=dark
end

let colors_name = 'doom-one'

" Highlighting function {{{
function! s:_ (name, ...)
  let fg = ''
  let bg = ''
  let attr = ''

  if type(a:1) == 3
    let fg   = get(a:1, 0, '')
    let bg   = get(a:1, 1, '')
    let attr = get(a:1, 2, '')
  else
    let fg   = get(a:000, 0, '')
    let bg   = get(a:000, 1, '')
    let attr = get(a:000, 2, '')
  end

  let has_props = v:false

  let cmd = 'hi! ' . a:name
  if !empty(fg) && fg != 'none'
    let cmd .= ' guifg=' . fg
    let has_props = v:true
  end
  if !empty(bg) && bg != 'none'
    let cmd .= ' guibg=' . bg
    let has_props = v:true
  end
  if !empty(attr) && attr != 'none'
    let cmd .= ' gui=' . attr
    let has_props = v:true
  end
  execute 'hi! clear ' a:name
  if has_props
    execute cmd
  end
endfunc

" }}}
" Colors                                                                     {{{

let s:base0      = '#1B2229'
let s:base1      = '#1c1f24'
let s:base2      = '#202328'
let s:base3      = '#23272e'
let s:base4      = '#3f444a'
let s:base5      = '#5B6268'
let s:base6      = '#73797e'
let s:base7      = '#9ca0a4'
let s:base8      = '#DFDFDF'
let s:base9      = '#E6E6E6'

let s:grey       = s:base4
let s:red        = '#ff6c6b'
let s:orange     = '#da8548'
let s:green      = '#98be65'
let s:teal       = '#4db5bd'
let s:yellow     = '#ECBE7B'
let s:blue       = '#51afef'
let s:dark_blue  = '#2257A0'
let s:magenta    = '#c678dd'
let s:violet     = '#a9a1e1'
let s:cyan       = '#46D9FF'
let s:dark_cyan  = '#5699AF'
let s:white      = '#efefef'

let s:green_alt  = '#799033'

let s:bg             = '#282c34'
let s:bg_alt         = '#21242b'
let s:bg_highlight   = '#21252a'
let s:bg_popup       = '#3E4556'
let s:bg_widget      = s:bg
let s:bg_statusline  = s:bg_popup
let s:bg_visual      = s:dark_blue
let s:bg_selection   = s:dark_blue
let s:bg_highlighted = '#4A4A45'

let s:fg           = '#bbc2cf'
let s:fg_alt       = '#5B6268'
let s:fg_widget    = s:fg
let s:fg_conceal   = s:base4
let s:fg_subtle    = s:base7
let s:fg_highlight = luaeval('Lighten("#' . s:fg . '", 0.2)')
let s:fg_linenr    = s:base4


let s:highlight       = s:blue
let s:highlight_color = s:base0

let s:tag    = luaeval('Mix("#' . s:blue . '", "#' . s:cyan . '")')

let s:diff_info_fg  = s:blue
let s:diff_info_bg0 = luaeval('Mix("#D8EEFD", "#' . s:bg . '", 0.6)')
let s:diff_info_bg1 = luaeval('Mix("#D8EEFD", "#' . s:bg . '", 0.8)')

let s:diff_add_fg  = s:green
let s:diff_add_fg0 = luaeval('Mix("#' . s:green . '",   "#' . s:fg . '", 0.4)')
let s:diff_add_bg0 = luaeval('Mix("#506d5b", "#' . s:bg . '", 0.4)')
let s:diff_add_bg1 = luaeval('Mix("#acf2bd", "#' . s:bg . '", 0.6)')
let s:diff_add_bg2 = luaeval('Mix("#acf2bd", "#' . s:bg . '", 0.8)')

let s:gh_danger_fg  = s:red
let s:gh_danger_fg0 = luaeval('Mix("#' . s:red . '",     "#' . s:fg . '", 0.6)')
let s:gh_danger_bg0 = luaeval('Mix("#ffdce0", "#' . s:bg . '", 0.6)')
let s:gh_danger_bg1 = luaeval('Mix("#ffdce0", "#' . s:bg . '", 0.8)')
let s:gh_danger_bg2 = luaeval('Mix("#ffdce0", "#' . s:bg . '", 0.9)')

" }}}
" General UI                                                                 {{{

call s:_('Normal',            s:fg,           s:bg)
call s:_('EndOfBuffer',       s:bg,           s:bg)
call s:_('NormalPopup',       s:fg_highlight, s:bg_popup)
call s:_('NormalPopover',     s:fg_highlight, s:bg_popup)
call s:_('NormalPopupPrompt', s:base7,        luaeval('Darken("#' . s:bg_popup . '", 0.3)'), 'bold')
call s:_('NormalPopupSubtle', s:base6,        s:bg_popup)

call s:_('Cursor',           '', s:highlight)
call s:_('SecondaryCursor',  '', s:highlight, 'none')

call s:_('Folded',           s:base7,  s:bg_highlight, 'none')
call s:_('FoldColumn',       s:fg_alt, s:bg_widget, '')
call s:_('SignColumn',       '',       s:bg_widget, '')
call s:_('ColorColumn',      '',       s:bg_highlight, '')

call s:_('CursorLine',       '',          s:bg_highlight)
call s:_('CursorColumn',     '',          s:bg_highlight)
call s:_('CursorLineNr',     s:fg,        s:bg_highlight, 'none')
call s:_('LineNr',           s:fg_linenr, s:bg_widget,    'none')

call s:_('IndentGuide',      s:base4, '', '')
call s:_('IndentGuidesEven', s:base4, '', '')
call s:_('IndentGuidesOdd',  s:base4, '', '')

call s:_('TermCursor',       s:fg,        'none',            'reverse')
call s:_('TermCursorNC',     s:fg_alt,    'none',            'reverse')
call s:_('TermNormal',       s:fg,        s:bg,    '')
hi! link TermNormalNC TermNormal


call s:_('Visual',         '', s:bg_visual)
call s:_('VisualBold',     '', s:bg_visual, 'bold')

call s:_('WildMenu',       s:fg,            s:bg_selection)

call s:_('StatusLine',       s:base8,  s:bg_statusline, 'none')
call s:_('StatusLineNC',     s:base6,  s:bg_statusline, 'none')
call s:_('StatusLinePart',   s:base6,  s:bg_statusline, 'bold')
call s:_('StatusLinePartNC', s:base6,  s:bg_statusline, 'bold')

call s:_('Separator', s:fg_alt, 'none')
call s:_('VertSplit', s:base4,   s:bg, 'none')

call s:_('Pmenu',        s:fg,              s:bg_popup)
call s:_('PmenuSel',     s:highlight_color, s:highlight)
call s:_('PmenuSelBold', s:highlight_color, s:highlight, 'bold')
call s:_('PmenuSbar',    '',                s:bg_alt)
call s:_('PmenuThumb',   '#666660',         '#666660')

if exists('&pumblend')
  set pumblend=20
end

let s:bg_current = s:bg
let s:bg_visible = s:bg
let s:bg_other   = s:base1

call s:_('TabLine',             s:base7, s:bg_alt,  'bold')
call s:_('TabLineSel',          s:blue,  s:bg_current, 'bold')
call s:_('TabLineFill',         'none',  s:bg_other,   'bold')

call s:_('BufferCurrent',       s:base9,          s:bg_current,  'none')
call s:_('BufferCurrentIndex',  s:base6,          s:bg_current,  'none')
call s:_('BufferCurrentMod',    s:yellow,         s:bg_current,  'none')
call s:_('BufferCurrentSign',   s:blue,           s:bg_current,  'none')
call s:_('BufferCurrentTarget', s:red,            s:bg_current,  'bold')

call s:_('BufferVisible',       s:base7,          s:bg_visible,  'none')
call s:_('BufferVisibleIndex',  s:base9,          s:bg_visible,  'none')
call s:_('BufferVisibleMod',    s:yellow,         s:bg_visible,  'none')
call s:_('BufferVisibleSign',   s:base4,          s:bg_visible,  'none')
call s:_('BufferVisibleTarget', s:red,            s:bg_visible,  'bold')

call s:_('BufferInactive',       s:base6,          s:bg_other,    'none')
call s:_('BufferInactiveIndex',  s:base6,          s:bg_other,    'none')
call s:_('BufferInactiveMod',    s:yellow,         s:bg_other,    'none')
call s:_('BufferInactiveSign',   s:base4,          s:bg_other,    'none')
call s:_('BufferInactiveTarget', s:red,            s:bg_other,    'bold')

call s:_('BufferTabpages',       s:blue,           s:bg_statusline, 'bold')
call s:_('BufferTabpageFill',    s:base4,          s:bg_other,    'bold')

call s:_('BufferPart',        s:diff_info_fg,   s:diff_info_bg0, 'bold')

" }}}
" Search, Highlight, Conceal, Messages                                       {{{

" let s:bg_search = color#Mix(s:bg, s:yellow, 0.2)
let s:bg_search = s:dark_blue

call s:_('Search',          s:fg, s:bg_search,      'bold')
call s:_('IncSearch',       s:fg, s:bg_search,      'bold')
call s:_('IncSearchCursor', '', '',               'reverse')

call s:_('Conceal',         s:fg_conceal, 'none', '')
call s:_('SpecialKey',      s:violet,     'none', 'bold')
call s:_('NonText',         s:fg_alt,     '',     'bold')
call s:_('MatchParen',      s:red,        'none', 'bold')
call s:_('Whitespace',      s:base4,      '',     '')


call s:_('Highlight',       '', s:bg_highlighted, 'none')
call s:_('HighlightSubtle', '', s:bg_highlighted, 'none')

call s:_('Question',        s:green, '', 'bold')

call s:_('File',            s:fg,      '', 'bold')
call s:_('Directory',       s:blue,  '', 'bold')
call s:_('Section',         s:magenta, '', 'bold')
call s:_('Title',           s:violet,  '', 'bold')

call s:_('Bold', '', '', 'bold')
call s:_('Emphasis', s:green, '', 'bold')

" Text levels                                                                {{{

let s:text_colors = {
      \ 'Normal':  s:fg,
      \ 'Info':    s:blue,
      \ 'Success': s:green,
      \ 'Warning': s:yellow,
      \ 'Debug':   s:yellow,
      \ 'Error':   s:red,
      \ 'Special': s:violet,
      \ 'Muted':   s:base7,
      \ }
for key in keys(s:text_colors)
  call s:_('Text' . key,          s:text_colors[key], '', '')
  call s:_('Text' . key . 'Bold', s:text_colors[key], '', 'bold')
endfor

" NOTE/DONE/TODO/FIXME/XXX/DEPRECATED comment highlights

" }}}

hi! link Msg        TextSuccess
hi! link MoreMsg    TextInfo
hi! link WarningMsg TextWarning
hi! link ErrorMsg   TextError
hi! link Error      TextError
hi! link ModeMsg    TextSpecial
hi! link Todo       TextWarningBold


" }}}
" Main Syntax                                                               {{{1

call s:_('Tag',                  s:tag, '',        'underline')
call s:_('Link',                 s:tag, '',        'underline')
call s:_('URL',                  s:tag, '',        'underline')
hi! link Underlined     URL

call s:_('Comment',              s:base6, '',        '')
call s:_('CommentBold',          s:base6, '',        'bold')
call s:_('SpecialComment',       s:base7, '',        'bold')
hi! link CommentURL     URL
hi! link CommentLabel   CommentBold
hi! link CommentSection CommentBold
hi! link Noise Comment

call s:_('Global',               s:violet, '',         'bold')
call s:_('PreProc',              s:magenta, '',        'none')
call s:_('Macro',                s:magenta, '',        'bold')
call s:_('Define',               s:magenta, '',        'bold')
call s:_('PreCondit',            s:magenta, '',        'bold')
call s:_('Include',              s:magenta, '',        'bold')

call s:_('Repeat',               s:blue, '',        '')
call s:_('Keyword',              s:blue, '',        '')
call s:_('Statement',            s:blue, '',        'none')
call s:_('Conditional',          s:blue, '',        '')
call s:_('Exception',            s:blue, '',        '')
call s:_('Label',                s:blue, '',        '')

call s:_('Operator',             s:blue, '',        '')

call s:_('Constant',             s:violet, '',        'bold')
call s:_('ConstantBuiltin',      s:magenta, '',       'bold')

call s:_('Number',               s:orange, '',        'none')
call s:_('Float',                s:orange, '',        'none')
call s:_('Boolean',              s:orange, '',        'none')
call s:_('Enum',                 s:orange, '',        'none')

call s:_('Delimiter',            s:blue,  '',        'none')
call s:_('DelimiterAlt',         s:green_alt, '',    'none')
call s:_('SpecialChar',          s:base8, '',        'bold')

call s:_('String',               s:green, '',        'none')
call s:_('StringDelimiter',      s:green, '',        'none')

call s:_('Character',            s:green, '',        'bold')


call s:_('Special',              s:violet, '',        'none')
call s:_('SpecialBold',          s:violet, '',        'bold')


call s:_('Identifier',           luaeval('Lighten("#' . s:magenta . '", 0.4)'), '',        'none')
call s:_('Argument',             luaeval('Lighten("#' . s:magenta . '", 0.4)'), '',        'none')
call s:_('Variable',             luaeval('Lighten("#' . s:magenta . '", 0.4)'), '',        'none')
call s:_('Variable',             luaeval('Lighten("#' . s:magenta . '", 0.4)'), '',        'none')

call s:_('Function',             s:magenta, '',        'none')
call s:_('FunctionBuiltin',      s:orange,  '',        'bold')
call s:_('Method',               s:cyan,    '',        'none')

call s:_('Symbol',               s:magenta, '',        'none')
call s:_('Control',              s:magenta, '',        'none')
call s:_('PredefinedIdentifier', s:magenta, '',        'none')
call s:_('Predefined',           s:magenta, '',        'none')

call s:_('StaticFunc',           s:cyan, '',        'none')
call s:_('Property',             s:magenta, '',     'none')


call s:_('Type',                 s:yellow, '',      'none')
call s:_('TypeBuiltin',          s:yellow, '',      'bold')
call s:_('StorageClass',         s:blue, '',        'none')
call s:_('Class',                s:blue, '',        'none')
call s:_('Structure',            s:blue, '',        'none')
call s:_('Typedef',              s:blue, '',        'none')

call s:_('Regexp',               '#dd0093', 'none',        'none')
call s:_('RegexpSpecial',        '#a40073', 'none',        'none')
call s:_('RegexpDelimiter',      '#540063', 'none',        'bold')
call s:_('RegexpKey',            '#5f0041', 'none',        'bold')

" }}}
" Diff                                                                       {{{

call s:_('diffLine',    s:base8, s:diff_info_bg1, 'none')
call s:_('diffSubName', s:base8, s:diff_info_bg1, 'none')

hi! clear DiffAdd
hi! clear DiffChange
hi! clear DiffText
hi! clear DiffDelete

call s:_('DiffAdd',      '',             s:diff_add_bg2, 'none')
call s:_('DiffChange',   '',             s:diff_add_bg2, 'none')
call s:_('DiffText',     '',             s:diff_add_bg0, 'none')
call s:_('DiffDelete',   '',             s:gh_danger_bg1, 'none')

call s:_('DiffAdded',    s:diff_add_fg0,  s:diff_add_bg2,  'none')
call s:_('DiffModified', s:fg,            s:diff_info_bg0, 'none')
call s:_('DiffRemoved',  s:gh_danger_fg0, s:gh_danger_bg2, 'none')

call s:_('DiffAddedGutter',          s:diff_add_fg,  'none', 'bold')
call s:_('DiffModifiedGutter',       s:diff_info_fg, 'none', 'bold')
call s:_('DiffRemovedGutter',        s:gh_danger_fg, 'none', 'bold')

call s:_('DiffAddedGutterLineNr',    s:fg_linenr, 'none', 'none')
call s:_('DiffModifiedGutterLineNr', s:fg_linenr, 'none', 'none')
call s:_('DiffRemovedGutterLineNr',  s:fg_linenr, 'none', 'none')

" Gitgutter
hi! link GitGutterAdd                DiffAddedGutter
hi! link GitGutterChange             DiffModifiedGutter
hi! link GitGutterChangeDelete       DiffModifiedGutter
hi! link GitGutterDelete             DiffRemovedGutter

hi! link GitGutterAddLineNr          DiffAddedGutterLineNr
hi! link GitGutterChangeLineNr       DiffModifiedGutterLineNr
hi! link GitGutterChangeDeleteLineNr DiffModifiedGutterLineNr
hi! link GitGutterDeleteLineNr       DiffRemovedGutterLineNr

" Gitsigns
hi! link GitSignsAdd          DiffAddedGutter
hi! link GitSignsChange       DiffModifiedGutter
hi! link GitSignsDelete       DiffRemovedGutter
hi! link GitSignsChangeDelete DiffModifiedGutter

"                                                                            }}}
" Additionnal/Common groups                                         {{{1

call s:_('DbgCurrent',           '#DEEBFE', '#345FA8', '')
call s:_('DbgBreakPt',           '',        '#4F0037', '')

" Jumping around {{{

call s:_('JumpTarget', s:red, '', 'bold')

hi!  link EasyMotionTargetDefault JumpTarget
hi!  link Sneak                   JumpTarget
hi!  link SneakPluginTarget       JumpTarget
hi!  link SneakStreakTarget       JumpTarget
hi!  link SneakStreakMask         EasyMotionShadeDefault

" }}}

" Other plugins                                                       {{{1

" Telescope
call s:_('TelescopeMatching',     s:green, 'none', 'bold')
call s:_('TelescopeBorder',       s:grey)
call s:_('TelescopePromptPrefix', s:blue)
hi! link TelescopeSelection Search
" }}}

" Languages/Others                                                    {{{1
" Help                                                                      {{{2
hi! link helpURL           URL

" PHP                                                                       {{{2
hi! link phpFunctions   Function
hi! link phpSuperglobal Identifier
hi! link phpQuoteSingle StringDelimiter
hi! link phpQuoteDouble StringDelimiter
hi! link phpBoolean     Constant
hi! link phpNull        Constant
hi! link phpArrayPair   Operator
hi! link phpOperator    Normal
hi! link phpRelation    Normal
hi! link phpVarSelector Identifier

" Python                                                                    {{{2
hi! link pythonOperator Operator

" Ruby                                                                      {{{2
hi! link rubyRegexpDelimiter       RegexpDelimiter
hi! link rubyRegexp                Regexp
hi! link rubyRegexpSpecial         RegexpSpecial
hi! link rubyPredefinedIdentifier  PredefinedIdentifier

hi! link rubyClass              Class
hi! link rubyIdentifier         Identifier
hi! link rubyInstanceVariable   InstanceVariable
hi! link rubySymbol             Symbol
hi! link rubyControl            Control

hi! link rubySharpBang Comment
hi! link rubyConstant  Type
hi! link rubyFunction  Function

hi! link rubyGlobalVariable rubyInstanceVariable
hi! link rubyModule         rubyClass

hi! link rubyString                 String
hi! link rubyStringDelimiter        StringDelimiter
hi! link rubyInterpolationDelimiter Identifier

" Erlang                                                                    {{{2
hi! link erlangAtom      rubySymbol
hi! link erlangBIF       rubyPredefinedIdentifier
hi! link erlangFunction  rubyPredefinedIdentifier
hi! link erlangDirective Statement
hi! link erlangNode      Identifier

" CoffeeScript                                                              {{{2
hi! link coffeeRegExp rubyRegexp

" Lua & Moonscript'                                                         {{{2
hi! link luaOperator Operator

hi! link moonObject     Type
hi! link moonSpecialOp  StringDelimiter
hi! link moonSpecialVar Identifier
hi! link moonObjAssign  StorageClass
hi! link moonObjAssign  StorageClass
hi! link moonConstant   Global

" Objective-C/Cocoa                                                         {{{2
hi! link objcClass       Type
hi! link cocoaClass      objcClass
hi! link objcSubclass    objcClass
hi! link objcSuperclass  objcClass
hi! link objcDirective   rubyClass
hi! link cocoaFunction   Function
hi! link objcMethodName  Identifier
hi! link objcMethodArg   Normal
hi! link objcMessageName Identifier

" Built-in Language Server Protocol
if has('nvim')
    call s:_('ErrorMsgUnderline',   s:red,    'none', 'undercurl')
    call s:_('WarningMsgUnderline', s:yellow, 'none', 'undercurl')
    call s:_('MoreMsgUnderline',    s:blue,   'none', 'undercurl')
    call s:_('MsgUnderline',        s:green,  'none', 'undercurl')
    highlight! link LspDiagnosticsFloatingError ErrorMsg
    highlight! link LspDiagnosticsFloatingWarning Warning
    highlight! link LspDiagnosticsFloatingInformation MoreMsg
    highlight! link LspDiagnosticsFloatingHint Msg
    highlight! link LspDiagnosticsDefaultError ErrorMsg
    highlight! link LspDiagnosticsDefaultWarning WarningMsg
    highlight! link LspDiagnosticsDefaultInformation MoreMsg
    highlight! link LspDiagnosticsDefaultHint Msg
    highlight! link LspDiagnosticsVirtualTextError ErrorMsg
    highlight! link LspDiagnosticsVirtualTextWarning WarningMsg
    highlight! link LspDiagnosticsVirtualTextInformation MoreMsg
    highlight! link LspDiagnosticsVirtualTextHint Msg
    highlight! link LspDiagnosticsUnderlineError ErrorMsgUnderline
    highlight! link LspDiagnosticsUnderlineWarning WarningMsgUnderline
    highlight! link LspDiagnosticsUnderlineInformation MoreMsgUnderline
    highlight! link LspDiagnosticsUnderlineHint MsgUnderline
    highlight! link LspDiagnosticsSignError ErrorMsg
    highlight! link LspDiagnosticsSignWarning WarningMsg
    highlight! link LspDiagnosticsSignInformation MoreMsg
    highlight! link LspDiagnosticsSignHint Msg
    highlight! link LspReferenceText Bold
    highlight! link LspReferenceRead Bold
    highlight! link LspReferenceWrite Bold
    highlight! link TermCursor Cursor
    highlight! link healthError ErrorMsg
    highlight! link healthSuccess Msg
    highlight! link healthWarning WarningMsg
endif

" Neovim Treesitter
call s:_('DoomOneTSException', s:blue, '' ,'underline')
call s:_('DoomOneTSAnnotation', s:blue, '', 'bold')
call s:_('DoomOneTSAttribute', s:blue, '', 'bold')
call s:_('DoomOneTSConditional', s:blue, '', 'none')
call s:_('DoomOneTSComment', s:base5, '', 'none')
call s:_('DoomOneTSConstructor', s:yellow, '', 'none')
call s:_('DoomOneTSConstant', s:violet, '', 'none')
call s:_('DoomOneTSConstBuiltin', s:magenta, '', 'none')
call s:_('DoomOneTSConstMacro', s:blue, '', 'bold')
call s:_('DoomOneTSError', s:red, '', 'none')
call s:_('DoomOneTSField', s:violet, '', 'none')
call s:_('DoomOneTSFloat', s:violet, '', 'none')
call s:_('DoomOneTSFunction', s:magenta, '', 'none')
call s:_('DoomOneTSFuncBuiltin', s:magenta, '', 'none')
call s:_('DoomOneTSFuncMacro', s:blue, '', 'none')
call s:_('DoomOneTSInclude', s:blue, '', 'bold')
call s:_('DoomOneTSKeyword', s:blue, '', 'none')
call s:_('DoomOneTSKeywordFunction', s:blue, '', 'none')
call s:_('DoomOneTSLabel', s:blue, '', 'none')
call s:_('DoomOneTSMethod', s:magenta, '', 'none')
call s:_('DoomOneTSNamespace', s:violet, '', 'none')
call s:_('DoomOneTSNumber', s:violet, '', 'none')
call s:_('DoomOneTSOperator', s:blue, '', 'none')
call s:_('DoomOneTSParameter', '#dcaeea', '', 'none')
call s:_('DoomOneTSParameterReference', '#dcaeea', '', 'none')
call s:_('DoomOneTSProperty', '#a9a1e1', '', 'none')
call s:_('DoomOneTSPunctDelimiter', s:fg, '', 'none')
call s:_('DoomOneTSPunctBracket', s:blue, '', 'none')
call s:_('DoomOneTSPunctSpecial', s:blue, '', 'none')
call s:_('DoomOneTSRepeat', s:magenta, '', 'none')
call s:_('DoomOneTSString', s:green, '', 'none')
call s:_('DoomOneTSStringRegex', '#000', '#00bfff', 'bold')
call s:_('DoomOneTSStringEscape', s:blue, '', 'none')
call s:_('DoomOneTSTag', s:blue, '', 'none')
call s:_('DoomOneTSTagDelimiter', s:yellow, '', 'none')
call s:_('DoomOneTSStrong', '', '', 'bold')
call s:_('DoomOneTSURI', s:blue, '', 'bold,underline')
call s:_('DoomOneTSNote', '', '', 'underline')
call s:_('DoomOneTSWarning', s:yellow, '', 'none')
call s:_('DoomOneTSDanger', s:red, '', 'none')
call s:_('DoomOneTSType', s:yellow, '', 'none')
call s:_('DoomOneTSTypeBuiltin', s:magenta, '', 'none')
call s:_('DoomOneTSVariable', '#dcaeea', '', 'none')
call s:_('DoomOneTSVariableBuiltin', s:magenta, '', 'none')

hi! link TSException          DoomOneTSException
hi! link TSAnnotation         DoomOneTSAnnotation
hi! link TSAttribute          DoomOneTSAttribute
hi! link TSConditional        DoomOneTSConditional
hi! link TSComment            DoomOneTSComment
hi! link TSConstructor        DoomOneTSConstructor
hi! link TSConstant           DoomOneTSConstant
hi! link TSConstBuiltin       DoomOneTSConstBuiltin
hi! link TSConstMacro         DoomOneTSConstMacro
hi! link TSError              DoomOneTSError
hi! link TSField              DoomOneTSField
hi! link TSFloat              DoomOneTSFloat
hi! link TSFunction           DoomOneTSFunction
hi! link TSFuncBuiltin        DoomOneTSFuncBuiltin
hi! link TSFuncMacro          DoomOneTSFuncMacro
hi! link TSInclude            DoomOneTSInclude
hi! link TSKeyword            DoomOneTSKeyword
hi! link TSKeywordFunction    DoomOneTSKeywordFunction
hi! link TSLabel              DoomOneTSLabel
hi! link TSMethod             DoomOneTSMethod
hi! link TSNamespace          DoomOneTSNamespace
hi! link TSNumber             DoomOneTSNumber
hi! link TSOperator           DoomOneTSOperator
hi! link TSParameter          DoomOneTSParameter
hi! link TSParameterReference DoomOneTSParameterReference
hi! link TSProperty           DoomOneTSProperty
hi! link TSPunctDelimiter     DoomOneTSPunctDelimiter
hi! link TSPunctBracket       DoomOneTSPunctBracket
hi! link TSPunctSpecial       DoomOneTSPunctSpecial
hi! link TSRepeat             DoomOneTSRepeat
hi! link TSString             DoomOneTSString
hi! link TSStringRegex        DoomOneTSStringRegex
hi! link TSStringEscape       DoomOneTSStringEscape
hi! link TSTag                DoomOneTSTag
hi! link TSTagDelimiter       DoomOneTSTagDelimiter
hi! link TSStrong             DoomOneTSStrong
hi! link TSURI                DoomOneTSURI
hi! link TSNote               DoomOneTSNote
hi! link TSWarning            DoomOneTSWarning
hi! link TSDanger             DoomOneTSDanger
hi! link TSType               DoomOneTSType
hi! link TSTypeBuiltin        DoomOneTSTypeBuiltin
hi! link TSVariable           DoomOneTSVariable
hi! link TSVariableBuiltin    DoomOneTSVariableBuiltin

" 1}}}

" 1}}}
