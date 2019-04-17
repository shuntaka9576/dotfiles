if executable('rg')
  call denite#custom#var('file_rec', 'command',
        \ ['rg', '--files', '--glob', '!.git'])
  call denite#custom#var('grep', 'command', ['rg', '--threads', '1'])
  call denite#custom#var('grep', 'recursive_opts', [])
  call denite#custom#var('grep', 'final_opts', [])
  call denite#custom#var('grep', 'separator', ['--'])
  call denite#custom#var('grep', 'default_opts',
        \ ['--vimgrep', '--no-heading'])
else
  call denite#custom#var('file_rec', 'command',
          \ ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])
endif


nmap [denite] <Nop>
map <C-j> [denite]
nmap <silent> [denite]<C-p> :<C-u>Denite file_rec -highlight-mode-insert=Search<CR>
nmap <silent> [denite]<C-b> :<C-u>Denite buffer -highlight-mode-insert=Search<CR>
nmap <silent> [denite]<C-o> :<C-u>Denite outline -highlight-mode-insert=Search<CR>
nmap <silent> [denite]<C-v> :<C-u>call denite#start([{'name': 'file_rec', 'args': ['~/dotfiles']}]) -highlight-mode-insert=Search=Search<CR>

call denite#custom#map('normal', '<C-N>', '<denite:move_to_next_line>')
call denite#custom#map('normal', '<C-P>', '<denite:move_to_previous_line>')
call denite#custom#map('insert', '<C-N>', '<denite:move_to_next_line>')
call denite#custom#map('insert', '<C-P>', '<denite:move_to_previous_line>')
call denite#custom#map('insert', '<C-J>', '<denite:assign_next_text>')
call denite#custom#map('insert', '<C-K>', '<denite:assign_previous_text>')
call denite#custom#map('insert', '<C-S>', '<denite:do_action:split>')
call denite#custom#map('insert', '<C-I>', '<denite:do_action:vsplit>')
call denite#custom#map('insert', '<C-O>', '<denite:do_action:tabopen>')
call denite#custom#source(
\ 'file_rec', 'matchers', ['matcher_fuzzy', 'matcher_project_files', 'matcher_ignore_globs'])

call denite#custom#filter('matcher_ignore_globs', 'ignore_globs',
\ [ '.git/', '.ropeproject/', '__pycache__/',
\   'venv/','.venv/', 'images/', '*.min.*', 'img/', 'fonts/', '.mypy_cache/', '.pytest_cache/'])

command! D execute(":Denite grep -buffer-name=grep-buffer-denite")
command! Dresume execute(":Denite -resume -buffer-name=grep-buffer-denite")
command! Dnext execute(":Denite -resume -buffer-name=grep-buffer-denite -select=+1 -immediately")
command! Dprev execute(":Denite -resume -buffer-name=grep-buffer-denite -select=-1 -immediately")
nmap <silent> [denite]<C-m> :<C-u>Denite -resume -buffer-name=grep-buffer-denite<CR>
nnoremap <silent> [denite]n :<C-u>Denite -resume -buffer-name=grep-buffer-denite -select=+1 -immediately<CR>
nnoremap <silent> [denite]p :<C-u>Denite -resume -buffer-name=grep-buffer-denite -select=-1 -immediately<CR>
