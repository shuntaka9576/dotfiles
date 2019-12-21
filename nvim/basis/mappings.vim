" デフォルトキーマッピングの変更
inoremap <C-c> <ESC>
inoremap jj <Esc>
inoremap JJ <Esc>
nnoremap <C-k>j <C-w>j
nnoremap <C-k>k <C-w>k
nnoremap <C-k>l <C-w>l
nnoremap <C-k>h <C-w>h
nnoremap <C-k>r <C-w>r
nnoremap <C-k>w <C-w>w

" <leader>の設定
let g:mapleader = ','
let g:maplocalleader = '\'

" 一行が複数行になった場合の、移動
noremap k gk
noremap j gj
noremap gk k
noremap gj j
noremap <Down> gj
noremap <Up> gk

" ヤンクをクリップボードに保存
set clipboard+=unnamed

" 縦横のカーソル表示
set cursorline
set cursorcolumn

" 行を折り返す
set wrap

" 制御文字の可視化
" trailは行末に続くスペースを笑わす
set list
set listchars=tab:»-,extends:»,precedes:«,nbsp:%,eol:↲,trail:~

" 検索結果のハイライトを消す
noremap <silent><Space><Space> :nohlsearch<Cr><Esc>

" 行数表示
set number
set relativenumber

" タブ設定
nnoremap <silent>tf :<c-u>tabfirst<cr>
nnoremap <silent>tl :<c-u>tablast<cr>
nnoremap <silent>tn :<c-u>tabnext<cr>
nnoremap <silent><tab> :<c-u>tabnext<cr>
nnoremap <silent>tN :<c-u>tabNext<cr>
nnoremap <silent><S-tab> :<c-u>tabprevious<cr>
nnoremap <silent>tp :<c-u>tabprevious<cr>
nnoremap <silent>te :<c-u>tabedit<cr>
nnoremap <silent>tc :<c-u>tabclose<cr>
nnoremap <silent>to :<c-u>tabonly<cr>
nnoremap <silent>ts :<c-u>tabs<cr>
