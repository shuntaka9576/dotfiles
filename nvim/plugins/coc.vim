" nodeのPATHを指定
let g:coc_node_path = expand('~/.anyenv/envs/nodenv/shims/node')
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

