let s:save_cpo = &cpo
set cpo&vim

command! -range -nargs=+ Ypsr
\ <line1>,<line2>call ypsr#command(<f-args>)

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set et ts=2 sts=2 sw=2 tw=0:
