let g:quickrun_config = {
    \ '_' : {
        \ 'runner' : 'vimproc',
        \ 'runner/vimproc/updatetime' : 40,
        \ 'outputter' : 'error',
        \ 'outputter/error/success' : 'buffer',
        \ 'outputter/error/error'   : 'quickfix',
        \ 'outputter/buffer/split' : ':botright 8sp',
    \ },
    \ 'python' : {
        \ 'command': 'python3'
    \ },
    \ 'julia' : {
        \ 'command': 'julia'
    \ },
\ }

" Keymap
let g:quickrun_no_default_key_mappings = 1
" Running with close quickfix and save file
nnoremap <Leader>r :<C-U>QuickRun<CR>
nnoremap <Leader>t :<C-U>QuickRun -args
" xnoremap <Leader>r gv:<C-U>QuickRun<CR>

" Stop quickrun is [C-c]
nnoremap <expr><silent> <C-c> quickrun#is_running() ? quickrun#sweep_sessions() : "\<C-c>"

autocmd BufNewFile,BufRead *.crs setf rust
autocmd BufNewFile,BufRead *.rs g:quickrun_config.rust = {'exec': 'cargo run'}
autocmd BufNewFile,BufRead *.crs g:quickrun_config.rust = {'exec': 'cargo script %s -- %a'}
