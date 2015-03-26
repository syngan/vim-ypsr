let s:save_cpo = &cpo
set cpo&vim

let s:suite = themis#suite('readme-ex')
let s:assert = themis#helper('assert')

function! s:suite.before() " {{{
  let s:lines = [
        \ 'case hoge:',
        \ '    return "hogehoge"',
        \ 'vim poo',
        \]
  lockvar s:lines
endfunction " }}}

function! s:suite.before_each() " {{{
  new
  call append(1, s:lines)
  1 delete _
endfunction " }}}

function! s:suite.after_each() " {{{
  quit!
endfunction " }}}

function! s:suite.ex2_1() " {{{
  1,2Ypsr -1 hoge foo baa

  call s:assert.equals(getline(1), s:lines[0], 1)
  call s:assert.equals(getline(2), s:lines[1], 2)
  call s:assert.equals(getline(3), substitute(s:lines[0], 'hoge', 'foo', ''), 3)
  call s:assert.equals(getline(4), substitute(s:lines[1], 'hoge', 'foo', ''), 4)
  call s:assert.equals(getline(5), substitute(s:lines[0], 'hoge', 'baa', ''), 5)
  call s:assert.equals(getline(6), substitute(s:lines[1], 'hoge', 'baa', ''), 6)
  call s:assert.equals(getline(7), s:lines[2], 7)
endfunction " }}}

function! s:suite.ex2_2() " {{{
  1,2Ypsr -g hoge foo baa

  call s:assert.equals(getline(1), s:lines[0], 1)
  call s:assert.equals(getline(2), s:lines[1], 2)
  call s:assert.equals(getline(3), substitute(s:lines[0], 'hoge', 'foo', 'g'), 3)
  call s:assert.equals(getline(4), substitute(s:lines[1], 'hoge', 'foo', 'g'), 4)
  call s:assert.equals(getline(5), substitute(s:lines[0], 'hoge', 'baa', 'g'), 5)
  call s:assert.equals(getline(6), substitute(s:lines[1], 'hoge', 'baa', 'g'), 6)
  call s:assert.equals(getline(7), s:lines[2], 7)
endfunction " }}}

function! s:suite.ex2_3() " {{{
  1,2Ypsr -d -1 hoge foo baa

  call s:assert.equals(getline(1), substitute(s:lines[0], 'hoge', 'foo', ''), 1)
  call s:assert.equals(getline(2), substitute(s:lines[1], 'hoge', 'foo', ''), 2)
  call s:assert.equals(getline(3), substitute(s:lines[0], 'hoge', 'baa', ''), 3)
  call s:assert.equals(getline(4), substitute(s:lines[1], 'hoge', 'baa', ''), 4)
  call s:assert.equals(getline(5), s:lines[2], 5)
endfunction " }}}

function! s:suite.ex2_4() " {{{
  1,2call ypsr#do('hoge', 3, 'g')
  call s:assert.equals(getline(1), s:lines[0], 1)
  call s:assert.equals(getline(2), s:lines[1], 2)
  call s:assert.equals(getline(3), substitute(s:lines[0], 'hoge', 'vim', 'g'), 3)
  call s:assert.equals(getline(4), substitute(s:lines[1], 'hoge', 'vim', 'g'), 4)
  call s:assert.equals(getline(5), substitute(s:lines[0], 'hoge', 'poo', 'g'), 5)
  call s:assert.equals(getline(6), substitute(s:lines[1], 'hoge', 'poo', 'g'), 6)
  call s:assert.equals(getline(7), s:lines[2], 7)
endfunction " }}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set et ts=2 sts=2 sw=2 tw=0:
