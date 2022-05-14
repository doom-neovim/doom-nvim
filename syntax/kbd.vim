" Vim syntax file
" Language:     kbd
" Maintainer:   Hugo Heagren
" Last Change:	2021 Mar 23
" URL:          https://git.hugoheagren.com/Hugo-Heagren/KMonad.vim
" Version:      0.0.1
" Copyright 2021 Hugo Heagren

" This file is free software; you can redistribute it and/or modify
" it under the terms of the GNU General Public License as published by
" the Free Software Foundation; either version 3, or (at your option)
" any later version.

" This file is distributed in the hope that it will be useful,
" but WITHOUT ANY WARRANTY; without even the implied warranty of
" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
" GNU General Public License for more details.

" You should have received a copy of the GNU General Public License
" along with this program.  If not, see <http://www.gnu.org/licenses/>.

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" Comments {{{1

syn keyword kmonadTodo TODO FIXME XXX NOTE BUG contained
hi def link kmonadTODO Todo

syn match kmonadLineComment ";;.*$" contains=kmonadTODO keepend containedin=ALL
hi def link kmonadLineComment Comment
syn region kmonadMultiComment start="#|" end="|#" fold contains=kmonadTODO containedin=ALL
hi def link kmonadMultiComment Comment

set commentstring=;;%s

" Matchit jumping between multiline comment markers {{{2

let mtRgx = '#|:|#'

if exists("b:match_words")
	let b:match_words .= mtRgx
else
	let b:match_words = mtRgx
endif

" }}}2

" }}}1

setlocal iskeyword+=-

hi def link kmonadkeyword Keyword

" Data Types {{{1

" Strings {{{2

syn cluster kmonadString contains=kmonadDoubleQuotes,kmonadSingleQuotes

syn region kmonadSingleQuotes start=/"/ end=/"/ skip=/\\"/ contained
hi def link kmonadSingleQuotes String
syn region kmonadDoubleQuotes start=/'/ end=/'/ skip=/\\'/ contained
hi def link kmonadDoubleQuotes String

" }}}2

" Boolean {{{2

syn keyword kmonadBool true false contained
hi def link kmonadBool Boolean

" }}}2

" Aliases {{{2

" Aliases can't include ')' or '"' characters, which makes it much easier to
" delimit them!
" See `src/KMonad/Args/Parser.hs` in the KMonad source.
syn match kmonadAliascode '@[^ 	)"]\+' contained
hi def link kmonadAliascode Structure

" }}}2

" Numbers {{{2

syn match kmonadNumber '\<\d\+\>' contained
hi def link kmonadNumber Number

" }}}2

" }}}1

" defcfg {{{1

syn region kmonaddefcfg end=')' matchgroup=kmonadkeyword start='(\zsdefcfg' contains=@kmonaddefcfgOpts fold

" defcfg options {{{2

syn cluster kmonaddefcfgOpts contains=kmonaddefcfgIOOpts,kmonaddefcfgBoolOpts,kmonaddefcfgOptCmpSeq

" Input/Output Options (`input`, `output`, `init`) {{{3

syn region kmonaddefcfgIOOpts end='$' matchgroup=kmonaddefcfgOptName start='input'  contained keepend
syn region kmonaddefcfgIOOpts end='$' matchgroup=kmonaddefcfgOptName start='output' contained keepend
syn region kmonaddefcfgIOOpts end='$' matchgroup=kmonaddefcfgOptName start='init'   contained keepend

" }}}3

syn region kmonaddefcfgOptCmpSeq end='$' matchgroup=kmonaddefcfgOptName start='cmp-seq' contained

" Boolean Options (`fallthrough`, `allow-cmd`) {{{3

syn region kmonaddefcfgBoolOpts    end='$' matchgroup=kmonaddefcfgOptName start='allow-cmd'   contains=kmonadBool contained
syn region kmonaddefcfgBoolOpts end='$' matchgroup=kmonaddefcfgOptName start='fallthrough' contains=kmonadBool contained

" }}}3

hi def link kmonaddefcfgOptName Constant

" Option functions in brackets {{{3

syn region kmonaddefcfgOptValBrack start='(' end=')' contained keepend contains=@kmonadString,kmonaddefcfgIOName containedin=kmonaddefcfgIOOpts

syn keyword kmonaddefcfgIOName kext uinput-sink send-event-sink device-file low-level-hook iokit-name contained nextgroup=@kmonadString
hi def link kmonaddefcfgIOName Structure

" }}}3

" }}}2

" }}}1

" defsrc {{{1

syn region kmonaddefsrc end=')' matchgroup=kmonadkeyword start='(\zsdefsrc' fold

" }}}1

" defalias {{{1

syn region kmonaddefalias end=')' matchgroup=kmonadkeyword start='(\zsdefalias' contains=kmonaddefaliasName,kmonaddefaliasBrackVal fold

syn match kmonaddefaliasName '\(defalias\s\+\|^\)\zs\s*[^ 	#(]\S\+\ze\s\+\S' nextgroup=kmonaddefaliasBrackVal contained
hi def link kmonaddefaliasName Identifier

hi def link kmonaddefaliasMod Keyword

syn region kmonaddefaliasBrackVal end=')' matchgroup=kmonaddefaliasMod start='(\zsaround\(-next\(-single\)\?\)\?' contained contains=kmonadAliascode,kmonaddefaliasBrackVal
syn region kmonaddefaliasBrackVal end=')' matchgroup=kmonaddefaliasMod start='(\zscmd-button' contained contains=@kmonadString
syn region kmonaddefaliasBrackVal end=')' matchgroup=kmonaddefaliasMod start='(\zsmulti-tap' contained contains=kmonadAliascode,kmonaddefaliasBrackVal
syn region kmonaddefaliasBrackVal end=')' matchgroup=kmonaddefaliasMod start='(\zslayer-\(add\|delay\|next\|rem\|switch\|toggle\)' contained contains=kmonadAliascode,kmonaddefaliasBrackVal
syn region kmonaddefaliasBrackVal end=')' matchgroup=kmonaddefaliasMod start='tap\(-macro\)\?-next\(-release\)\?' contained contains=kmonadAliascode,kmonaddefaliasBrackVal
syn region kmonaddefaliasBrackVal end=')' matchgroup=kmonaddefaliasMod start='(\zstap-hold\(-next\(-release\)\?\)\?' nextgroup=kmonadNumber contained contains=kmonadAliascode,kmonaddefaliasBrackVal,kmonadNumber
syn region kmonaddefaliasBrackVal end=')' matchgroup=kmonaddefaliasMod start='#\ze(' contained contains=kmonadAliascode,kmonaddefaliasBrackVal keepend

" }}}1

" deflayer {{{1

syn region kmonaddeflayer end=')' matchgroup=kmonadkeyword start='(\zsdeflayer' skip='\\)' contains=kmonadPlus,kmonadAliascode fold

syn match kmonadPlus '\s\zs+\S\+\ze'
hi def link kmonadPlus Structure

" }}}1
