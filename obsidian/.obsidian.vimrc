set clipboard=unnamed

exmap tabnext obcommand workspace:next-tab
nmap L :tabnext<CR>
nmap gt :tabnext<CR>
exmap tabprev obcommand workspace:previous-tab
nmap H :tabprev<CR>
nmap gT :tabprev<CR>

" Smarter o and O (inserting prefix for markdown lists)
exmap blankBelow obcommand obsidian-editor-shortcuts:insertLineBelow
exmap blankAbove obcommand obsidian-editor-shortcuts:insertLineAbove
nmap o :blankBelow<CR>i
nmap O :blankAbove<CR>i
