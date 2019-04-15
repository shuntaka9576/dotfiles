let g:go_fmt_command = "goimports"
let g:go_def_mode = "gopls"
nmap <leader>rn <Plug>(coc-rename)
let mapleader = "\<Space>"

au FileType go nmap <leader>s <Plug>(go-def-split)
au FileType go nmap <leader>v <Plug>(go-def-vertical)
