"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Neocomplete settings
let g:deoplete#enable_at_startup = 1
call deoplete#custom#option({
  \ 'auto_complete_delay': 200,
  \ 'min_pattern_length' : 2,
  \ 'max_list' : 20,
  \ 'smart_case': v:true,
  \ })
autocmd FileType tex call deoplete#custom#buffer_option('auto_complete', v:false)
" NeoCompleteSetFileType
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
