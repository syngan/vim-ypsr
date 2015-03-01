let s:save_cpo = &cpo
set cpo&vim

scriptencoding utf-8

function! s:echoerr(msg) abort " {{{
  echohl ErrorMsg
  echomsg 'inserttext: ' . a:msg
  echohl None
endfunction " }}}

function! s:get_default_subs() " {{{
  return get(g:, 'ypsr#default_subs', '"')
endfunction " }}}

function! s:get_default_flags() " {{{
  return get(g:, 'ypsr#default_flags', '')
endfunction " }}}

function! s:get_subst(reg) abort " {{{
  if type(a:reg) == type('')
    let list = split(getreg(a:reg))
  elseif type(a:reg) == type(1)
    let list = split(getline(a:reg))
  elseif type(a:reg) == type([])
    return a:reg
  else
    call s:echorr('invalid 4th arg {sub}s')
    return []
  endif
  return filter(list, 'v:val !=# ""')
endfunction " }}}

function! s:ypsr(line1, line2, pat, ...) abort " {{{
  " ypsr(line1, line2, pattern, subst, flags)
  " @param pattern 変換対象
  " @param: subs: 文字列の場合: レジスタを指定されたと思う.
  "               数字の場合: n 行目の内容スペース区切りで利用する
  "               リストの場合: リスト
  let flags = a:0 > 1 ? a:2 : s:get_default_flags()
  let subst_flag = (flags =~# 'g' ? 'g' : '')
  let lines = getline(a:line1, a:line2)

  let list = s:get_subst(a:0 > 0 ? a:1 : s:get_default_subs())
  if list == []
    return 0
  endif

  let save_pos = getpos('.')
  try
    call setpos('.', [0, a:line2, 1, 0])
    for i in range(len(list)-1, 0, -1)
      let val = list[i]
      let newlist = map(copy(lines), 'substitute(v:val, a:pat, val, subst_flag)')
      call append(line('.'), newlist)
    endfor
    if flags =~# 'd'
      execute printf('%d,%d delete _', a:line1, a:line2)
    endif
  finally
    call setpos('.', save_pos)
  endtry
endfunction " }}}

function! ypsr#do(...) abort range " {{{
  " ypsr#do(pat, [reg], [flag])
  " @param pat:  substitute() 第2引数
  " @param reg:  substitute() 第3引数のリスト, または split() of 行番号またはレジスタ
  " @param flag: substitute() 第4引数
  let args = [a:firstline, a:lastline] + a:000
  return call(function('s:ypsr'), args)
endfunction " }}}

function! s:parse_args(str) abort " {{{
  let str = a:str
  let args = []
  while str !~# '^\s*$'
    let str = matchstr(str, '^\s*\zs.*$')
    if str =~# '^[''"]'
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
  let subst = s:get_default_flags()
  let p = s:parse_args(a:arg)
  for i in range(len(p))
    if p[i] ==# '-g'
      let subst .= 'g'
    elseif p[i] ==# '-d'
      let subst .= 'd'
    elseif p[i] ==# '-1'
      let subst = substitute(subst, 'g', '', 'g')
    elseif p[i] ==# '-n'
      let subst = substitute(subst, 'd', '', 'g')
    elseif p[i] ==# '--'
      break
    else
      let i -= 1
      break
    endif
  endfor
  if i+1 >= len(p)
    return s:echoerr('missing {pattern}')
  endif
  let pat = p[i+1]
  let reg = p[i+2 :]

  let args = [a:firstline, a:lastline, pat, reg, subst]
  return call(function('s:ypsr'), args)
endfunction " }}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set et ts=2 sts=2 sw=2 tw=0:
