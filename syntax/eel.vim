" Vim syntax file
" Language:	JS (Reaper Extension Language)
" Maintainer:	Bruno Czekay <brunorc@gmail.com>
" Last Change:	2010 Dec 05

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded

if !exists("main_syntax")
  if version < 600
    syntax clear
  elseif exists("b:current_syntax")
    finish
  endif
  let main_syntax = 'js'
endif

syn match   JSNumber	        "-\?\([0-9]\+\(\.[0-9]\)\?\)"
syn match   JSVariable          "[a-zA-Z][0-9a-zA-Z]\+"
syn match   JSPrefixedNumber    "\(x[0-9a-fA-F]\+\|o[0-7]\+\|b[01]\+\)"
syn match   JSHexNumber         "\$x[0-9a-fA-F]\+"
syn match   JSCharacter         "\$'.'"

syn match   JSSection           "@\(init\|slider\|block\|sample\|serialize\|gfx\)"
syn match   JSOperator          "[-=*/%^+|&!<>\[\]{}]"
syn match   JSConditional       "[?:]"

syn keyword JSRepeat		while loop
syn keyword JSFunction		sin cos tan asin acos atan atan2 sqr sqrt pow exp log log10 abs min max sign rand floor ceil invsqrt spl mdct imdct fft ifft fft_permute fft_ipermute convolve_c freembuf memcpy memset midirecv midisend midisyx sliderchange slider_automate file_open file_close file_rewind file_var file_mem file_avail file_riff file_text
syn keyword JSGFXFunction       gfx_lineto gfx_rectto gfx_setpixel gfx_getpixel gfx_drawnumber gfx_drawchar gfx_blurto gfx_blit gfx_blittext gfx_getimgdim

syn match   JSSpecialRE	        "\(spl[0-9]\{1,2\}\|slider[0-9]\{1,2\}\|reg[0-9][0-9]\)"
syn keyword JSSpecialKW         trigger srate num_ch tempo samplesblock play_state play_position beat_position ext_noinit ext_nodenorm pdc_delay pdc_midi pdc_bot_ch pdc_top_c
syn keyword JSSpecialGFX        gfx_r gfx_g gfx_b gfx_a gfx_w gfx_h gfx_x gfx_y gfx_mode gfx_clear gfx_texth mouse_x mouse_y mouse_cap

syn match   JSLabel             "\(desc\|slider[0-9]\{1,2\}\|in_pin\|out_pin\|filename\):"

syn region  JSComment	        start="/\*"  end="\*/"
syn match   JSLineComment       "\/\/.*"

syn sync fromstart
syn sync maxlines=100

if main_syntax == "JS"
  syn sync ccomment JSComment
endif

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_js_syn_inits")
  if version < 508
    let did_js_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif
  HiLink JSComment		Comment
  HiLink JSLineComment		Comment
  HiLink JSLabel		Type
  HiLink JSSection		Keyword
  HiLink JSSpecialRE            Type
  HiLink JSSpecialKW            Type
  HiLink JSSpecialGFX           Type
  HiLink JSCharacter		Number
  HiLink JSNumber		Number
  HiLink JSPrefixedNumber       Number
  HiLink JSHexNumber		Number
  HiLink JSConditional		Function
  HiLink JSRepeat		Keyword
  HiLink JSOperator		Operator
  HiLink JSFunction		Function
  HiLink JSGFXFunction		Function

  delcommand HiLink
endif

let b:current_syntax = "js"
if main_syntax == 'js'
  unlet main_syntax
endif

" vim: ts=8
