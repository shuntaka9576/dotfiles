" tabstop タブ幅
" expandtab タブを半角スペースへ変更
" shifttab vimが自動生成するタブ幅
augroup MyTabStop
    autocmd!
    autocmd BufNewFile,BufRead *.ts        setlocal tabstop=2 shiftwidth=2 expandtab 
    autocmd BufNewFile,BufRead *.md        setlocal tabstop=4 shiftwidth=4
    autocmd BufNewFile,BufRead *.go        setlocal tabstop=4 shiftwidth=4
    autocmd BufNewFile,BufRead *.vim       setlocal tabstop=4 shiftwidth=4
    autocmd BufNewFile,BufRead Makefile    setlocal noexpandtab
    autocmd BufNewFile,BufRead *.yml       setlocal tabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.toml      setlocal tabstop=4 shiftwidth=4
augroup END
