let s:save_cpo = &cpo
set cpo&vim

scriptencoding utf-8

function! s:get_default_reg() " {{{
  return get(g:, 'ypsr#default_reg', '"')
endfunction " }}}

function! s:get_default_subst() " {{{
  return get(g:, 'ypsr#default_subst_flag', '')
endfunction " }}}

function! s:ypsr(line1, line2, pat, ...) abort " {{{
  let reg        = a:0 > 0 ? a:1 : s:get_default_reg()
  let subst_flag = a:0 > 1 ? a:2 : s:get_default_subst()
  let lines = getline(a:line1, a:line2)

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
    call setpos('.', [0, a:line2, 1, 0])
    for i in range(len(list)-1, 0, -1)
      let val = list[i]
      let newlist = map(copy(lines), 'substitute(v:val, a:pat, val, subst_flag)')
      call append(line('.'), newlist)
    endfor
  finally
    call setpos('.', save_pos)
  endtry
endfunction " }}}

function! ypsr#do(pat, ...) abort range " {{{
  " ypsr#do(pat, [reg], [flag])
  " @param pat:  substitute() 第2引数
  " @param reg:  substitute() 第3引数のリスト, または split() of 行番号またはレジスタ
  " @param flag: substitute() 第4引数
  let args = [a:firstline, a:lastline, a:pat] + a:000
  return call(function('s:ypsr'), args)
endfunction " }}}

function! ypsr#command(pat, ...) range abort " {{{
  let args = [a:firstline, a:lastline, a:pat]
  if a:0 > 0
    let args += [a:000]
  endif
  return call(function('s:ypsr'), args)
endfunction " }}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set et ts=2 sts=2 sw=2 tw=0:
