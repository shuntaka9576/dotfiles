" Denite用プレフィックス
nmap [denite] <Nop>
map <C-j> [denite]

" プロジェクト内のファイル検索
nmap <silent> [denite]<C-P> :<C-u>Denite file_rec -highlight-mode-insert=Search<CR>
" バッファに展開中のファイル検索
nmap <silent> [denite]<C-B> :<C-u>Denite buffer -highlight-mode-insert=Search<CR>
" ファイル内の関数/クラス等の検索
nmap <silent> [denite]<C-O> :<C-u>Denite outline -highlight-mode-insert=Search<CR>
" dotfiles配下をカレントにしてfile_rec起動
nmap <silent> [denite]<C-V> :<C-u>call denite#start([{'name': 'file_rec', 'args': ['~/.dotfiles']}]) -highlight-mode-insert=Search=Search<CR>

" 上下移動を<C-N>, <C-P>
call denite#custom#map('normal', '<C-N>', '<denite:move_to_next_line>')
call denite#custom#map('normal', '<C-P>', '<denite:move_to_previous_line>')
call denite#custom#map('insert', '<C-N>', '<denite:move_to_next_line>')
call denite#custom#map('insert', '<C-P>', '<denite:move_to_previous_line>')
" 入力履歴移動を<C-J>, <C-K>
call denite#custom#map('insert', '<C-J>', '<denite:assign_next_text>')
call denite#custom#map('insert', '<C-K>', '<denite:assign_previous_text>')
" 横割りオープンを`<C-S>`
call denite#custom#map('insert', '<C-S>', '<denite:do_action:split>')
" 縦割りオープンを`<C-I>`
call denite#custom#map('insert', '<C-I>', '<denite:do_action:vsplit>')
" タブオープンを`<C-O>`
call denite#custom#map('insert', '<C-O>', '<denite:do_action:tabopen>')

" file_rec検索時にfuzzymatchを有効にし、検索対象から指定のファイルを除外
call denite#custom#source(
\ 'file_rec', 'matchers', ['matcher_fuzzy', 'matcher_project_files', 'matcher_ignore_globs'])

" 検索対象外のファイル指定
call denite#custom#filter('matcher_ignore_globs', 'ignore_globs',
\ [ '.git/', '.ropeproject/', '__pycache__/',
\   'venv/', 'images/', '*.min.*', 'img/', 'fonts/'])
" grepする
command! Dgrep execute(":Denite grep -buffer-name=grep-buffer-denite")
" Denite grep結果を再表示する
command! Dresume execute(":Denite -resume -buffer-name=grep-buffer-denite")
" resumeしたgrep結果の次の行の結果へ飛ぶ
command! Dnext execute(":Denite -resume -buffer-name=grep-buffer-denite -select=+1 -immediately")
" resumeしたgrep結果の前の行の結果へ飛ぶ
command! Dprev execute(":Denite -resume -buffer-name=grep-buffer-denite -select=-1 -immediately")
