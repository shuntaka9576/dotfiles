let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 1
let g:ale_lint_on_save = 1

let g:ale_sign_column_always = 1
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1

let g:ale_linters = {
    \ 'python': ['flake8'],
    \ 'go': ['golangci-lint'],
    \ 'json': ['jq'],
    \ 'make': ['checkmake'],
    \ 'vim': ['vint'],
    \ 'shell': ['shellcheck'],
    \ 'vue': ['prettier', 'eslint'],
    \ 'javascript': ['prettier', 'eslint'],
    \ 'typescript': ['prettier', 'eslint'],
    \ }

let g:ale_go_gometalinter_options = '--vendored-linters --disable-all --enable=gotype --enable=vet --enable=golint -t'
let g:ale_go_golangci_lint_options = '--enable-all --disable gochecknoglobals --disable gochecknoinits'
let g:ale_open_list = 1
let g:ale_sign_error = '✗'
let g:ale_sign_warning = '⚠'
let g:ale_statusline_format = ['⨉ %d', '⚠ %d', '⬥ ok']

let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_python_flake8_args = '--max-line-length=120'

let g:ale_fixers = {
    \ 'python':     ['autopep8', 'isort'],
    \ 'json':       ['jq'],
    \ 'javascript': ['prettier'],
    \ 'vue':        ['prettier'],
    \ }
let g:ale_fix_on_save = 1
