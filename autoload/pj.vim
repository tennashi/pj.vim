function! pj#cd(project) abort
  if a:project ==# "current"
    let l:stdout = system(g:pj_command_path .. ' -o json current')
    let l:res = json_decode(l:stdout)
    call chdir(l:res['currentWorkspace'])
  endif
endfunction

function! pj#init() abort
  let l:stdout = system(g:pj_command_path .. ' -o json init')
  let l:res = json_decode(stdout)
  echom '[pj] ' .. 'project created: ' .. l:res['name']
endfunction

function! pj#install_command() abort
  if executable(g:pj_command_path)
    echom '[pj] ' .. 'already installed'
    return
  endif

  let l:res = system('curl -s https://api.github.com/repos/tennashi/pj/releases/latest')
  let l:assets = json_decode(l:res)['assets']
  if system('uname -s') !~# 'Linux'
    echom '[pj] ' .. 'unsupported OS'
    return
  endif
  if system('uname -m') !~# 'x86_64\|amd64'
    echom '[pj] ' .. 'unsupported arch'
    return
  endif

  for l:asset in l:assets
    if l:asset['name'] =~# 'pj.*linux_amd64.*'
      call system('curl -sL ' .. l:asset['browser_download_url'] .. ' -o /tmp/pj.tar.gz')
      call mkdir('/tmp/pj')
      call system('tar xz -C /tmp/pj -f /tmp/pj.tar.gz')
      call mkdir(fnamemodify(g:pj_command_path, ':h'), 'p')
      call system('mv /tmp/pj/pj ' .. g:pj_command_path)
      call system('rm -rf /tmp/pj')
      call system('rm /tmp/pj.tar.gz')
      echom '[pj] ' .. 'pj command installed: ' .. g:pj_command_path
    endif
  endfor

  return
endfunction

function! pj#upgrade_command() abort
  let l:stdout_lines = systemlist(g:pj_command_path .. ' self-upgrade')
  for l:line in l:stdout_lines
    echom '[pj] ' .. l:line
  endfor
endfunction
