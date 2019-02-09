" Change move editor window
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

