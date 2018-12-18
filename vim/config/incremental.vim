"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if index(g:vundle_bundles, "haya14busa/incsearch.vim") >= 0
  " Incremental search configuration:
  nmap /  <Plug>(incsearch-forward)
  nmap ?  <Plug>(incsearch-backward)
  nmap g/ <Plug>(incsearch-stay)
  nmap n  <Plug>(incsearch-nohl-n)
  nmap N  <Plug>(incsearch-nohl-N)
  nmap *  <Plug>(incsearch-nohl-*)
  nmap #  <Plug>(incsearch-nohl-#)
  nmap g* <Plug>(incsearch-nohl-g*)
  nmap g# <Plug>(incsearch-nohl-g#)
  let g:incsearch#auto_nohlsearch = 1
endif
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
