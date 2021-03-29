#!/bin/bash
# We use /bin/bash as it should be available at most of the systems

readlink_f(){
# Re-implement recursive readlink in case system uses BSD readlink
  local input=$1;
  while [ -L "$input" ]; do
    local input="`readlink "$input"`"
  done
  echo "$input"
}

hostname_d(){
# Re-implements hostname domain if using BSD
  local var=`hostname -f`
  echo "${var#*.}"
}

# Get the backup folder
bkg_date=`date +%Y-%m-%d:%H:%M:%S`
bkg_folder="$HOME/DotFiles/backups/$bkg_date"

# and this host domain
host_domain="`hostname -d 2> /dev/null || hostname_d`"

get_dotfile(){
  local base_1=`basename $1`
  echo "$HOME/DotFiles/${base_1#.}"
}

backup(){
  local base_1=`basename $1`
  local dest="$2" && [ -z "$dest" ] && local dest="`get_dotfile "$1"`"
  if [ -e "$1" -o -L "$1" ]; then
    local file=`readlink -f "$1" 2>/dev/null || readlink_f "$1"`
    if [ \! -e "$1" -a -L "$1" ]; then
      echo "Removing bad link '$1'." && rm "$1"
    elif [ "$file" != "$dest" ]; then
      [ \! -d "$bkg_folder" ] && \
        mkdir -p "$bkg_folder" || true && mv $1 "$bkg_folder/" && \
        echo "Created back-up of your old configuration file(s) '$1' at '$bkg_folder'." || \
        echo "No need to create back-up for '$1', you are already using DotFiles configuration."
    fi
  fi
}

link_dotfile(){
  local dest=$2 && [ -z "$dest" ] && local dest="`get_dotfile "$1"`"
  if [ -e "$1" ]; then
    local file=`readlink -f "$1" 2>/dev/null || readlink_f "$1"`
    if [ "$file" != "$dest" ]; then
      echo "WARN: For some reason file $1 still exists."
    fi
  else
    echo "Creating link '$1' to '$dest'..."
    ln -s "$dest" "$1"
  fi
}

if ! git config --get core.excludesfile > /dev/null; then
  git config --global core.excludesfile $HOME/.gitignore_global
fi

if test "$host_domain" = "smc-default.americas.sgi.com"; then
  ssh_config=("$HOME/.ssh/config" "$HOME/DotFiles/ssh/config_loboc")
else
  ssh_config=("$HOME/.ssh/config" "$HOME/DotFiles/ssh/config")
fi

files=( "${ssh_config[@]}" \
       "$HOME/.screenrc" "$HOME/DotFiles/screen/screenrc" \
       "$HOME/.zshrc" "$HOME/DotFiles/shell/zshrc" \
       "$HOME/.dircolors.256dark" "$HOME/DotFiles/shell/dircolors.256dark" \
       "$HOME/.vimrc" "$HOME/DotFiles/vim/vimrc" \
       "$HOME/.vim" "" \
       "$HOME/.tmux.conf" "$HOME/DotFiles/tmux/tmux.conf" \
       "$HOME/.gitignore_global" "$HOME/DotFiles/git/gitignore_global" \
       "$HOME/.rootrc" "$HOME/DotFiles/root/rootrc" \
       "$HOME/.latexmkrc" "$HOME/DotFiles/latexmk/latexmkrc" \
      )

for idx in $(seq 1 2 $((${#files[@]}))); do
  file=${files[idx-1]}
  dest=${files[idx]}
  if [[ -z "$file" ]]; then continue; fi
  backup "$file" "$dest" && link_dotfile "$file" "$dest"
done

if test "$host_domain" = "lps.ufrj.br" -o "$host_domain" = "smc-default.americas.sgi.com"; then
  #${files[${#files[*]}+1]}=".bashrc"
  backup "$HOME/.bashrc" "$HOME/DotFiles/shell/bashrc_redirect" && link_dotfile "$HOME/.bashrc" "$HOME/DotFiles/shell/bashrc_redirect"
  backup "$HOME/.bash_profile" "$HOME/DotFiles/shell/bashrc_redirect" && link_dotfile "$HOME/.bash_profile" "$HOME/DotFiles/shell/bashrc_redirect"
fi

test -d "$HOME/DotFiles/tmp" || mkdir "$HOME/DotFiles/tmp"

if test "$host_domain" = "smc-default.americas.sgi.com"; then
  test ! -e $HOME/DotFiles/shell/zsh_local && cp /scratch/22061a/common-cern/zsh_local $HOME/DotFiles/shell
  test ! -e $HOME/DotFiles/shell/zsh_local_pre && cp /scratch/22061a/common-cern/zsh_local_pre $HOME/DotFiles/shell
fi

if test "$host_domain" = "lps.ufrj.br"; then
  if ! type zsh > /dev/null 2> /dev/null; then
    # Zsh
    zsh_tgz_file=$HOME/DotFiles/shell/zsh.tgz
    zsh_install_path=$HOME/DotFiles;
    if ! { type zsh > /dev/null 2>&1 || test -f "$zsh_install_path/bin/zsh"; }; then
      if test \! -f $zsh_tgz_file; then
        echo "Downloading zsh..."
        curl -s -o $zsh_tgz_file -L http://www.zsh.org/pub/zsh.tar.gz
      fi
      echo "Installing zsh..."
      zsh_folder=$(tar xfzv $zsh_tgz_file -C $HOME/DotFiles 2> /dev/null)
      test -z "$zsh_folder" && { echo "Couldn't extract zsh!" && return 1;}
      zsh_folder=$(echo $zsh_folder | cut -f1 -d ' ' )
      zsh_folder=${zsh_folder%%\/*}
      pushd $HOME/DotFiles/$zsh_folder
      ./configure --prefix=$zsh_install_path > /dev/null
      make install > /dev/null || { echo "Couldn't make zsh." && return 1; }
      popd > /dev/null
    else
      echo "No need to install zsh."
    fi
  fi
  #if test $(basename $SHELL) != "zsh"; then
  #  chsh -s $(which zsh) || return $chsherrno;
  #fi
fi

if ! git config --get core.excludesfile > /dev/null; then
  git config --global core.excludesfile $HOME/.gitignore_global
fi

if ! test -e $HOME/.oh-my-zsh; then
  git clone https://github.com/ohmyzsh/ohmyzsh.git $HOME/.oh-my-zsh
fi

if test -e $ZSH/log/update.lock; then
  rmdir $ZSH/log/update.lock
fi

# TODO Install coreutils if on mac.

# TODO Install vim if no lua.

echo "Installing Vimhalla..."
git clone https://github.com/gmarik/Vundle.vim.git $HOME/DotFiles/vim/bundle/Vundle.vim > /dev/null 2> /dev/null || true
vim --cmd "set rtp^='$HOME/DotFiles/vim'" -u "$HOME/DotFiles/vim/vimrc" -E -c VundleInstall -c qa || true
vim --cmd "set rtp^='$HOME/DotFiles/vim'" -u "$HOME/DotFiles/vim/vimrc" -E -c VundleUpdate -c qa || true

files=(
       "$HOME/DotFiles/vim/bundle/nerdtree/nerdtree_plugin/exec_menuitem.vim" "$HOME/DotFiles/vim/extra_plugins/exec_menuitem.vim"  \
      )

for idx in $(seq 1 2 $((${#files[@]}))); do
  file=${files[idx-1]}
  dest=${files[idx]}
  if [[ -z "$file" ]]; then continue; fi
  backup "$file" "$dest" && link_dotfile "$file" "$dest"
done

# TODO Install NERD Font and add echo message to tell user to change terminal font!

# Install Tmux
if test $(bc <<< "$(tmux -V | sed 's/tmux //g') < 2.2") -eq "1" -a "$(tmux -V)" != "tmux master"; then
  git clone https://github.com/tmux/tmux.git $HOME/DotFiles/tmux-source
  pushd $HOME/DotFiles/tmux-source > /dev/null
  if [ $(uname) = "Linux" ]; then
    sh autogen.sh > /dev/null
    ./configure LDFLAGS="-Wl,-L/usr/local/lib" --prefix="$HOME/DotFiles" > /dev/null
    make install > /dev/null
  elif [ $(uname) = "Darwin" ]; then
    sh autogen.sh > /dev/null
    ./configure LDFLAGS="-Wl,-rpath/usr/local/lib" --prefix="$HOME/DotFiles" > /dev/null
    make install > /dev/null
  fi
  $HOME/DotFiles/bin/tmux source $HOME/.tmux.conf
  popd > /dev/null
fi

if test \! -d $HOME/.tmux/plugins/tpm; then
  git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
fi

if test \! -d $HOME/.tmuxifier; then
  git clone https://github.com/wsfreund/tmuxifier.git $HOME/.tmuxifier
fi

$HOME/.tmux/plugins/tpm/bin/install_plugins
$HOME/.tmux/plugins/tpm/bin/update_plugins all

t_ress="$HOME/.tmux/plugins/tmux-resurrect"
if pushd $t_ress > /dev/null; then
  if ! git remote show | grep fork > /dev/null 2> /dev/null; then
    git remote add fork https://github.com/wsfreund/tmux-resurrect.git
  fi
  git pull --rebase --stat fork master
  popd > /dev/null
fi
