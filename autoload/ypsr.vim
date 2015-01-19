let s:save_cpo = &cpo
set cpo&vim

scriptencoding utf-8

" ypsr#do(pat, sub, {flag}, {reg})
" @param pat:  substitute() 第2引数
" @param sub:  代入元. substitute() 第3引数
" @param flag: substitute() 第4引数
" @param reg:  substitute() 第1引数
function! ypsr#do(pat, sub, ...) abort
  let subst_flag = a:0 > 0 ? a:1 : ''
  let reg = a:0 > 1 ? a:2 : ''

  " 
  if type(reg) == type('')
    let lines = split(getreg('"'), "\n")
  elseif type(reg) == type([])
    let lines = getline(reg[0], reg[1])
  elseif type(reg) == type(1)
    let lines = getline(reg)
  elseif type(reg) == type('')
    let lines = split(getreg(reg), "\n")
  else
    throw 'ypsr: invalid 4th arg'
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
