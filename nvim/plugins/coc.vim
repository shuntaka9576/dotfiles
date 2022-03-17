" nodeのPATHを指定

let g:os = substitute(system('arch -arm64e uname'), '\n', '', '')
let g:arch = substitute(system('arch -arm64e uname -m'), '\n', '', '')

if g:os ==# 'Darwin' && g:arch ==# 'x86_64'
  let g:coc_node_path = expand('~/.anyenv/envs/nodenv/shims/node')
elseif g:os ==# 'Darwin' && g:arch ==# 'arm64'
  let g:coc_node_path = expand('/usr/local/bin/node')
endif

" コード補完時にEnterで確定した際に改行しない
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
" リファクタリング機能
nmap <silent>gr <Plug>(coc-rename)
" コードジャンプ
nmap <silent>gd <Plug>(coc-definition)
" 型情報の表示
nmap <silent>gy <Plug>(coc-type-definition)
" 実装の表示
nmap <silent>gi <Plug>(coc-implementation)
" リファレンス表示
nmap <silent>gf <Plug>(coc-references)
" diagnosticジャンプ
nmap <silent><C-n> <Plug>(coc-diagnostic-next)
nmap <silent><C-p> <Plug>(coc-diagnostic-prev)
" 警告の一覧表示
nnoremap <silent><space>a :<C-u>CocList diagnostics<cr>
nnoremap <silent><space>t :CocList floaterm<CR>

