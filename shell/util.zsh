# ##########################################################################
# ##########################################################################
# ## Some basic util functions
getShortPath(){
  lpath=$1; shift;
  if [ -d $lpath ]; then
    echo $(cd $lpath && pwd)
  else
    echo $(cd "$(dirname $lpath)" && pwd)/"$(basename $lpath)"
  fi
}

# Overwrites variable with new one
setvar(){
  local oldIFS=$IFS; IFS=":"
  local var=$1; shift; eval "$var=\$*; export $var"
  IFS=$oldIFS; unset oldIFS
}

# Set variable to value if it is empty
setdefvar(){
  local oldIFS=$IFS; IFS=":"
  local var=$1; shift;
  eval "test -z \"\$$var\" && $var=\$* && export $var"
  IFS=$oldIFS; unset oldIFS
}

# Checks if string contains substring
contains() {
  local string="$1"
  local substring="$2"
  test "${string#*$substring}" = "${string}" && return 1 || return 0;
}

# check if path substring is in path
contains_path() {
  local string="$(eval "echo \"\$$1\"")"
  local substring="$2"
  if contains ":$string:" ":$substring:"; then return 0; else return 1; fi
}

removefromvar(){
  autoload -Uz regexp-replace
  #setopt re_match_pcre
  local var=$1; shift; oldVar=var
  foreach removePath in $@
  do
    if test -e $removePath; then
      while contains_path $var "$removePath"; do
        regexp-replace $var "(^|:)${removePath}[^:]*" ""
      done
      regexp-replace $var "^:" ""
      regexp-replace $var ":$" ""
    fi
  done
  eval "export $var"
  unset oldVar
}

# Appends values to string with : if they weren't added before
addtovar(){
  autoload -Uz regexp-replace
  #setopt re_match_pcre
  local var=$1; shift; oldVar=var
  removefromvar $var $@
  foreach addPath in $@
  do
    if test -e $addPath; then
      regexp-replace $var "^:" ""
      regexp-replace $var ":$" ""
      eval "$var=\"$addPath\":\$$var"
    fi
  done
  eval "export $var"
  unset oldVar
}

# Check if string beginswith substring
beginswith() { case $2 in "$1"*) true;; *) false;; esac; }

# Check if variable is defined
isvardef() { typeset -p $1 >&! /dev/null && true || false; }

# print_var
print_var(){
  if isvardef $1 ; then
    eval "echo \$$1 | tr \":\" \"\n\""
  else
    eval "echo $1 | tr \":\" \"\n\""
  fi
}

# Make source aliases to files on folder $1
makeAliases(){
  folder=$1; shift;
  foreach script in `find $folder -maxdepth 1 -mindepth 1 -not -type d -not -path '*/\.*'`
  do
    scriptBase=$(basename $script)
    eval "alias $scriptBase='source $script'"
  done
}

# Substitute for standard ssh exporting if original connection has powerline
ssh-powerline(){
  local start_command=""
  while :; do
    case $1 in
      --cmd)
        local start_command="export START_COMMAND=$2 &&"
        shift 2
        continue
        ;;
      --cmd=?*)
        local start_command="export START_COMMAND=${1#*=} &&"
        shift
        ;;
      --) # End of all options.
        shift
        break
        ;;
      *) # Default case: If no more options then break out of the loop.
        break
    esac
    shift
  done
  local shell_base=$(basename $SHELL)
  local __cmd="$start_command which ${shell_base} > /dev/null 2> /dev/null && export SHELL=\$(which ${shell_base}) && exec ${shell_base} -l || SHELL=\$HOME/DotFiles/bin/zsh && test -e \$SHELL && export PATH=\"\$HOME/DotFiles/bin/:\$PATH\"&& exec \$SHELL -l || export SHELL=/bin/bash && exec \$SHELL -l"
  ssh-powerline-wcmd "${@[@]}" $__cmd
}

ssh-powerline-wcmd(){
  local HAS_POWERLINE=${HAS_POWERLINE:=0}
  local HAS_ITERM2=${HAS_ITERM2:=0}
  local __cmd=${@[-1]}
  length=$((${#@}-1))
  set -A array
  for i in $(seq $(($length))); do
    test "${@[$i]}" != "--cmd=" && array+=${@[$i]}
  done
  /usr/bin/ssh -t $array "export HAS_POWERLINE=${(q)HAS_POWERLINE} && export HAS_ITERM2=${(q)HAS_ITERM2} && $__cmd"
}

ssh-powerline-tunel(){
# Create ssh command string for tunneling into internal server node
#
# Method 1:
#
# Input args:
#   -> $1 (account): the log in account to use in the open node;
#   -> $2 (open_node): the open node to log in;
#   -> $3 (internal_node): the internal machine to log in.
#
# Method 2:
#
# Input args:
#   -> $1 (account): the log in account to use in the open node;
#   -> $2 (open_node): the open node to log in;
#   -> $3 (internal_account): the log in account to use in the internal node
#   -> $4 (internal_node): the internal machine to log in.
#
# Method 3:
#
# Input args:
#   -> $1 (account): the log in account to use in the open node;
#   -> $2 (open_node): the open node to log in;
#   -> $3 (internal_account): the log in account to use in the internal node
#   -> $4 (extra_setup): the open node commands before logging in to internal machine
#   -> $5 (internal_node): the internal machine to log in.
#   -> $6 (internal_node command): the internal machine to log in.
#
  local shell_base=$(basename $SHELL)
  if test "$#" -le 3; then
    local account=$1; local open_node=$2; local extra_setup=""; local internal_account=$account; local internal_node=$3;
  elif test "$#" -le 4; then
    local account=$1; local open_node=$2; local extra_setup=$3; local internal_account=$account; local internal_node=$4;
  else
    local account=$1; local open_node=$2; local extra_setup=$3; local internal_account=$4; local internal_node=$5; local internal_node_cmd=$6;
  fi
  if test "$4" = "1" -o "$5" = "1"; then
    ignore_asetup='IGNORE_ASETUP=1'
  fi
  local __cmd=""
  test -n "$extra_setup" && link="&&"
  local internal_cmd="$extra_setup $link ssh-powerline --cmd=${internal_node_cmd} -A -t -Y -l $internal_account $internal_node"
  echo "ssh-powerline-wcmd" \
         "-A -t -Y " \
         "-l $account $open_node " \
         "\"which ${shell_base} > /dev/null 2> /dev/null && export SHELL=\\\$(which ${shell_base})" \
           "&& exec ${shell_base} -c \\\"$extra_setup source \\\$HOME/.zshrc &>! /dev/null " \
           "&& $internal_cmd\\\" || export SHELL=\\\$HOME/DotFiles/bin/zsh && test -e \\\$SHELL && export PATH=\\\"\\\$HOME/DotFiles/bin/:\\\$PATH\\\"" \
           "&& exec \\\$SHELL -c \\\"$extra_setup source \\\$HOME/.zshrc &>! /dev/null && $internal_cmd  \\\" " \
           "|| export SHELL=/bin/bash && exec \\\$SHELL -c \\\"$extra_setup source \\\$HOME/.bashrc &>! /dev/null $internal_cmd\\\"\""
}

# cd and ls
cl()
{
  if [ $1 ]; then
    if [ -d $1 ]; then
      cd $1
      ls
    else
      cd $HOME
      ls
    fi
  fi
}

cwd() {
  cd "$@"
  (unset TMUX; tmux attach -t $(tmux display-message -p '#S') -c $PWD\; detach-client) 2>&1 1>/dev/null
}

# echo a bell
bell() {
  echo "\a\a\a"
}
# ##########################################################################
