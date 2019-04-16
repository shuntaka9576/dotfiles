" Change <c-c> to complete <esc>
inoremap <C-c> <ESC>

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

