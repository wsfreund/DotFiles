if index(g:vundle_bundles, "vim-ctrlspace/vim-ctrlspace") >= 0
  let g:CtrlSpaceSymbols = {}
  if executable("ag")
    let g:CtrlSpaceGlobCommand = 'ag -l --nocolor -g ""'
  endif
  let g:CtrlSpaceUseMouseAndArrowsInTerm=1
  "let g:CtrlSpaceSaveWorkspaceOnSwitch = 1
  "let g:CtrlSpaceSaveWorkspaceOnExit = 1
  let g:CtrlSpaceLoadLastWorkspaceOnStart = 1
  "nnoremap <silent><C-p> :CtrlSpace O<CR>
  nnoremap <silent>gB :CtrlSpaceGoUp<CR>
  nnoremap <silent>gb :CtrlSpaceGoDown<CR>
  let g:CtrlSpaceProjectRootMarkers = [
       \ ".git",
       \ ".hg",
       \ ".svn",
       \ ".bzr",
       \ "_darcs",
       \ "CVS",
       \ ".ctrlspace_workspace" ]
  hi link CtrlSpaceNormal   airline_x_bold
  hi link CtrlSpaceSelected airline_y
  hi link CtrlSpaceSearch   airline_z
  hi link CtrlSpaceStatus   airline_x
endif

