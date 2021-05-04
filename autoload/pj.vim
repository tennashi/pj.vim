function! pj#init() abort
  let l:stdout = system('pj -o json init')
  let l:res = json_decode(stdout)
  echom '[pj] ' .. 'project created: ' .. l:res['name']
endfunction
