set clipboard=unnamed

exmap tabnext obcommand workspace:next-tab
nmap L :tabnext<CR>
nmap gt :tabnext<CR>
exmap tabprev obcommand workspace:previous-tab
nmap H :tabprev<CR>
nmap gT :tabprev<CR>

" window controls
exmap wq obcommand workspace:close
exmap q obcommand workspace:close

exmap focusRight obcommand editor:focus-right
nmap <C-l> :focusRight<CR>

exmap focusLeft obcommand editor:focus-left
nmap <C-h> :focusLeft<CR>

exmap focusTop obcommand editor:focus-top
nmap <C-k> :focusTop<CR>

exmap focusBottom obcommand editor:focus-bottom
nmap <C-j> :focusBottom<CR>

exmap splitVertical obcommand workspace:split-vertical
nmap <C-v> :splitVertical<CR>

exmap splitHorizontal obcommand workspace:split-horizontal
nmap <C-s> :splitHorizontal<CR>

" Smarter o and O (inserting prefix for markdown lists)
exmap blankBelow obcommand obsidian-editor-shortcuts:insertLineBelow
exmap blankAbove obcommand obsidian-editor-shortcuts:insertLineAbove
nmap o :blankBelow<CR>i
nmap O :blankAbove<CR>i
