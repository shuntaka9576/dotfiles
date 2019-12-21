" =*=*=*=*=*=*=*=*=*=*=*=*=*= Read other vim script *=*=*=*=*=*=*=*=*=*=*=*=*=*=
function! s:source_rc(path, ...) abort
  let l:use_global = get(a:000, 0, !has('vim_starting'))
  let l:abspath = resolve(expand('~/dotfiles/nvim/basis/' . a:path))
  if !l:use_global
    execute 'source' fnameescape(l:abspath)
    return
  endif
endfunction

call s:source_rc('filetype.vim')
call s:source_rc('mappings.vim')

" =*=*=*=*=*=*=*=*=*=*=*=*=*= dein.vim settings *=*=*=*=*=*=*=*=*=*=*=*=*=*=
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

let s:dein_dir = expand('~/.cache/dein')
let s:toml_dir = expand('~/.config/nvim/dein')

if dein#load_state(s:dein_dir)
 call dein#begin(s:dein_dir)
 call dein#load_toml('~/.config/nvim/dein/notlazy.toml',       {'lazy': 0})
 call dein#load_toml('~/.config/nvim/dein/frontend.toml',      {'lazy': 0})
 call dein#load_toml('~/.config/nvim/dein/extensions.toml',    {'lazy': 0})
 call dein#load_toml('~/.config/nvim/dein/hack.toml',          {'lazy': 1})

 call dein#end()
 call dein#save_state()
endif
 
if dein#check_install()
 call dein#install()
endif
