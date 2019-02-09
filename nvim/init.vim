" =*=*=*=*=*=*=*=*=*=*=*=*=*= dein.vim settings *=*=*=*=*=*=*=*=*=*=*=*=*=*=
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

let s:dein_dir = expand('~/.cache/dein')
let s:toml_dir = expand('~/.config/nvim/dein')

if dein#load_state(s:dein_dir)
 call dein#begin(s:dein_dir)
 call dein#load_toml('~/.config/nvim/dein/dein.toml',             {'lazy': 0})

 call dein#load_toml('~/.config/nvim/dein/dein_python.toml',      {'lazy': 1})
 call dein#load_toml('~/.config/nvim/dein/dein_go.toml',          {'lazy': 1})
 call dein#load_toml('~/.config/nvim/dein/dein_linter.toml',      {'lazy': 1})
 call dein#load_toml('~/.config/nvim/dein/dein_lsp.toml',         {'lazy': 1})
 call dein#load_toml('~/.config/nvim/dein/dein_lazy.toml',        {'lazy': 1})

 call dein#end()
 call dein#save_state()
endif
 
if dein#check_install()
 call dein#install()
endif

" =*=*=*=*=*=*=*=*=*=*=*=*=*= base settings *=*=*=*=*=*=*=*=*=*=*=*=*=*=
" 行数表示
set number

" カーソル表示
set cursorline
highlight cursorline term=reverse cterm=reverse

" タブ移動設定
nnoremap s <Nop>
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h
nnoremap sJ <C-w>J
nnoremap sK <C-w>K
nnoremap sL <C-w>L
nnoremap sH <C-w>H
nnoremap sr <C-w>r
nnoremap sw <C-w>w

" スクリプ実行ショートカット
autocmd BufNewFile,BufRead *.rb nnoremap <C-e> :!ruby %
autocmd BufNewFile,BufRead *.py nnoremap <C-e> :!python %
autocmd BufNewFile,BufRead *.pl nnoremap <C-e> :!perl %
