let s:save_cpo = &cpo
set cpo&vim

let s:suite = themis#suite('do')
let s:assert = themis#helper('assert')

let s:debug = 0

function! s:suite.before()
  let s:lines = [
        \ "x1ddddddddd",
        \ "01234567890",
        \ "hoge1 test1 tako1 test1",
        \ "13gggggggggzzzz",
        \ "x2ddddddddd",
        \]
  lockvar s:lines
endfunction

function! s:suite.before_each()
  new
  call append(1, s:lines)
  1 delete _
endfunction

function! s:suite.after_each()
  quit!
endfunction

function! s:suite.ypsr()
  let vv = ["test2", "test3", "test4"]
  let lines = getline(2, 4)
  let name = "ypsr"
  let sf = ''
  if s:debug
    call writefile(getline(0, line('$')), "/tmp/ypsr1")
  endif

  for i in range(len(s:lines))
    call s:assert.equals(getline(i+1), s:lines[i], printf("%s line=%d", "prev", i+1))
  endfor

  execute "normal!" "G"
  call ypsr#do("test1", vv, sf, [2,4])
  if s:debug
    call writefile(getline(0, line('$')), "/tmp/ypsr2")
  endif

  for i in range(len(s:lines))
    call s:assert.equals(getline(i+1), s:lines[i], printf("%s line=%d", name, i+1))
  endfor

  let l = len(s:lines)
  for v in vv
    for i in range(len(lines))
      let l += 1
      call s:assert.equals(getline(l), substitute(lines[i], "test1", v, sf), printf("%s %s, i=%d, line=%d", name, v, i, l))
    endfor
  endfor

endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set et ts=2 sts=2 sw=2 tw=0:
