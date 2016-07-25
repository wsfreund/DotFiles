if !filereadable(expand("%:p:h")."/Makefile")
	if !filereadable(expand("%:p:h")."/SConstruct")
    setl makeprg=pdflatex\ -file-line-error\ -interaction=nonstopmode\ %\ \&\&\ bibtex\ %<\;pdflatex\ -file-line-error\ -interaction=nonstopmode\ %\ \&\&\ pdflatex\ -file-line-error\ -interaction=nonstopmode\ %\ \&\&\ open\ %<.pdf\;\ pdflatex\ -file-line-error\ -interaction=nonstopmode\ %
  else
    setl makeprg=scons
  endif
else
  setl makeprg=make
endif
setl errorformat=%f:%l:\ %m
"autocmd QuickfixCmdPost * :!open %<.pdf
