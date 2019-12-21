" --------------------------------------------------------
" Select complete settings

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
let g:coc_node_path = expand('~/.anyenv/envs/nodenv/shims/node')
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" --------------------------------------------------------
" Plugin settings

" cording settings
nmap <silent> gr <Plug>(coc-rename)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gf <Plug>(coc-references)
" Use <tab> for select selections ranges, needs server support, like: coc-tsserver, coc-python
nmap <silent> go <Plug>(coc-range-select)
xmap <silent> go <Plug>(coc-range-select)
xmap <silent> go <Plug>(coc-range-select-backword)

" coc-bookmark settings
nmap <space>bb <Plug>(coc-bookmark-annotate)
nmap <space>bn <Plug>(coc-bookmark-next)
nmap <space>bp <Plug>(coc-bookmark-prev)
nmap <space>bt <Plug>(coc-bookmark-toggle)

" coc-snippets settings
imap <C-l> <Plug>(coc-snippets-expand)
vmap <C-j> <Plug>(coc-snippets-select)
let g:coc_snippet_next = '<c-j>'
let g:coc_snippet_prev = '<c-k>'
imap <C-j> <Plug>(coc-snippets-expand-jump)

" --------------------------------------------------------
" CocList command settings

" Using CodeList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

