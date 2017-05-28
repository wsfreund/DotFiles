"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Promptline configuration:
let zsh_py_env_str = {
      \'function_name': 'zsh_py_env_str',
      \'function_body': [
        \'function zsh_py_env_str {',
        \'  local version',
        \'  version=$(pyenv version-name 2>/dev/null) || return 1',
        \'  printf "-%s" "$version"',
        \'}']}

let zsh_get_athena_project_str = {
      \'function_name': 'zsh_get_athena_project_str',
      \'function_body': [
        \'function zsh_get_athena_project_str {',
        \'  test -n "$AtlasProject" || return 1',
        \'  echo "-$AtlasProject"',
        \'}']}

let zsh_get_athena_version_str = {
      \'function_name': 'zsh_get_athena_version_str',
      \'function_body': [
        \'function zsh_get_athena_version_str {',
        \'  test -n "$AtlasVersion" || return 1',
        \'  echo "$AtlasVersion"',
        \'}']}

let zsh_get_rootcore_release_str = {
      \'function_name': 'zsh_get_rootcore_release_str',
      \'function_body': [
        \'function zsh_get_rootcore_release_str {',
        \'  local rdir; local project;',
        \'  rdir=$(echo $ROOTCOREDIR)',
        \'  test -n "$rdir" || return 1',
        \'  if test "${rdir#*nightlies}" != "${rdir}"; then',
        \'    printf "-nightly"',
        \'  else',
        \'    project=$(basename $(dirname $(dirname "$rdir")))',
        \'    printf "-%s" "$project"',
        \'  fi',
        \'}']}

let zsh_get_rootcore_version_str = {
      \'function_name': 'zsh_get_rootcore_version_str',
      \'function_body': [
        \'function zsh_get_rootcore_version_str {',
        \'  local rdir; local version;',
        \'  rdir=$(echo $ROOTCOREDIR)',
        \'  test -n "$rdir" || return 1',
        \'  version=$(basename $(dirname "$rdir"))',
        \'  printf "%s" "$version"',
        \'}']}

let zsh_get_panda_version_str = {
      \'function_name': 'zsh_get_panda_version_str',
      \'function_body': [
        \'function zsh_get_panda_version_str {',
        \'  local version;',
        \'  version=$(echo $ATLAS_LOCAL_PANDACLI_VERSION)',
        \'  test -n "$version" || return 1',
        \'  printf "-%s" "$version"',
        \'}']}

let zsh_get_rucio_version_str = {
      \'function_name': 'zsh_get_rucio_version_str',
      \'function_body': [
        \'function zsh_get_rucio_version_str {',
        \'  local version;',
        \'  version=$(echo $ATLAS_LOCAL_RUCIOCLIENTS_VERSION)',
        \'  test -n "$version" || return 1',
        \'  printf "-%s" "$version"',
        \'}']}

if exists("promptline#*")
  let g:promptline_preset = {
          \'a' : [ promptline#slices#host({'only_if_ssh':1}), promptline#slices#user() ],
          \'b' : [ '%*' ],
          \'c' : [ promptline#slices#cwd({'dir_limit':3}) ],
          \'x' : [ promptline#slices#jobs(), promptline#slices#vcs_branch({'svn':1}) ],
          \'y' : [ zsh_get_athena_project_str, zsh_get_athena_version_str, 
                   \zsh_get_rootcore_release_str, zsh_get_rootcore_version_str, 
                   \zsh_get_panda_version_str, zsh_get_rucio_version_str,
                   \zsh_py_env_str ],
          \'z' : [ '$(git rev-parse --short HEAD 2>/dev/null)', promptline#slices#git_status() ],
          \'warn' : [ promptline#slices#last_exit_code() ],
          \'options' : {
            \'left_sections' : [ 'a', 'b','c' ],
            \'right_sections' : [ 'warn', 'x', 'y','z' ],
            \'left_only_sections' : ['y', 'x', 'z', 'a', 'b', 'c', 'warn' ]}}
  let airline#extensions#promptline#color_template='insert'
endif
"let g:airline#extensions#promptline#enabled = 0
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
