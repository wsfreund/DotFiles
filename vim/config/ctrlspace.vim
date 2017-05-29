let g:CtrlSpaceSymbols = {}
if index(g:vundle_bundles, "vim-ctrlspace/vim-ctrlspace") >= 0
  if executable("ag")
    let g:CtrlSpaceGlobCommand = 'ag -l --nocolor -g ""'
  endif
  let g:CtrlSpaceUseMouseAndArrowsInTerm=1
  "let g:CtrlSpaceSaveWorkspaceOnSwitch = 1
  "let g:CtrlSpaceSaveWorkspaceOnExit = 1
  let g:CtrlSpaceLoadLastWorkspaceOnStart = 1
  nnoremap <silent><C-p> :CtrlSpace O<CR>
  nnoremap <silent>gB :CtrlSpaceGoUp<CR>
  nnoremap <silent>gb :CtrlSpaceGoDown<CR>
endif

