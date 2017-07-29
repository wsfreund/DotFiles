" Vim compiler file
" Compiler:    Python     
" Maintainer:   Christoph Herzog <ccf.herzog@gmx.net>
" Last Change:  2002 Nov 9
" CompilerSet makeprg=python
" CompilerSet makeprg=*.py

if exists("current_compiler")
  finish
endif
let current_compiler = "python"

let s:cpo_save = &cpo
set cpo-=C

setlocal makeprg=python\ %

function! s:InnermostExceptionInQFList()
  let s:num = 0
  for item in getqflist()
    if item.lnum > 0
      let s:num += 1
    endif
  endfor
  if s:num > 0
    try
      silent execute(s:num . 'cnext')
    catch /E553:/
      " E553: No more elements
    endtry
  endif
  silent execute('wincmd w')
endfunction

autocmd! QuickfixCmdPost * call s:InnermostExceptionInQFList()

"the last line: \%-G%.%# is meant to suppress some
"late error messages that I found could occur e.g.
"with wxPython and that prevent one from using :clast
"to go to the relevant file and line of the traceback.
setlocal errorformat=
  \%A\ \ File\ \"%f\"\\\,\ line\ %l\\\,%m,
  \%C\ \ \ \ %.%#,
  \%+Z%.%#Error\:\ %.%#,
  \%A\ \ File\ \"%f\"\\\,\ line\ %l,
  \%+C\ \ %.%#,
  \%-C%p^,
  \%Z%m,
  \%-G%.%#

let &cpo = s:cpo_save
unlet s:cpo_save

"vim: ft=vim
