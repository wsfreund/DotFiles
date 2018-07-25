if index(g:vundle_bundles, "Yggdroot/indentLine") >= 0
  let g:indentLine_enabled=0
  "let g:indentLine_setConceal = 0
  "let g:indentLine_leadingSpaceEnabled=0
  "let g:indentLine_concealcursor='nvic'
  "let g:indentLine_conceallevel = 2
  "let g:indentLine_char='│'
  "let g:indentLine_first_char='│'
  "let g:indentLine_showFirstIndentLevel=1
  ""let g:indentLine_fileTypeExclude = ["text","tex"]
  "let g:indentLine_bufTypeExclude = ['help', 'terminal']
  "let g:indentLine_fileType = ['c', 'cpp', 'python']
  "let g:indentLine_bufNameExclude = ['_.*', 'NERD_tree.*']
  let g:indentLine_setColors = 1
  let g:indentLine_color_term = 136
  "au FileType python,c,cpp :IndentLinesEnable
endif
