" Change <c-c> to complete <esc>
inoremap <C-c> <ESC>

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
autocmd BufNewFile,BufRead *.rb nnoremap <C-r> :!ruby %
autocmd BufNewFile,BufRead *.py nnoremap <C-r> :!python %
autocmd BufNewFile,BufRead *.pl nnoremap <C-r> :!perl %

