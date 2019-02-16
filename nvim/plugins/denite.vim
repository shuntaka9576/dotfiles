nmap [denite] <Nop>
map <C-j> [denite]

nmap <silent> [denite]<C-p> :<C-u>Denite file_rec -highlight-mode-insert=Search<CR>
nmap <silent> [denite]<C-b> :<C-u>Denite buffer -highlight-mode-insert=Search<CR>
nmap <silent> [denite]<C-o> :<C-u>Denite outline -highlight-mode-insert=Search<CR>
nmap <silent> [denite]<C-v> :<C-u>call denite#start([{'name': 'file_rec', 'args': ['~/.dotfiles']}]) -highlight-mode-insert=Search=Search<CR>

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
\   'venv/', 'images/', '*.min.*', 'img/', 'fonts/'])

command! D execute(":Denite grep -buffer-name=grep-buffer-denite")
command! Dresume execute(":Denite -resume -buffer-name=grep-buffer-denite")
command! Dnext execute(":Denite -resume -buffer-name=grep-buffer-denite -select=+1 -immediately")
command! Dprev execute(":Denite -resume -buffer-name=grep-buffer-denite -select=-1 -immediately")
