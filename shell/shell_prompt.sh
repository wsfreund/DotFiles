#
# This shell prompt config file was created by promptline.vim
#
function __promptline_vcs_branch {
  local branch
  local branch_symbol=" "

  # git
  if hash git 2>/dev/null; then
    if branch=$( { git symbolic-ref --quiet HEAD || git rev-parse --short HEAD; } 2>/dev/null ); then
      branch=${branch##*/}
      printf "%s" "${branch_symbol}${branch:-unknown}"
      return
    fi
  fi

  # svn
  if hash svn 2>/dev/null; then
    local svn_info
    if svn_info=$(svn info 2>/dev/null); then
      local svn_url=${svn_info#*URL:\ }
      svn_url=${svn_url/$'\n'*/}

      local svn_root=${svn_info#*Repository\ Root:\ }
      svn_root=${svn_root/$'\n'*/}

      if [[ -n $svn_url ]] && [[ -n $svn_root ]]; then
        # https://github.com/tejr/dotfiles/blob/master/bash/bashrc.d/prompt.bash#L179
        branch=${svn_url/$svn_root}
        branch=${branch#/}
        branch=${branch#branches/}
        branch=${branch%%/*}

        printf "%s" "${branch_symbol}${branch:-unknown}"
        return
      fi
    fi
  fi

  return 1
}
function zsh_py_env_str {
  local version
  version=$(pyenv version-name 2>/dev/null) || return 1
  printf "-%s" "$version"
}

function __promptline_git_status {
  [[ -n "$PROMPT_LINE_IGNORE_GIT" ]] && return 1

  #local TIME=$(date +%s%3N);

  [[ $(git rev-parse --is-inside-work-tree 2>/dev/null) == true ]] || return 1

  local added_symbol="●"
  local unmerged_symbol="✗"
  local modified_symbol="+"
  local clean_symbol="✔"
  local has_untracked_files_symbol="…"

  local ahead_symbol="↑"
  local behind_symbol="↓"

  local unmerged_count=0 modified_count=0 has_untracked_files=0 added_count=0 is_clean=""

  set -- $(git rev-list --left-right --count @{upstream}...HEAD 2>/dev/null)
  local behind_count=$1
  local ahead_count=$2

  # Added (A), Copied (C), Deleted (D), Modified (M), Renamed (R), changed (T), Unmerged (U), Unknown (X), Broken (B)
  while read line; do
    case "$line" in
      M*) modified_count=$(( $modified_count + 1 )) ;;
      U*) unmerged_count=$(( $unmerged_count + 1 )) ;;
    esac
  done < <(git diff --name-status)

  while read line; do
    case "$line" in
      *) added_count=$(( $added_count + 1 )) ;;
    esac
  done < <(git diff --name-status --cached)

  if [ -n "$(git ls-files --others --exclude-standard)" ]; then
    has_untracked_files=1
  fi

  if [ $(( unmerged_count + modified_count + has_untracked_files + added_count )) -eq 0 ]; then
    is_clean=1
  fi

  local leading_whitespace=""
  [[ $ahead_count -gt 0 ]]         && { printf "%s" "$leading_whitespace$ahead_symbol$ahead_count"; leading_whitespace=" "; }
  [[ $behind_count -gt 0 ]]        && { printf "%s" "$leading_whitespace$behind_symbol$behind_count"; leading_whitespace=" "; }
  [[ $modified_count -gt 0 ]]      && { printf "%s" "$leading_whitespace$modified_symbol$modified_count"; leading_whitespace=" "; }
  [[ $unmerged_count -gt 0 ]]      && { printf "%s" "$leading_whitespace$unmerged_symbol$unmerged_count"; leading_whitespace=" "; }
  [[ $added_count -gt 0 ]]         && { printf "%s" "$leading_whitespace$added_symbol$added_count"; leading_whitespace=" "; }
  [[ $has_untracked_files -gt 0 ]] && { printf "%s" "$leading_whitespace$has_untracked_files_symbol"; leading_whitespace=" "; }
  [[ $is_clean -gt 0 ]]            && { printf "%s" "$leading_whitespace$clean_symbol"; leading_whitespace=" "; }

  #local END_TIME=$(date +%s%3N);

  #test "$(($END_TIME - $TIME))" -gt 200 && export PROMPT_LINE_IGNORE_GIT="1";
}

function __promptline_last_exit_code {

  [[ $last_exit_code -gt 0 ]] || return 1;

  printf "%s" "$last_exit_code"
}
function __promptline_ps1 {
  local slice_prefix slice_empty_prefix slice_joiner slice_suffix is_prompt_empty=1

  # section "y" header
  slice_prefix="${y_bg}${sep}${y_fg}${y_bg}${space}" slice_suffix="$space${y_sep_fg}" slice_joiner="${y_fg}${y_bg}${alt_sep}${space}" slice_empty_prefix="${y_fg}${y_bg}${space}"
  [ $is_prompt_empty -eq 1 ] && slice_prefix="$slice_empty_prefix"
  # section "y" slices
  __promptline_wrapper "$(zsh_get_athena_project_str)" "$slice_prefix" "$slice_suffix" && { slice_prefix="$slice_joiner"; is_prompt_empty=0; }
  __promptline_wrapper "$(zsh_get_athena_version_str)" "$slice_prefix" "$slice_suffix" && { slice_prefix="$slice_joiner"; is_prompt_empty=0; }
  __promptline_wrapper "$(zsh_get_rootcore_release_str)" "$slice_prefix" "$slice_suffix" && { slice_prefix="$slice_joiner"; is_prompt_empty=0; }
  __promptline_wrapper "$(zsh_get_rootcore_version_str)" "$slice_prefix" "$slice_suffix" && { slice_prefix="$slice_joiner"; is_prompt_empty=0; }
  __promptline_wrapper "$(zsh_get_panda_version_str)" "$slice_prefix" "$slice_suffix" && { slice_prefix="$slice_joiner"; is_prompt_empty=0; }
  __promptline_wrapper "$(zsh_get_rucio_version_str)" "$slice_prefix" "$slice_suffix" && { slice_prefix="$slice_joiner"; is_prompt_empty=0; }
  __promptline_wrapper "$(zsh_py_env_str)" "$slice_prefix" "$slice_suffix" && { slice_prefix="$slice_joiner"; is_prompt_empty=0; }

  # section "x" header
  slice_prefix="${x_bg}${sep}${x_fg}${x_bg}${space}" slice_suffix="$space${x_sep_fg}" slice_joiner="${x_fg}${x_bg}${alt_sep}${space}" slice_empty_prefix="${x_fg}${x_bg}${space}"
  [ $is_prompt_empty -eq 1 ] && slice_prefix="$slice_empty_prefix"
  # section "x" slices
  __promptline_wrapper "$(__promptline_jobs)" "$slice_prefix" "$slice_suffix" && { slice_prefix="$slice_joiner"; is_prompt_empty=0; }
  __promptline_wrapper "$(__promptline_vcs_branch)" "$slice_prefix" "$slice_suffix" && { slice_prefix="$slice_joiner"; is_prompt_empty=0; }

  # section "z" header
  slice_prefix="${z_bg}${sep}${z_fg}${z_bg}${space}" slice_suffix="$space${z_sep_fg}" slice_joiner="${z_fg}${z_bg}${alt_sep}${space}" slice_empty_prefix="${z_fg}${z_bg}${space}"
  [ $is_prompt_empty -eq 1 ] && slice_prefix="$slice_empty_prefix"
  # section "z" slices
  __promptline_wrapper "$(git rev-parse --short HEAD 2>/dev/null)" "$slice_prefix" "$slice_suffix" && { slice_prefix="$slice_joiner"; is_prompt_empty=0; }
  __promptline_wrapper "$(__promptline_git_status)" "$slice_prefix" "$slice_suffix" && { slice_prefix="$slice_joiner"; is_prompt_empty=0; }

  # section "a" header
  slice_prefix="${a_bg}${sep}${a_fg}${a_bg}${space}" slice_suffix="$space${a_sep_fg}" slice_joiner="${a_fg}${a_bg}${alt_sep}${space}" slice_empty_prefix="${a_fg}${a_bg}${space}"
  [ $is_prompt_empty -eq 1 ] && slice_prefix="$slice_empty_prefix"
  # section "a" slices
  __promptline_wrapper "$(__promptline_host)" "$slice_prefix" "$slice_suffix" && { slice_prefix="$slice_joiner"; is_prompt_empty=0; }
  __promptline_wrapper "$(if [[ -n ${ZSH_VERSION-} ]]; then print %n; elif [[ -n ${FISH_VERSION-} ]]; then printf "%s" "$USER"; else printf "%s" \\u; fi )" "$slice_prefix" "$slice_suffix" && { slice_prefix="$slice_joiner"; is_prompt_empty=0; }

  # section "b" header
  slice_prefix="${b_bg}${sep}${b_fg}${b_bg}${space}" slice_suffix="$space${b_sep_fg}" slice_joiner="${b_fg}${b_bg}${alt_sep}${space}" slice_empty_prefix="${b_fg}${b_bg}${space}"
  [ $is_prompt_empty -eq 1 ] && slice_prefix="$slice_empty_prefix"
  # section "b" slices
  __promptline_wrapper "%*" "$slice_prefix" "$slice_suffix" && { slice_prefix="$slice_joiner"; is_prompt_empty=0; }

  # section "c" header
  slice_prefix="${c_bg}${sep}${c_fg}${c_bg}${space}" slice_suffix="$space${c_sep_fg}" slice_joiner="${c_fg}${c_bg}${alt_sep}${space}" slice_empty_prefix="${c_fg}${c_bg}${space}"
  [ $is_prompt_empty -eq 1 ] && slice_prefix="$slice_empty_prefix"
  # section "c" slices
  __promptline_wrapper "$(__promptline_cwd)" "$slice_prefix" "$slice_suffix" && { slice_prefix="$slice_joiner"; is_prompt_empty=0; }

  # section "warn" header
  slice_prefix="${warn_bg}${sep}${warn_fg}${warn_bg}${space}" slice_suffix="$space${warn_sep_fg}" slice_joiner="${warn_fg}${warn_bg}${alt_sep}${space}" slice_empty_prefix="${warn_fg}${warn_bg}${space}"
  [ $is_prompt_empty -eq 1 ] && slice_prefix="$slice_empty_prefix"
  # section "warn" slices
  __promptline_wrapper "$(__promptline_last_exit_code)" "$slice_prefix" "$slice_suffix" && { slice_prefix="$slice_joiner"; is_prompt_empty=0; }

  # close sections
  printf "%s" "${reset_bg}${sep}$reset$space"
}
function __promptline_cwd {
  local dir_limit="3"
  local truncation="⋯"
  #local first_field="/"
  local first_field=""
  local part_count=0
  local formatted_cwd=""
  local dir_sep="  "
  local tilde=""
  local tilde_work=""
  local cern=false

  [ "${HOME##/afs/cern.ch/user}" != "$HOME" ] && local cern=true || local cern=false
  $cern && dir_home="/afs/cern.ch/user" || dir_home=$(dirname "$HOME")

  local cwd="${PWD/#"$dir_home\/"}"
  if [ "$cwd" != "$PWD" ]; then
    $cern && local basename_home="$(basename "${${cwd#*/}%%/*}")"  || local basename_home="$(basename "${cwd%%/*}")"
    if [ -n "$basename_home" ]; then
      first_field=$tilde
      if [ "$basename_home" != "$USER" ]; then
          first_field="$first_field $basename_home $first_field"
      fi
      $cern && cwd="/${${cwd#*/}#*/}" && [ "$cwd" = "/" ] && cwd="" || cwd="${cwd/#\/$basename_home/}"
    else
      cwd=$PWD
    fi
  elif [[ -n ${WORK} ]]; then 
    [ "${PWD##/afs/cern.ch/work}" != "$WORK" ] && local cern=true 
    $cern && dir_work="/afs/cern.ch/work" || dir_work=$(dirname "$WORK")
    local cwd="${PWD/#"$dir_work\/"}"
    if [ "$cwd" != "$PWD" ]; then
      $cern && local basename_work="$(basename "${${cwd#*/}%%/*}")"  || local basename_work="$(basename "${cwd%%/*}")"
      if [ -n "$basename_work" ]; then
        first_field=$tilde_work
        if [ "$basename_work" != "$USER" ]; then
          first_field="$first_field $basename_work $first_field"
        fi
        $cern && cwd="/${${cwd#*/}#*/}" && [ "$cwd" = "/" ] && cwd="" || cwd="${cwd/#\/$basename_work/}"
      fi
    else
      cwd=$PWD
    fi
  else
    true
    #[[ -n ${ZSH_VERSION-} ]] && first_field=$cwd[1,1] || first_field=${cwd::1}
  fi

  # remove leading tilde
  cwd="${cwd#$tilde}"
  cwd="${cwd#$tilde_work}"

  while [[ "$cwd" == */* && "$cwd" != "/" ]]; do
    # pop off last part of cwd
    local part="${cwd##*/}"
    cwd="${cwd%/*}"

    formatted_cwd="$dir_sep$part$formatted_cwd"
    part_count=$((part_count+1))

    [[ $part_count -eq $dir_limit ]] && { [ -n "$cwd" ] && first_field="$truncation" || true; } && break
  done

  printf "%s" "$first_field$formatted_cwd"
}
function zsh_get_rootcore_release_str {
  local rdir; local project;
  rdir=$(echo $ROOTCOREDIR)
  test -n "$rdir" || return 1
  if test "${rdir#*nightlies}" != "${rdir}"; then
    printf "-nightly"
  else
    project=$(basename $(dirname $(dirname "$rdir")))
    printf "-%s" "$project"
  fi
}
function zsh_get_rootcore_version_str {
  local rdir; local version;
  rdir=$(echo $ROOTCOREDIR)
  test -n "$rdir" || return 1
  version=$(basename $(dirname "$rdir"))
  printf "%s" "$version"
}
function zsh_get_athena_version_str {
  test -n "$AtlasVersion" || return 1
  echo "$AtlasVersion"
}
function __promptline_wrapper {
  # wrap the text in $1 with $2 and $3, only if $1 is not empty
  # $2 and $3 typically contain non-content-text, like color escape codes and separators

  [[ -n "$1" ]] || return 1
  printf "%s" "${2}${1}${3}"
}
function zsh_get_rucio_version_str {
  local version;
  version=$(echo $ATLAS_LOCAL_RUCIOCLIENTS_VERSION)
  test -n "$version" || return 1
  printf "-%s" "$version"
}
function __promptline_host {
  if [ -f "/.dockerenv" ]; then
    local SYMB=" "
    local hostname="%m"
    local only_if_ssh="0"
  elif [ -n "$SINGULARITY_NAME" ]; then
    local SYMB=" " #" "
    local hostname="$SINGULARITY_NAME@%m"
    local only_if_ssh="0"
  else
    local SYMB=""
    local hostname="%m"
    local only_if_ssh="1"
  fi
  if [ "$only_if_ssh"="0" -o -n "${SSH_CLIENT}" ]; then
    if [[ -n ${ZSH_VERSION-} ]]; then print ${SYMB}${hostname}; elif [[ -n ${FISH_VERSION-} ]]; then hostname -s; else printf "%s" \\h; fi
  fi
}
function zsh_get_panda_version_str {
  local version;
  version=$(echo $ATLAS_LOCAL_PANDACLI_VERSION)
  test -n "$version" || return 1
  printf "-%s" "$version"
}

function __promptline_jobs {
  local job_count=0

  local IFS=$'\n'
  for job in $(jobs); do
    # count only lines starting with [
    if [[ $job == \[* ]]; then
      job_count=$(($job_count+1))
    fi
  done

  [[ $job_count -gt 0 ]] || return 1;
  printf "%s" "$job_count"
}

function __promptline_left_prompt {
  local slice_prefix slice_empty_prefix slice_joiner slice_suffix is_prompt_empty=1

  # section "a" header
  slice_prefix="${a_bg}${sep}${a_fg}${a_bg}${space}" slice_suffix="$space${a_sep_fg}" slice_joiner="${a_fg}${a_bg}${alt_sep}${space}" slice_empty_prefix="${a_fg}${a_bg}${space}"
  [ $is_prompt_empty -eq 1 ] && slice_prefix="$slice_empty_prefix"
  # section "a" slices
  __promptline_wrapper "$(__promptline_host)" "$slice_prefix" "$slice_suffix" && { slice_prefix="$slice_joiner"; is_prompt_empty=0; }
  __promptline_wrapper "$(if [[ -n ${ZSH_VERSION-} ]]; then print "%n"; elif [[ -n ${FISH_VERSION-} ]]; then printf "%s" "$USER"; else printf "%s" \\u; fi )" "$slice_prefix" "$slice_suffix" && { slice_prefix="$slice_joiner"; is_prompt_empty=0; }

  # section "b" header
  slice_prefix="${b_bg}${sep}${b_fg}${b_bg}${space}" slice_suffix="$space${b_sep_fg}" slice_joiner="${b_fg}${b_bg}${alt_sep}${space}" slice_empty_prefix="${b_fg}${b_bg}${space}"
  [ $is_prompt_empty -eq 1 ] && slice_prefix="$slice_empty_prefix"
  # section "b" slices
  __promptline_wrapper "%*" "$slice_prefix" "$slice_suffix" && { slice_prefix="$slice_joiner"; is_prompt_empty=0; }

  # section "c" header
  slice_prefix="${c_bg}${sep}${c_fg}${c_bg}${space}" slice_suffix="$space${c_sep_fg}" slice_joiner="${c_fg}${c_bg}${alt_sep}${space}" slice_empty_prefix="${c_fg}${c_bg}${space}"
  [ $is_prompt_empty -eq 1 ] && slice_prefix="$slice_empty_prefix"
  # section "c" slices
  __promptline_wrapper "$(__promptline_cwd)" "$slice_prefix" "$slice_suffix" && { slice_prefix="$slice_joiner"; is_prompt_empty=0; }

  # close sections
  printf "%s" "${reset_bg}${sep}$reset$space"
}
function __promptline_right_prompt {
  local slice_prefix slice_empty_prefix slice_joiner slice_suffix

  # section "warn" header
  slice_prefix="${warn_sep_fg}${rsep}${warn_fg}${warn_bg}${space}" slice_suffix="$space${warn_sep_fg}" slice_joiner="${warn_fg}${warn_bg}${alt_rsep}${space}" slice_empty_prefix=""
  # section "warn" slices
  __promptline_wrapper "$(__promptline_last_exit_code)" "$slice_prefix" "$slice_suffix" && { slice_prefix="$slice_joiner"; }

  # section "x" header
  slice_prefix="${x_sep_fg}${rsep}${x_fg}${x_bg}${space}" slice_suffix="$space${x_sep_fg}" slice_joiner="${x_fg}${x_bg}${alt_rsep}${space}" slice_empty_prefix=""
  # section "x" slices
  __promptline_wrapper "$(__promptline_jobs)" "$slice_prefix" "$slice_suffix" && { slice_prefix="$slice_joiner"; }
  __promptline_wrapper "$(__promptline_vcs_branch)" "$slice_prefix" "$slice_suffix" && { slice_prefix="$slice_joiner"; }

  # section "y" header
  slice_prefix="${y_sep_fg}${rsep}${y_fg}${y_bg}${space}" slice_suffix="$space${y_sep_fg}" slice_joiner="${y_fg}${y_bg}${alt_rsep}${space}" slice_empty_prefix=""
  # section "y" slices
  __promptline_wrapper "$(zsh_get_athena_project_str)" "$slice_prefix" "$slice_suffix" && { slice_prefix="$slice_joiner"; }
  __promptline_wrapper "$(zsh_get_athena_version_str)" "$slice_prefix" "$slice_suffix" && { slice_prefix="$slice_joiner"; }
  __promptline_wrapper "$(zsh_get_rootcore_release_str)" "$slice_prefix" "$slice_suffix" && { slice_prefix="$slice_joiner"; }
  __promptline_wrapper "$(zsh_get_rootcore_version_str)" "$slice_prefix" "$slice_suffix" && { slice_prefix="$slice_joiner"; }
  __promptline_wrapper "$(zsh_get_panda_version_str)" "$slice_prefix" "$slice_suffix" && { slice_prefix="$slice_joiner"; }
  __promptline_wrapper "$(zsh_get_rucio_version_str)" "$slice_prefix" "$slice_suffix" && { slice_prefix="$slice_joiner"; }
  __promptline_wrapper "$(zsh_py_env_str)" "$slice_prefix" "$slice_suffix" && { slice_prefix="$slice_joiner"; }

  # section "z" header
  slice_prefix="${z_sep_fg}${rsep}${z_fg}${z_bg}${space}" slice_suffix="$space${z_sep_fg}" slice_joiner="${z_fg}${z_bg}${alt_rsep}${space}" slice_empty_prefix=""
  # section "z" slices
  __promptline_wrapper "$(git rev-parse --short HEAD 2>/dev/null)" "$slice_prefix" "$slice_suffix" && { slice_prefix="$slice_joiner"; }
  __promptline_wrapper "$(__promptline_git_status)" "$slice_prefix" "$slice_suffix" && { slice_prefix="$slice_joiner"; }

  # close sections
  printf "%s" "$reset"
}
function zsh_get_athena_project_str {
  test -n "$AtlasProject" || return 1
  echo "-$AtlasProject"
}
function __promptline {
  local last_exit_code="${PROMPTLINE_LAST_EXIT_CODE:-$?}"

  local esc=$'[' end_esc=m
  if [[ -n ${ZSH_VERSION-} ]]; then
    local noprint='%{' end_noprint='%}'
  elif [[ -n ${FISH_VERSION-} ]]; then
    local noprint='' end_noprint=''
  else
    local noprint='\[' end_noprint='\]'
  fi
  local wrap="$noprint$esc" end_wrap="$end_esc$end_noprint"
  local space=" "
  local sep=""
  local rsep=""
  local alt_sep=""
  local alt_rsep=""
  local reset="${wrap}0${end_wrap}"
  local reset_bg="${wrap}49${end_wrap}"
  local a_fg="${wrap}38;5;232${end_wrap}"
  local a_bg="${wrap}48;5;192${end_wrap}"
  local a_sep_fg="${wrap}38;5;192${end_wrap}"
  local b_fg="${wrap}38;5;192${end_wrap}"
  local b_bg="${wrap}48;5;238${end_wrap}"
  local b_sep_fg="${wrap}38;5;238${end_wrap}"
  local c_fg="${wrap}38;5;192${end_wrap}"
  local c_bg="${wrap}48;5;235${end_wrap}"
  local c_sep_fg="${wrap}38;5;235${end_wrap}"
  local warn_fg="${wrap}38;5;232${end_wrap}"
  local warn_bg="${wrap}48;5;166${end_wrap}"
  local warn_sep_fg="${wrap}38;5;166${end_wrap}"
  local x_fg="${wrap}38;5;192${end_wrap}"
  local x_bg="${wrap}48;5;235${end_wrap}"
  local x_sep_fg="${wrap}38;5;235${end_wrap}"
  local y_fg="${wrap}38;5;192${end_wrap}"
  local y_bg="${wrap}48;5;238${end_wrap}"
  local y_sep_fg="${wrap}38;5;238${end_wrap}"
  local z_fg="${wrap}38;5;232${end_wrap}"
  local z_bg="${wrap}48;5;192${end_wrap}"
  local z_sep_fg="${wrap}38;5;192${end_wrap}"
  if [[ -n ${ZSH_VERSION-} ]]; then
    #if [[ -z ${AtlasVersion} ]]; then
      PROMPT="$(__promptline_left_prompt)"
      RPROMPT="$(__promptline_right_prompt)"
    #else
      #PROMPT="$(__promptline_ps1)"
      #RPROMPT=""
      #PROMPT="$(__promptline_left_prompt)"
      #RPROMPT="$(__promptline_right_prompt)"
    #fi
  elif [[ -n ${FISH_VERSION-} ]]; then
    if [[ -n "$1" ]]; then
      [[ "$1" = "left" ]] && __promptline_left_prompt || __promptline_right_prompt
    else
      __promptline_ps1
    fi
  else
    PS1="$(__promptline_ps1)"
  fi
}

if [[ -n ${ZSH_VERSION-} ]]; then
  if [[ ! ${precmd_functions[(r)__promptline]} == __promptline ]]; then
    precmd_functions+=(__promptline)
  fi
elif [[ -n ${FISH_VERSION-} ]]; then
  __promptline "$1"
else
  if [[ ! "$PROMPT_COMMAND" == *__promptline* ]]; then
    PROMPT_COMMAND='__promptline;'$'\n'"$PROMPT_COMMAND"
  fi
fi
