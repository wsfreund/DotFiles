"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if index(g:vundle_bundles, "vim-airline/vim-airline") >= 0
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
  let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
  "let g:airline#extensions#tabline#fnamemod = ':t '
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
  let g:airline#extensions#hunks#only_when_any_changed = 1
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
  function GetWeather()
    if !exists("g:weather_ptime")
      let g:weather_ptime = localtime()
      let g:weather = system('/Users/wsfreund/DotFiles/tmux/weather_shell.sh')
    endif
    let l:ctime = localtime()
    let l:delta = l:ctime - g:weather_ptime
    if l:delta > 60
      let g:weather_ptime = localtime()
      let g:weather = system('/Users/wsfreund/DotFiles/tmux/weather_shell.sh')
    endif
    return g:weather
  endfunction
  "function GetCpu()
  "  if !exists("g:cpu_ptime")
  "    let g:cpu_ptime = localtime()
  "    let g:cpu = system('/Users/wsfreund/DotFiles/tmux/tmux-mem-cpu-load')
  "  endif
  "  let l:ctime = localtime()
  "  let l:delta = l:ctime - g:cpu_ptime
  "  if l:delta > 0
  "    let g:cpu_ptime = localtime()
  "    let g:cpu = system('/Users/wsfreund/DotFiles/tmux/tmux-mem-cpu-load')
  "  endif
  "  return g:cpu
  "endfunction
  function! AirlineInit()
    if !empty(g:airline_section_b)
      let g:airline_section_b = g:airline_section_b.'%{airline#util#append(GetHighlighShort(),0)}'
    else
      let g:airline_section_b = '%{GetHighlighShort()}'
    endif
    "if !empty(g:airline_section_z)
    "  "let g:airline_section_z = '%{airline#util#prepend(GetWeather(),0)}%{airline#util#prepend(GetCpu(),0)}'.g:airline_section_z
    "  let g:airline_section_z = '%{airline#util#prepend(GetWeather(),0)}'.g:airline_section_z
    "else
    "  let g:airline_section_z = '%{GetWeather()}'
    "endif
    if g:has_powerline
      let g:obsession_symbol_active=''
      let g:obsession_symbol_paused=''
      let g:obsession_symbol_unknown=''
    else
      let g:obsession_symbol_active='✔'
      let g:obsession_symbol_paused='✘'
      let g:obsession_symbol_unknown='�'
    endif
    "let g:airline_section_x = substitute(airline#section#create_right(['tagbar',
    "        \'%{ObsessionStatus('''.g:obsession_symbol_active.''','''
    "          \.g:obsession_symbol_paused.''','''
    "          \.g:obsession_symbol_unknown.''')}'
    "          \.g:airline_symbols['space'].'Ob'
    "          \.g:airline_symbols['space'].g:airline_right_alt_sep.g:airline_symbols['space'],
    "        \'filetype']),
    "      \ g:airline_right_alt_sep.g:airline_symbols['space'].'\(%{ObsessionStatus\)',
    "      \ '\1','')
    "let g:airline_section_z = airline#section#create([ 'windowswap', '%3p%% ', 'linenr', ':%3v '])
  endfunction
  autocmd User AirlineAfterInit call AirlineInit()
	function! WombatCtrlP()
	let g:airline#themes#wombat#palette.ctrlp = airline#extensions#ctrlp#generate_color_map(
	\ [ '#CAE682' , '#242424' , 192 , 235 , ''] ,
	\ [ '#CAE682' , '#32322F' , 192 , 238 , ''] ,
	\ [ '#141413' , '#CAE682' , 232 , 192 , ''] )
	\ | :AirlineRefres
  endfunction
  autocmd VimEnter * silent! call WombatCtrlP()
endif
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
