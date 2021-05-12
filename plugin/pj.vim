scriptencoding utf-8
if exists('g:loaded_pj') && g:loaded_pj
  finish
endif
let g:loaded_pj = 1

let s:plugin_root_dir = expand('<sfile>:h:h')
let g:pj_command_path = get(g:, 'pj_command_path', s:plugin_root_dir .. '/bin/pj')
let g:pj_auto_cd = get(g:, 'pj_auto_cd', v:true)

command! PJInstall call pj#install_command()

if !executable(g:pj_command_path)
  finish
endif

command! PJInit call pj#init()
command! PJCommandUpgrade call pj#upgrade_command()

if g:pj_auto_cd
  augroup PJAutoCd
    autocmd!
    autocmd VimEnter * call pj#cd('current')
  augroup END
endif
