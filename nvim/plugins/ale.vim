" message
let g:ale_sign_error = '👿'
let g:ale_sign_warning = '🤔'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

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

nmap <silent> <C-n> <Plug>(ale_next_wrap)
