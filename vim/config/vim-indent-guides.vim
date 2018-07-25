if index(g:vundle_bundles, "nathanaelkane/vim-indent-guides") >= 0
  let g:indent_guides_enable_on_vim_startup = 1
  let g:indent_guides_auto_colors = 0
  autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  ctermbg=233
  autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=235
  let g:indent_guides_guide_size = 1
  let g:indent_guides_exclude_filetypes = ['help', 'nerdtree', 'tex', 'text']
endif

