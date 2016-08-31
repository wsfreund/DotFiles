#!/bin/bash
# We use /bin/bash as it should be available at most of the systems

readlink_f(){
# Re-implement recursive readlink in case system uses BSD readlink
  input=$1;
  while [ -L "$1" ]; do
    input="`readlink "$1"`"
  done
  echo "$input"
}

hostname_d(){
# Re-implements hostname domain if using BSD
  var=`hostname -f`
  echo "${var#*.}"
}

# Get the backup folder
bkg_date=`date +%Y-%m-%d:%H:%M:%S`
bkg_folder="$HOME/DotFiles/backups/$bkg_date"

# and this host domain
host_domain="`hostname -d 2> /dev/null || hostname_d`"

get_dotfile(){
  base_1=`basename $1`
  echo "$HOME/DotFiles/${base_1#.}"
}

backup(){
  base_1=`basename $1`
  dest="$2" && [ -z "$dest" ] && dest="`get_dotfile "$1"`"
  if [ -e "$1" -o -L "$1" ]; then
    file=`readlink -f "$1" 2>/dev/null || readlink_f "$1"`
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
  dest=$2 && [ -z "$dest" ] && dest="`get_dotfile "$1"`"
  if [ -e "$1" ]; then
    file=`readlink -f "$1" 2>/dev/null || readlink_f "$1"`
    if [ "$file" != "$dest" ]; then
      echo "WARN: For some reason file $1 still exists."
    fi
  else
    echo "Creating link '$1' to '$dest'..."
    ln -s "$dest" "$1"
  fi
}

files=(\
       "$HOME/.ssh/config" \
       "$HOME/.screenrc" \
       "$HOME/.zshrc" \
       "$HOME/.dircolors.256dark" \
       "$HOME/.shell_prompt.sh" \
       "$HOME/.vimrc" \
       "$HOME/.vim" \
      )

for file in ${files[@]}; do
  backup "$file" && link_dotfile "$file"
done

if test "$host_domain" = "lps.ufrj.br"; then
  #${files[${#files[*]}+1]}=".bashrc"
  backup ".bashrc" "$HOME/DotFiles/bashrc_lps"
fi

if test "$host_domain" = "lps.ufrj.br"; then
  if ! type zsh > /dev/null 2> /dev/null; then
    # Zsh
    zsh_tgz_file=$HOME/DotFiles/zsh.tgz
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

if ! test -e $HOME/.oh-my-zsh; then
  git clone https://github.com/wsfreund/oh-my-zsh.git $HOME/.oh-my-zsh
fi

# TODO Install vim if on cern.

echo "Installing Vimhalla..."
git clone https://github.com/gmarik/Vundle.vim.git $HOME/DotFiles/vim/bundle/Vundle.vim > /dev/null 2> /dev/null || true
vim -E -c VundleInstall -c qa

# TODO Install NERD Font and add echo message to tell user to change font!

