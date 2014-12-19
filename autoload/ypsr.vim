let s:save_cpo = &cpo
set cpo&vim

function! ypsr#do(from, to, ...) range
  let subst_flag = a:0 > 0 ? a:1 : ''
" let replace_flag = a:0 > 1 ? a:2 : ''
  let lines = getline(a:firstline, a:lastline)

  let list = (type(a:to) == type([]) ?  a:to : [a:to])
  for i in range(len(list)-1, 0, -1)
    let val = list[i]
    let newlist = map(copy(lines), 'substitute(v:val, a:from, val, subst_flag)')
    call append(line('.'), newlist)
  endfor
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set et ts=2 sts=2 sw=2 tw=0:
