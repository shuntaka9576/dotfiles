" change <ESC> mappings
inoremap <C-c> <ESC>
inoremap jj <Esc>
inoremap JJ <Esc>
" inoremap <C-j> <Down>
" inoremap <C-k> <Up>
" inoremap <C-b> <Left>
" inoremap <C-f> <Right>

" <leader> setting
let mapleader = ','

" Search settigs
noremap <Space> *
noremap <silent><Space><Space> :nohlsearch<Cr><Esc>

" Multi line move
noremap k gk
noremap j gj
noremap gk k
noremap gj j
noremap <Down> gj
noremap <Up> gk

" Run script settings
autocmd BufNewFile,BufRead *.rb nnoremap <leader><C-r> :!ruby %
autocmd BufNewFile,BufRead *.py nnoremap <leader><C-r> :!python %
autocmd BufNewFile,BufRead *.pl nnoremap <leader><C-r> :!perl %

" Split window command
" nnoremap ss :<C-u>sp<CR>
nnoremap vv :<C-u>vs<CR>
