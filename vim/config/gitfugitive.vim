"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Gitfugitive configuration 
" Protect against git diff
if index(g:vundle_bundles, "tpope/vim-fugitive") >= 0
  au BufWinLeave ?* silent! if @% !~ '.git/' mkview | endif
  au BufWinEnter ?* silent! if @% !~ '.git/' loadview | endif
endif
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
