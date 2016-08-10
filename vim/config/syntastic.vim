"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntastic configuration
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_enable_signs = 1
let g:syntastic_auto_loc_list = 2
let g:syntastic_enable_balloons = 1
" let g:syntastic_debug = 1
let g:syntastic_c_check_header = 1
let g:syntastic_c_no_include_search = 0
let g:syntastic_c_auto_refresh_includes = 1
" let g:syntastic_c_cflags = ''
" let g:syntastic_c_checkers=['gcc','make','splint']
if !empty($ROOTSYS)
  let g:syntastic_c_compiler_options = "-std=gnu99 -I$ROOTSYS/include/ "
endif
" let g:syntastic_c_config_file = '.config' ".syntastic_c_config
" let g:syntastic_c_remove_include_errors = 1
" let g:syntastic_c_compiler = 'clang'
let g:syntastic_cpp_check_header = 1
let g:syntastic_cpp_no_include_search = 0
"let g:syntastic_cpp_cflags = ''
let g:syntastic_cpp_auto_refresh_includes = 1
" let g:syntastic_cpp_remove_include_errors = 1
if !empty($ROOTSYS)
  let g:syntastic_cpp_compiler_options = "-std=c++11 -I$ROOTSYS/include/ "
endif
"if !empty($CMTPATH) && setCMTInclude
"  let g:syntastic_cpp_compiler_options .= g:include_path_I
"  let g:syntastic_cpp_include_dirs = g:include_path
"endif
let g:syntastic_java_checkers = []
let g:syntastic_aggregate_errors = 1
"if has("unix")
"  let g:syntastic_error_symbol = "â"
"  let g:syntastic_style_error_symbol = ">"
""  let g:syntastic_warning_symbol = "â
"  let g:syntastic_style_warning_symbol = ">"
"else
if $HAS_POWERLINE == "1"
  let g:syntastic_error_symbol = ""
  let g:syntastic_style_error_symbol = ""
  let g:syntastic_warning_symbol = ""
  let g:syntastic_style_warning_symbol = ""
endif
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
