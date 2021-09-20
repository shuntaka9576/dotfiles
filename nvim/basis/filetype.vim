" tabstop タブ幅
" expandtab タブを半角スペースへ変更
" shifttab vimが自動生成するタブ幅
augroup MyTabStop
  autocmd!
  autocmd BufNewFile,BufRead *.ts setlocal tabstop=2 shiftwidth=2 expandtab
  autocmd BufNewFile,BufRead *.c setlocal tabstop=2 shiftwidth=2 expandtab
  autocmd BufNewFile,BufRead *.cpp setlocal tabstop=2 shiftwidth=2 expandtab
  autocmd BufNewFile,BufRead *.tsx setlocal tabstop=2 shiftwidth=2 expandtab
  autocmd BufNewFile,BufRead *.html setlocal tabstop=2 shiftwidth=2 expandtab
  autocmd BufNewFile,BufRead *.css setlocal tabstop=2 shiftwidth=2 expandtab
  autocmd BufNewFile,BufRead *.scss setlocal tabstop=2 shiftwidth=2 expandtab
  autocmd BufNewFile,BufRead *.md setlocal tabstop=4 shiftwidth=4
  autocmd BufNewFile,BufRead *.go setlocal tabstop=4 shiftwidth=4
  autocmd BufNewFile,BufRead *.vim setlocal tabstop=2 shiftwidth=2 expandtab
  autocmd BufNewFile,BufRead Makefile setlocal noexpandtab
  autocmd BufNewFile,BufRead *.yml setlocal tabstop=2 shiftwidth=2
  autocmd BufNewFile,BufRead *.toml setlocal tabstop=2 shiftwidth=2 expandtab
  autocmd BufNewFile,BufRead *.dart setlocal tabstop=2 shiftwidth=2 expandtab
augroup END

" Markdownを折りたたむ
" function! FoldMarkdown(lnum)
"   let line = getline(a:lnum)
"   let next = getline(a:lnum + 1)
" 
"   if line =~ '^#\{1}[^#]\+'
"     return 1
"   elseif next =~ '^#\{1}[^#]\+'
"     return '<1'
"   elseif line =~ '^#\{2}[^#]\+'
"     return 2
"   elseif next =~ '^#\{2}[^#]\+'
"     return '<2'
"   elseif line =~ '^#\{3}[^#]\+'
"     return 3
"   elseif next =~ '^#\{3}[^#]\+'
"     return '<3'
"   endif
" 
"   return '='
" endfunction
" 
" set foldmethod=expr foldexpr=FoldMarkdown(v:lnum)
