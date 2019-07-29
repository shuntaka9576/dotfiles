" guitter size fix
set signcolumn=yes 

" cursor settigs
set lazyredraw
set cursorline
set cursorcolumn
highlight cursorline term=reverse cterm=reverse

" Change move editor window	
nnoremap <C-k>j <C-w>j
nnoremap <C-k>k <C-w>k
nnoremap <C-k>l <C-w>l
nnoremap <C-k>h <C-w>h
nnoremap <C-k>r <C-w>r
nnoremap <C-k>w <C-w>w

" Invisible stirng
set list
set listchars=tab:»-,extends:»,precedes:«,nbsp:%,eol:↲,trail:~

" Display row number
set number
set relativenumber

" Long text
set wrap
set textwidth=0
set colorcolumn=256

" Don't unload buffer when it is abandones
set hidden

" open already buffer
set switchbuf=useopen

" Smart insert tab setting
set smarttab

" Excahnge tab to space
set expandtab

" Auto insert indent.
set autoindent

" Round indent by shiftwidth
set shiftwidth=4

" Round indent to multipul of shiftwidth
set shiftround

" Space insert by autoindent
set tabstop=4
set scrolloff=15

" Splitting a window will put the new window below the current one
set splitbelow
" Splitting a window will put the new window right the current one
set splitright
" Set minimal width for current window
set winwidth=30
" Set minimal height for current window
set winheight=1
" Set maximam maximam command line window
set cmdwinheight=5
" No equal window size.
set noequalalways
" Adjust window size of preview and help
set previewheight=8
set helpheight=12

" show tab line
set showtabline=2

" Ignore upper lower case
set ignorecase

" No ignore case when pattern has uppercase
set smartcase

" Search is incremental search
set incsearch

" Show search result highlight
set hlsearch

" Share clipborad with system
if has('nvim')
	set clipboard+=unnamedplus
else
	set clipboard=unnamed
endif

" Disable fold
set nofoldenable

" Use extend grep
if executable('rg')
    let &grepprg = 'rg --vimgrep --hidden'
    set grepformat=%f:%l:%c:%m
elseif executable('pt')
    let &grepprg = 'pt --nocolor --nogroup --column'
    set grepformat=%f:%l:%c:%m
endif

" jq command
command! -nargs=? Jq call s:Jq(<f-args>)
function! s:Jq(...)
    if 0 == a:0
        let l:arg = "."
    else
        let l:arg = a:1
    endif
    execute "%! jq \"" . l:arg . "\""
endfunction

" Number of characters to apply syntax per line
set synmaxcol=512

" Disable sql omni complete
let g:omni_sql_no_default_maps = 1

" Disable conceal for visible markdown decoration
set conceallevel=0

" tab page action
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
