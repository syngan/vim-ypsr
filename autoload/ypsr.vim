let s:save_cpo = &cpo
set cpo&vim

function! ypsr#do(pat, sub, ...) abort
  let subst_flag = a:0 > 0 ? a:1 : ''
  let reg = a:0 > 1 ? a:2 : ''
  if type(reg) == type('')
    let lines = getreg('"')
  elseif type(reg) == type([])
    let lines = getline(reg[0], reg[1])
  elseif type(reg) == type(1)
    let lines = getline(reg)
  else
    throw "ypsr: invalid 4th arg"
  endif

  let list = (type(a:sub) == type([]) ?  a:sub : [a:sub])
  for i in range(len(list)-1, 0, -1)
    let val = list[i]
    let newlist = map(copy(lines), 'substitute(v:val, a:pat, val, subst_flag)')
    call append(line('.'), newlist)
  endfor
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set et ts=2 sts=2 sw=2 tw=0:
