source "$HOME/DotFiles/util.zsh"

test -f "$HOME/DotFiles/zsh_local_pre" && source "$HOME/DotFiles/zsh_local_pre"

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
plugins=(git git-extras screen ssh-agent python osx tmux)

# Initialize oh-my-zsh
source $ZSH/oh-my-zsh.sh
# ##########################################################################

# ##########################################################################
# ##########################################################################
addtovar PATH "$HOME/DotFiles/bin"
addtovar LD_LIBRARY_PATH "$HOME/DotFiles/lib"
addtovar DYLD_LIBRARY_PATH "$HOME/DotFiles/lib"
addtovar MANPATH "$HOME/DotFiles/share/man"
# ##########################################################################

# ##########################################################################
# ##########################################################################
## Some aliases
alias ....="cd ../../.."
alias ...="cd ../.."
alias ..="cd .."
alias cd..="cd .."
alias clc="clear"
alias mkdir='command mkdir -p'
# Improves vim performance (but removes clipboard integration to x-server):
alias vim='command vim -X'
alias vimdiff='command vimdiff -X'
alias vimdir='vim -p $(find . -not -path "./cmt/*" -a \( -name "*.cxx" -or -name "*.h" -or -name "*.py" \))'
alias rsync='rsync -rhvazP'
if [ "$TERM" != "dumb" ]; then
  alias ls="ls --color=always"
  alias grep="grep --color=always"
  alias egrep="egrep --color=always"
fi
force_color_prompt=yes
# ##########################################################################

# ##########################################################################
# ##########################################################################
## Declare variables
if test  -e /proc/cpuinfo; then
  setvar OMP_NUM_THREADS $(( $(cat "/proc/cpuinfo" | grep "processor" | tail -n 1 | cut -f2 -d ' ') + 1 ))
elif test -n "$(sysctl -a 2> /dev/null | grep machdep.cpu)"; then
  setvar OMP_NUM_THREADS $(sysctl -a | grep machdep.cpu | grep core_count |  cut -f2 -d  ' ')
fi
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
# ## Change shell behavior
# Add user local configuration:
test -e "${HOME}/DotFiles/zsh_local" && source "${HOME}/DotFiles/zsh_local"
# Add cern local configuration:
#test "$(hostname -d 2> /dev/null)" = "cern.ch" -a -e "${HOME}/DotFiles/zsh_local_cern" && source "$HOME/DotFiles/zsh_local_cern"
test -d /cvmfs -a -e "${HOME}/DotFiles/zsh_local_cern" && source "${HOME}/DotFiles/zsh_local_cern"

# Change SHELL PROMPT
if test "$HAS_POWERLINE" -eq "1"; then
  test -e "$HOME/DotFiles/shell_prompt.sh" && source "$HOME/DotFiles/shell_prompt.sh"
else
  test -e "$HOME/DotFiles/shell_prompt_no_pl.sh" && source "$HOME/DotFiles/shell_prompt_no_pl.sh"
fi

# Add iterm 2 integration
test "$HAS_ITERM2" -eq "1" -a -e "${HOME}/.iterm2_shell_integration.zsh" \
  && source "${HOME}/.iterm2_shell_integration.zsh"
# Add root if compiled at home
if test -e "$HOME/root/bin/thisroot.sh" -a "$IGNORE_ROOT" -ne "1"; then
  pushd $HOME/root/bin/ &>! /dev/null && source thisroot.sh && popd &>! /dev/null
fi
# ##########################################################################

# ##########################################################################
# ##########################################################################
# ## Misc
# Change default editor to vim
export EDITOR='vim -X'

# Make erase send ^? signal
if ! beginswith "$TERM" "screen"; then
  stty erase '^?'
fi

# Add alias to scripts folder
test -d "$HOME/scripts" && makeAliases "$HOME/scripts"

# Change ls colors
test -e "$HOME/.dircolors.256dark" && eval `dircolors "$HOME/.dircolors.256dark"`

# Add screen workspaces to tmp
#if test -d "$HOME/workplaces"; then
#  # If we are not on screen, add screen workplaces on afs to tmp
#  if ! beginswith "$TERM" "screen" ]]; then
#    mkdir "/tmp/$USER"
#
#    if [ -e "/tmp/$USER/workplaces" ]; then
#      rm "/tmp/$USER/workplaces/"*
#    fi
#
#    cp -r "$HOME/workplaces" "/tmp/$USER/"
#    chmod 640 "/tmp/$USER/workplaces/"*
#  fi
#fi
# ##########################################################################
# ##########################################################################

# ##########################################################################
# ##########################################################################
# ## Tmux plugins
setdefvar TMUXIFIERPATH="$HOME/.tmuxifier"
if test -d $TMUXIFIERPATH; then 
  addtovar PATH "$TMUXIFIERPATH/bin"
  eval "$(tmuxifier init -)"
fi
# complete words from tmux pane(s) {{{1
# Usage: Push ^X^t to search for prefix completion and ^X^X to search for matches
# Source: https://gist.github.com/blueyed/6856354
_tmux_pane_words() {
  local expl
  local -a w
  if [[ -z "$TMUX_PANE" ]]; then
    _message "not running inside tmux!"
    return 1
  fi
  # capture current pane first
  w=( ${(u)=$(tmux capture-pane -J -p)} )
  for i in $(tmux list-panes -F '#P'); do
    # skip current pane (handled above)
    [[ "$TMUX_PANE" = "$i" ]] && continue
    w+=( ${(u)=$(tmux capture-pane -J -p -t $i)} )
  done
  _wanted values expl 'words from current tmux pane' compadd -a w
}
zle -C tmux-pane-words-prefix   complete-word _generic
zle -C tmux-pane-words-anywhere complete-word _generic
bindkey '^X^t' tmux-pane-words-prefix
bindkey '^X^T' tmux-pane-words-anywhere
zstyle ':completion:tmux-pane-words-(prefix|anywhere):*' completer _tmux_pane_words
zstyle ':completion:tmux-pane-words-(prefix|anywhere):*' ignore-line current
# display the (interactive) menu on first execution of the hotkey
zstyle ':completion:tmux-pane-words-(prefix|anywhere):*' menu yes select interactive
zstyle ':completion:tmux-pane-words-anywhere:*' matcher-list 'b:=* m:{A-Za-z}={a-zA-Z}'
# }}}
# ##########################################################################
# ##########################################################################


# ##########################################################################
# ##########################################################################
# ## Use modern completion system
autoload -Uz compinit
compinit -u
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

# ##########################################################################
# ##########################################################################
compdef _cd cl
# ##########################################################################


# ##########################################################################
# ##########################################################################
if [[ -n "START_COMMAND" ]]; then
  start_command="$START_COMMAND"
  unset START_COMMAND
  eval "$start_command"
fi
# ##########################################################################
# ##########################################################################
