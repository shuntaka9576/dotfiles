" =*=*=*=*=*=*=*=*=*=*=*=*=*= dein.vim settings *=*=*=*=*=*=*=*=*=*=*=*=*=*=
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

let s:dein_dir = expand('~/.cache/dein')
let s:toml_dir = expand('~/.config/nvim/dein')

if dein#load_state(s:dein_dir)
 call dein#begin(s:dein_dir)
 call dein#load_toml('~/.config/nvim/dein/dein.toml',           {'lazy': 0})
 call dein#load_toml('~/.config/nvim/dein/dein_git.toml',       {'lazy': 0})

 call dein#load_toml('~/.config/nvim/dein/dein_python.toml',    {'lazy': 1})
 call dein#load_toml('~/.config/nvim/dein/dein_go.toml',        {'lazy': 1})
 call dein#load_toml('~/.config/nvim/dein/dein_linter.toml',    {'lazy': 1})
 call dein#load_toml('~/.config/nvim/dein/dein_lsp.toml',       {'lazy': 1})
 call dein#load_toml('~/.config/nvim/dein/dein_lazy.toml',      {'lazy': 1})

 call dein#end()
 call dein#save_state()
endif
 
if dein#check_install()
 call dein#install()
endif

" =*=*=*=*=*=*=*=*=*=*=*=*=*= Read other vim script *=*=*=*=*=*=*=*=*=*=*=*=*=*=
function! s:source_rc(path, ...) abort 
  let l:use_global = get(a:000, 0, !has('vim_starting'))
  let l:abspath = resolve(expand('~/dotfiles/nvim/' . a:path))
  if !l:use_global
    execute 'source' fnameescape(l:abspath)
    return
  endif
endfunction

call s:source_rc('filetype.vim')
call s:source_rc('mappings.vim')
call s:source_rc('options.vim')
