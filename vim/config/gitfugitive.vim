"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Gitfugitive configuration 
" Protect against git diff
au BufWinLeave ?* silent! if @% !~ '.git/' mkview | endif
au BufWinEnter ?* silent! if @% !~ '.git/' loadview | endif
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
