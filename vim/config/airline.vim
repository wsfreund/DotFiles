"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Airline configuration
if $HAS_POWERLINE == "1"
  let g:airline_powerline_fonts = 1
else
  let g:airline_powerline_fonts = 0
endif
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
if g:airline_powerline_fonts != 1
  let g:airline_left_sep = '▶'
  let g:airline_right_sep = '◀'
  " let g:airline_left_alt_sep = '>'
  " let g:airline_left_sep = '»'
  " let g:airline_right_alt_sep = '<'
  " let g:airline_right_sep = '«'
  let g:airline_symbols.crypt = '🔒'
  "let g:airline_symbols.linenr = '␊'
  "let g:airline_symbols.linenr = '␤'
  let g:airline_symbols.linenr = '¶'
  let g:airline_symbols.branch = '⎇'
  "let g:airline_symbols.paste = 'ρ'
  "let g:airline_symbols.paste = 'Þ'
  "let g:airline_symbols.paste = '∥'
  let g:airline_symbols.notexists = '∄'
  let g:airline_symbols.whitespace = 'Ξ'
endif
let g:airline_theme = 'wombat'
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_tabs = 1
let g:airline#extensions#tabline#tab_nr_type = 1
let g:airline#extensions#tabline#fnametruncate = 0
let g:airline#extensions#tabline#fnamecollapse = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#tabline#fnamemod = ':t '
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:airline#extensions#whitespace#enabled = 0
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:airline#extensions#branch#enabled = 1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:airline#extensions#virtualenv#enabled = 1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:airline#extensions#tagbar#enabled = 1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:airline#extensions#syntastic#enabled = 1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:airline#extensions#hunks#enabled = 1
let g:airline#extensions#hunks#non_zero_only = 0
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:airline#extensions#wordcount#enabled = 1
let g:airline#extensions#wordcount#filetypes=''
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:airline#extensions#tagbar#flags='f'
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:airline#extensions#csv#column_display = 'Name'
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:airline#extensions#tmuxline#enabled = 0
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"call airline#parts#define_minwidth('hi', 50)
"call airline#parts#define_condition('foo', 'getcwd() =~ "work_dir"')
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function GetHighlighPlace()
  return "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
    \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
    \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"
endfunction
function GetHighlighShort()
  let l:hi = "hi<" . synIDattr(synID(line("."),col("."),1),"name") . ">"
  if l:hi != 'hi<>'
    return l:hi
  endif
  let l:lo = "tr<" . synIDattr(synID(line("."),col("."),0),"name") . ">"
  if l:lo != 'tr<>'
    return l:lo
  endif
  let l:name = "lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"
  if l:name != 'lo<>'
    return l:name
  endif
  return ""
endfunction
function! AirlineInit()
  let g:airline_section_b = g:airline_section_b.'%{airline#util#append(GetHighlighShort(),0)}'
  if g:has_powerline
    let g:obsession_symbol_active=''
    let g:obsession_symbol_paused=''
    let g:obsession_symbol_unknown=''
  else
    let g:obsession_symbol_active='✔'
    let g:obsession_symbol_paused='✘'
    let g:obsession_symbol_unknown='�'
  endif
  let g:airline_section_x = substitute(airline#section#create_right(['tagbar',
          \'%{ObsessionStatus('''.g:obsession_symbol_active.''','''
            \.g:obsession_symbol_paused.''','''
            \.g:obsession_symbol_unknown.''')}'
            \.g:airline_symbols['space'].'Ob'
            \.g:airline_symbols['space'].g:airline_right_alt_sep.g:airline_symbols['space'], 
          \'filetype']),
        \ g:airline_right_alt_sep.g:airline_symbols['space'].'\(%{ObsessionStatus\)',
        \ '\1','')
  "let g:airline_section_z = airline#section#create([ 'windowswap', '%3p%% ', 'linenr', ':%3v '])
endfunction
autocmd User AirlineAfterInit call AirlineInit()
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
