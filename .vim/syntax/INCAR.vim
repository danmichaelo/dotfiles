" Vim syntax file
" Language:	    VASP INCAR
" Maintainer:	Dan Michael Heggø
" Last Change:  May 06, 2011 16:09:12	
" Filenames:	INCAR

" Quit when a syntax file was already loaded
if exists("b:current_syntax")
    finish
endif

" is it?
syn case ignore
"syn case match

syn keyword incarBasics SYSTEM ISTART

" Def means default colour - colourschemes can override
hi def incarBasics guibg=yellow guifg=blue ctermbg=yellow ctermfg=blue

let b:current_syntax = "INCAR"

" vim: nowrap sw=4 sts=4 ts=4 et
