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

call denite#custom#var('file/rec', 'command', ['rg', '--files', '--hidden', '--glob', '!.git'])
call denite#custom#var('grep', 'command', ['rg', '--hidden'])
call denite#custom#var('grep', 'default_opts',
      \ ['-i', '--vimgrep', '--no-heading'])
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', [])

call denite#custom#option('_', {
      \ 'prompt': '$ ',
      \ 'split': 'floating',
      \ })

" See https://github.com/Shougo/dein.vim/issues/342
call denite#custom#source('file/rec,file_mru,file/old,buffer,directory/rec,directory_mru', 'converters', ['devicons_denite_converter'])

