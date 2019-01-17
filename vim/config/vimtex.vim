if index(g:vundle_bundles, "lervag/vimtex") >= 0
  if !exists('g:neocomplete#sources#omni#input_patterns')
    let g:neocomplete#sources#omni#input_patterns = {}
  endif
  let g:neocomplete#sources#omni#input_patterns.tex =
        \ g:vimtex#re#neocomplete
  let g:vimtex_fold_enabled = 1
  "let g:vimtex_latexmk_continuous = 0
  ""let g:vimtex_latexmk_build_dir='aux_compile'
  "let g:vimtex_latexmk_options='-pdf -pdflatex="pdflatex -shell-escape -interaction=nonstopmode"'
  let g:vimtex_quickfix_autoclose_after_keystrokes = 1
  let g:vimtex_quickfix_autojump = 0
  let g:vimtex_quickfix_mode = 2
  au BufEnter *.tex nnoremap <Leader>oo :VimtexCompileOutput<CR>
  au BufEnter *.tex nnoremap <Leader>ss :VimtexStatus<CR>
  au BufEnter *.tex nnoremap <Leader>ll :VimtexCompile<CR>
  let g:vimtex_quickfix_latexlog = {
        \ 'underfull' : 0,
        \ 'overfull' : 0
        \ }
  " jobs default
	" let g:vimtex_complete_bib = {'simple' : 1, 'recursive' : 0, 'menu_fmt' : ''} 
	let g:vimtex_complete_bib = {'enabled':0}
  let g:vimtex_compiler_latexmk = {
        \ 'continuous' : 0
        \ }
  " let g:vimtex_compiler_latexmk = {
  "      \ 'name' : 'latexmk',
  "      \ 'executable' : 'latexmk',
  "      \ 'backend' :  'jobs',
  "      \ 'root' : '',
  "      \ 'target' : '',
  "      \ 'target_path' : '',
  "      \ 'background' : 0,
  "      \ 'build_dir' : '',
  "      \ 'callback' : 1,
  "      \ 'continuous' : 0,
  "      \ 'output' : 'latexmk_output.log',
  "      \ 'options' : [
  "      \   '-verbose',
  "      \   '-file-line-error',
  "      \   '-synctex=1',
  "      \   '-interaction=nonstopmode',
  "      \ ],
  "      \ 'shell' : fnamemodify(&shell, ':t'),
  "      \}
endif
