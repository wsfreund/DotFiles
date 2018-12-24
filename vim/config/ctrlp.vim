if index(g:vundle_bundles, "ctrlpvim/ctrlp.vim") >= 0
  "hi link CtrlSpaceNormal   airline_x_bold
  "hi link CtrlSpaceSelected airline_y
  "hi link CtrlSpaceSearch   airline_z
  "hi link CtrlSpaceStatus   airline_x
  "CtrlPNoEntries
  hi link CtrlPBufferCur airline_x_bold
  hi link CtrlPBufferCurMod airline_y_bold
  hi link CtrlPBufferInd airline_z_bold
  hi link CtrlPBufferRegion airline_a
  hi link CtrlPBufferVis airline_b
  hi link CtrlPBufferVisMod airline_c
  hi link CtrlPBufferHid airline_x
  hi link CtrlPBufferHidMod airline_y
  hi link CtrlPBufferPath airline_x
  "
  "hi link CtrlPNoEntries
  hi link CtrlPMatch airline_x
  hi link CtrlPLinePre airline_x_bold
  hi link CtrlPPrtBase airline_c
  hi link CtrlPPrtText airline_c
  hi link CtrlPPrtCursor airline_c

  let g:ctrlp_map = '<c-p>'
  let g:ctrlp_cmd = 'CtrlP'
  function! LazyP()
    let g:ctrlp_default_input = expand('<cword>')
    CtrlPTag
    let g:ctrlp_default_input = ''
  endfunction
  command! LazyP call LazyP()
  nnoremap <Leader>. :LazyP<CR>
"CtrlPNoEntries : the message when no match is found (Error)
"CtrlPMatch     : the matched pattern (Identifier)
"CtrlPLinePre   : the line prefix '>' in the match window
"CtrlPPrtBase   : the prompt's base (Comment)
"CtrlPPrtText   : the prompt's text (hl-Normal)
"CtrlPPrtCursor : the prompt's cursor when moving over the text (Constan
endif
