"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if index(g:vundle_bundles, "tpope/vim-dispatch") >= 0
  if mapcheck("<Leader>!l", "nvo") == ""
    noremap <Leader>!l :Dispatch<CR>
  endif
  if mapcheck("<Leader>ll", "nvo") == ""
    noremap <Leader>ll :Dispatch<CR>
  endif
endif
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

