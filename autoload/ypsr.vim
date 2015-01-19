let s:save_cpo = &cpo
set cpo&vim

scriptencoding utf-8

" ypsr#do(pat, [reg], [flag])
" @param pat:  substitute() 第2引数
" @param reg:  substitute() 第3引数のリスト, または split() of 行番号またはレジスタ
" @param flag: substitute() 第4引数 
function! ypsr#do(pat, ...) abort range

  let reg        = a:0 > 0 ? a:1 : '"'
  let subst_flag = a:0 > 1 ? a:2 : ''

  let lines = getline(a:firstline, a:lastline)

  if type(reg) == type('')
    let list = split(getreg(reg))
    let list = filter(list, 'v:val !=# ""')
  elseif type(reg) == type(1)
    let list = split(getline(reg))
    let list = filter(list, 'v:val !=# ""')
  elseif type(reg) == type([])
    let list = reg
  else
    throw 'ypsr: invalid 4th arg'
  endif

  let save_pos = getpos('.')
  try
    call setpos('.', [0, a:lastline, 1, 0])
    for i in range(len(list)-1, 0, -1)
      let val = list[i]
      let newlist = map(copy(lines), 'substitute(v:val, a:pat, val, subst_flag)')
      call append(line('.'), newlist)
    endfor
  finally
    call setpos('.', save_pos)
  endtry
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set et ts=2 sts=2 sw=2 tw=0:
