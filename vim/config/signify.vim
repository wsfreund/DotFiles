"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Signify configuration
let g:signify_vcs_list = [ 'svn', 'hg' ]
let g:signify_update_on_focusgained = 1
let g:signify_update_on_bufenter = 1
if $HAS_POWERLINE == '1'
  let g:signify_sign_add = ''
  let g:signify_sign_delete = ''
  let g:signify_sign_change = ''
else
  let g:signify_sign_add               = '+'
  let g:signify_sign_delete            = '_'
  "let g:signify_sign_delete_first_line = '‾'
  let g:signify_sign_change            = '!'
endif
let g:signify_cursorhold_normal = 1
let g:signify_cursorhold_insert = 0
let g:signify_disable_by_default = 0
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
