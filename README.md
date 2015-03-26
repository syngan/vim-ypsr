# vim-ypsr


[![Build Status](https://travis-ci.org/syngan/vim-ypsr.svg?branch=master)](https://travis-ci.org/syngan/vim-ypsr)


- Insert a list of increasing numbers:
```vim
:Ypsr .* 1 2 3 4 5
:Ypsr .* '1' "2" 3 4 5
:Ypsr .* `=range(1, 4)` 5
```

- Original Text:
```
case hoge:
    return "hogehoge"
vim poo
```

- Do `:1,2Ypsr -1 hoge foo baa`, then
```
case hoge:
    return "hogehoge"
case foo:
    return "foohoge"
case baa:
    return "baahoge"
vim poo
```
- Do `:1,2Ypsr -g hoge foo baa`, then
```
case hoge:
    return "hogehoge"
case foo:
    return "foofoo"
case baa:
    return "baabaa"
vim poo
```
- Do `:1,2Ypsr -d -g hoge foo baa`, then
```
case foo:
    return "foofoo"
case baa:
    return "baabaa"
vim poo
```
- Do `:1,2call ypsr#do('hoge', 3, 'g')`
```
case hoge:
    return "hogehoge"
case vim:
    return "vimvim"
case poo:
    return "poopoo"
vim poo
```
