scriptencoding utf-8
if exists('g:loaded_pj') && g:loaded_pj
  finish
endif
let g:loaded_pj = 1

command! PJInit call pj#init()
