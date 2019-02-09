if (executable('pyls'))
    augroup LspPython
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['pyls']},
        \ 'whitelist': ['python']
        \ })
    augroup END
endif

if executable('bingo')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'bingo',
        \ 'cmd': {server_info->['bingo', '-mode', 'stdio']},
        \ 'whitelist': ['go'],
        \ })
endif


augroup PylsCommands
    autocmd!
    " TODO 
    " start pyls when enter python file
    autocmd BufWinEnter *.py :call lsp#enable()
    " local key mapping
    autocmd FileType python nnoremap <C-]> :<C-u>LspDefinition<CR>
    autocmd FileType python nnoremap K :<C-u>LspHover<CR>
    autocmd FileType python nnoremap <LocalLeader>R :<C-u>LspRename<CR>
    autocmd FileType python nnoremap <LocalLeader>n :<C-u>LspReferences<CR>
augroup END

augroup GoLspCommands
    autocmd!
    " TODO 
    " start golsp when enter python file
    autocmd BufWinEnter *.go :call lsp#enable()
    " local key mapping
    autocmd FileType go nnoremap <C-]> :<C-u>LspDefinition<CR>
    autocmd FileType go nnoremap K :<C-u>LspHover<CR>
    autocmd FileType go nnoremap <LocalLeader>R :<C-u>LspRename<CR>
    autocmd FileType go nnoremap <LocalLeader>n :<C-u>LspReferences<CR>


" vim-lsp debuging
let g:lsp_log_verbose = 1
let g:lsp_log_file = expand('~/vim-lsp.log')
