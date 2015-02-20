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
  " ypsr(line1, line2, pattern, reg, subst)
  " @param pattern 変換対象
  " @param reg: 文字列の場合: レジスタを指定されたと思う.
  "             数字の場合: n 行目の内容スペース区切りで利用する
  "             リストの場合: リスト
  " @param subst: substitute() の第4引数

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

function! s:parse_args(str) abort " {{{
  let str = a:str
  let args = []
  while str !~# '^\s*$'
    let str = matchstr(str, '^\s*\zs.*$')
    if str[0] =~# '[''"]'
      let typ = 1
      let arg = matchstr(str, printf('.*\ze\\@<!%s', str[0]), 1)
      let str = str[strlen(arg) + 2 :]
      " spece....?
    elseif str =~# '^`='
      let typ = 0
      let arg = matchstr(str, '.*\ze`', 2)
      let str = str[strlen(arg) + 3 :]
    else
      let typ = 2
      let arg = matchstr(str, '\S\+')
      let str = str[strlen(arg) :]
    endif
    if typ != 0
      let arg = substitute(arg, '\\\(.\)', '\1', 'g')
      call add(args, arg)
    else
      let e = eval(arg)
      if type(e) == type([])
        let args += e
      else
        call add(args, e)
      endif
      unlet e
    endif
  endwhile

  return args
endfunction " }}}

function! ypsr#command(arg) range abort " {{{
  let subst = s:get_default_subst()
  let p = s:parse_args(a:arg)
  for i in range(len(p))
    if p[i] ==# '-g'
      let subst = 'g'
    elseif p[i] ==# '-1'
      let subst = ''
    elseif p[i] ==# '--'
      let i += 1
      break
    else
      break
    endif
  endfor
  let pat = p[i]
  let reg = p[i+1 :]

  let args = [a:firstline, a:lastline, pat, reg, subst]
  return call(function('s:ypsr'), args)
endfunction " }}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set et ts=2 sts=2 sw=2 tw=0:
