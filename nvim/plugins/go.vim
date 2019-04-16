let g:go_fmt_command = "goimports"
" let g:go_def_mode = "gopls"

augroup GoCommands
    autocmd!
    autocmd FileType go nmap <silent><leader>r  <Plug>(go-run)
    autocmd FileType go nmap <silent><leader>rn <Plug>(go-rename)
    autocmd FileType go nmap <silent><leader>b  <Plug>(go-build)
    autocmd FileType go nmap <silent><leader>tt <Plug>(go-test)
    autocmd FileType go nmap <silent><leader>tf <Plug>(go-test-func)
    autocmd FileType go nmap <silent><leader>ts :<C-u>GoTests
    autocmd FileType go nmap <silent><leader>ta :<C-u>GoTestsAll
    autocmd FileType go nmap <silent><leader>m  <Plug>(go-imports)
    autocmd FileType go nmap <silent><leader>i  <Plug>(go-install)
    autocmd FileType go nmap <silent><leader>k  <Plug>(go-doc-browser)
    autocmd FileType go nmap <silent><leader>c  <Plug>(go-coverage-toggle)
    autocmd FileType go nmap <silent><leader>a  <Plug>(go-alternate-edit)
    autocmd FileType go nmap <silent><leader>e  <Plug>(go-iferr)
    autocmd FileType go nmap <silent><leader>p  <Plug>(go-implements)
    autocmd FileType go nmap <silent><leader>d  <Plug>(go-def)
    autocmd FileType go nmap <silent><leader>s  <Plug>(go-def-split)
    autocmd FileType go nmap <silent><leader>v  <Plug>(go-def-vertical)
augroup END
