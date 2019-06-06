" Define mappings
augroup DeniteSettings
    autocmd!
    autocmd FileType denite call s:denite_my_settings()
augroup END

function! s:denite_my_settings() abort
  nnoremap <silent><buffer><expr> o 
  \ denite#do_map('do_action')
  nnoremap <silent><buffer><expr> d
  \ denite#do_map('do_action', 'delete')
  nnoremap <silent><buffer><expr> p
  \ denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><expr> q
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> i
  \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <Space>
  \ denite#do_map('toggle_select').'j'
endfunction

call denite#custom#var('file/rec', 'command', ['rg', '--files', '--glob', '!.git'])

call denite#custom#option('_', {
    \ 'prompt': '$ ',
    \ 'split': 'floating',
    \ })

