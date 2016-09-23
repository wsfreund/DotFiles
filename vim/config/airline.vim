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
  return "hi<->"
endfunction
function! AirlineInit()
  let l:start = get(g:,'airline_section_b','')
  "echoerr '"' . l:start . '"'
  "if l:start == ''
    let g:airline_section_b = airline#section#create_left([l:start,'%{GetHighlighShort()}'])
  "else
  "  let g:airline_section_b = airline#section#create(['%{GetHighlighShort()}'])
  "endif
endfunction
autocmd User AirlineAfterInit call AirlineInit()
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
