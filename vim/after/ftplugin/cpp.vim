if !filereadable(expand("%:p:h")."/Makefile")
  setlocal makeprg=g++\ -Wall\ -Wextra\ -std=c++0x\ -o\ %<\ %
endif
