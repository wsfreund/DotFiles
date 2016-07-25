# ##########################################################################
# ##########################################################################
# ## Configure your oh-my-zsh
# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="flazz"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git git-extras screen ssh-agent python)

# Initialize oh-my-zsh
source $ZSH/oh-my-zsh.sh
# ##########################################################################

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
  oldIFS=$IFS; IFS=":"
  var=$1; shift; eval "$var=\$*; export $var"
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

# Appends values to string with : if they weren't added before
addtovar(){
  autoload -Uz regexp-replace
  #setopt re_match_pcre
  var=$1; shift; oldVar=var
  foreach addPath in $@
  do
    if test -e $addPath; then
      while contains_path $var "$addPath"; do
        regexp-replace $var "(^|:)${addPath}[^:]*" ""
      done
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
  local HAS_POWERLINE=${HAS_POWERLINE:=0}
  if [[ $1 =~ "(.*):(.*)" ]]; then
    host=${match[-2]}
    path=${match[-1]}
    /usr/bin/ssh -t $@ "cd ${path} && export HAS_POWERLINE=${(q)HAS_POWERLINE} && exec $(basename $SHELL)"
  else
    /usr/bin/ssh -t $@ "export HAS_POWERLINE=${(q)HAS_POWERLINE} && exec $(basename $SHELL)"
  fi
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
compdef _cd cl
# ##########################################################################

# ##########################################################################
# ##########################################################################
## Some aliases
alias ....="cd ../../.."
alias ...="cd ../.."
alias ..="cd .."
alias cd..="cd .."
# ##########################################################################


# ##########################################################################
# ##########################################################################
## Key bindings
bindkey "\033[3~" delete-char
# ##########################################################################

# ##########################################################################
# ##########################################################################
# ## Change history configuration
HISTFILE=~/.zsh_history
HISTSIZE=500000
SAVEHIST=100000
setopt appendhistory autocd extendedglob
setopt EXTENDED_HISTORY
setopt histignorealldups sharehistory
# ##########################################################################

# ##########################################################################
# ##########################################################################
# ## Misc
# Change default editor to vim
export EDITOR='vim'

#¬†Make erase send ^? signal
if ! beginswith "$TERM" "screen"; then
  stty erase '^?'
fi
# ##########################################################################

# ##########################################################################
# ##########################################################################
# ## Change shell behavior
# Add user local configuration:
test -e "${HOME}/.zsh_local" && source "${HOME}/.zsh_local"

# Change SHELL PROMPT
if test "$HAS_POWERLINE" -eq "1"; then
  test -e "$HOME/.shell_prompt.sh" && source "$HOME/.shell_prompt.sh"
else
  test -e "$HOME/.shell_prompt_no_pl.sh" && source "$HOME/.shell_prompt_no_pl.sh"
fi

# Change ls colors
test -e "$HOME/.dircolors.256dark" && eval `dircolors "$HOME/.dircolors.256dark"`
if [ "$TERM" != "dumb" ]; then
  alias ls="ls --color=always"
  alias grep="grep --color=always"
  alias egrep="egrep --color=always"
fi
force_color_prompt=yes

# Add iterm 2 integration
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
# ##########################################################################

# ##########################################################################
# ##########################################################################
# ## Use modern completion system
autoload -Uz compinit
compinit
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2 eval "$(dircolors -b)"
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:commands' list-colors '=*=1;31'
zstyle ':completion:*:aliases' list-colors '=*=1;38;5;128' # Set for =*=2; for dark colors, 5 for blinking
zstyle ':completion:*:parameters'  list-colors '=*=32'
zstyle ':completion:*:options' list-colors '=^(-- *)=34'
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
export KEYTIMEOUT=1
# ##########################################################################
