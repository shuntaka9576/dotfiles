" message
let g:ale_sign_error = '👿'
let g:ale_sign_warning = '🤔'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

let g:ale_lint_on_enter = 0
let g:ale_lint_on_save = 0 

let g:ale_linters = {
   \ 'python': ['flake8', 'mypy'],
   \ 'go': ['golangci-lint'],
   \ 'json': ['jq'],
   \ 'make': ['checkmake'],
   \ 'vim': ['vint'],
   \ 'shell': ['shellcheck'],
   \ 'vue': ['prettier', 'eslint'],
   \ 'javascript': ['prettier', 'eslint'],
   \ 'typescript': ['prettier', 'eslint'],
   \ }

let g:ale_go_golangci_lint_options = '--enable-all --disable gochecknoglobals --disable gochecknoinits'

let g:ale_fixers = {
    \ 'python':     ['autopep8', 'isort', 'black'],
    \ 'json':       ['jq'],
    \ 'javascript': ['prettier'],
    \ 'vue':        ['prettier'],
    \ }
let g:ale_fix_on_save = 1
let g:ale_save_event_fired = 0

nmap <silent> <C-n> <Plug>(ale_next_wrap)

function! s:ale_list()
  let g:ale_open_list = 1
  call ale#Queue(0, 'lint_file')
endfunction
command! ALEList call s:ale_list()
nnoremap <leader>m  :ALEList<CR>
autocmd FileType qf nnoremap <silent><buffer> q :let g:ale_open_list = 0<CR>:q!<CR>
autocmd FileType help,qf,man,ref let b:ale_enabled = 0
