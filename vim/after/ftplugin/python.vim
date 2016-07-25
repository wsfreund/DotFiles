"setl efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
" this only greps first error
setl efm=%A\ \ File\ \"%f\"\\,\ line\ \%l%.%#,%Z%[%^\ ]%\\@=%m 

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

if exists("&makeprg")
  let g:mprg = &makeprg
else
  let g:mprg = ""
endif
if g:mprg ==# "make" ||
      \ g:mprg ==# "scons" ||
      \ g:mprg =~ "^python .*"
	if !filereadable(expand("%:p:h")."/Makefile")
		if !filereadable(expand("%:p:h")."/SConstruct")
			setl makeprg=python\ \${PY_MAIN:-%}
		else
			setl makeprg=scons
		endif
	else
		setl makeprg=make
	endif
endif

"let b:git_remote_name=split(system('git remote show origin -n | grep "Fetch URL:"'),'/')[-1]
let b:git_remote_name=fnamemodify(system('git remote show origin -n | grep "Fetch URL:"'),':t:s?\n??')
if b:git_remote_name!=#'ExMachina.git'
  " Return python ftplugin to 2 spaces
  setlocal expandtab shiftwidth=2 softtabstop=2 tabstop=2
endif

