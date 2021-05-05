scriptencoding utf-8
if exists('g:loaded_pj') && g:loaded_pj
  finish
endif
let g:loaded_pj = 1

let s:plugin_root_dir = expand('<sfile>:h:h')
let g:pj_command_path = get(g:, 'pj_command_path', s:plugin_root_dir .. '/bin/pj')

command! PJInit call pj#init()
command! PJInstall call pj#install_command()
