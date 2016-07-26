

if test $(hostname -d) = "lps.ufrj.br"; then
  if ! type zsh &>! /dev/null; then
    # Zsh
    zsh_tgz_file=$HOME/DotFiles/zsh.tgz
    zsh_install_path=$HOME/DotFiles;
    if ! { type zsh > /dev/null 2>&1 || test -f "$zsh_install_path/bin/zsh"; }; then
      if test \! -f $zsh_tgz_file; then
        echo "Downloading zsh..."
        curl -s -L -o $zsh_install_file http://www.zsh.org/pub/zsh.tar.gz
      fi
      echo "Installing zsh..."
      zsh_folder=$(tar xfzv $zsh_tgz_file --skip-old-files -C $DEP_AREA 2> /dev/null)
      test -z "$zsh_folder" && { echo "Couldn't extract zsh!" && return 1;}
      zsh_folder=$(echo $zsh_folder | cut -f1 -d ' ' )
      zsh_folder=$DEP_AREA/${zsh_folder%%\/*}
      if test -e $zsh_install_path; then
        rm -r $zsh_install_path || { echo "Couldn't remove old installed zsh. Please remove it manually on path \"$zsh_install_path\" and try again." && return 1; }
      fi
      pushd $zsh_folder
      ./configure --prefix=$HOME/DotFiles
      make install > /dev/null || { echo "Couldn't make zsh." && return 1; }
      popd - > /dev/null
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

if test -e $HOME/.ssh/config; then
  mv $HOME/.ssh/config $HOME/.ssh/config_bkg || return 1;
fi

if test -e $HOME/.screenrc; then
  mv $HOME/.screenrc $HOME/.screenrc_bkg || return 1;
fi

if test -e $HOME/.zshrc -a \! -e $HOME/.zshrc_bkg; then
  mv $HOME/.zshrc $HOME/.zshrc_bkg || return 1;
fi

if test -e $HOME/.zshrc -a \! -e $HOME/.zshrc_bkg; then
  mv $HOME/.zshrc $HOME/.zshrc_bkg || return 1;
fi

if test -e $HOME/.dircolors.256dark -a \! -e $HOME/.dircolors.256dark_bkg; then
  mv $HOME/.dircolors.256dark $HOME/.dircolors.256dark_bkg || return 1;
fi

if test -e $HOME/.shell_prompt.sh -a \! -e $HOME/.shell_prompt_bkg.sh; then
  mv $HOME/.shell_prompt.sh $HOME/.shell_prompt_bkg.sh || return 1;
fi

if test -e $HOME/.vimrc -a \! -e $HOME/.vimrc_bkg; then
  mv $HOME/.vimrc $HOME/.vimrc_bkg || return 1;
fi

if test -e $HOME/.vim -a \! -e $HOME/.vim_bkg; then
  mv $HOME/.vim $HOME/.vim_bkg || return 1;
fi

if test $(hostname -d) = "lps.ufrj.br"; then
  if test -e $HOME/.profile; then
    mv $HOME/.profile $HOME/.profile_bkg
  fi
  ln -s $HOME/.DotFiles/profile $HOME/.profile
fi

ln -s $HOME/DotFiles/config $HOME/.ssh/config
ln -s $HOME/DotFiles/screenrc $HOME/.screenrc
ln -s $HOME/DotFiles/zshrc $HOME/.zshrc
ln -s $HOME/DotFiles/dircolors.256dark $HOME/.dircolors.256dark
ln -s $HOME/DotFiles/shell_prompt.sh $HOME/.shell_prompt.sh
ln -s $HOME/DotFiles/shell_prompt_no_pl.sh $HOME/.shell_prompt_no_pl.sh

# It is missing the +lua vim installation
ln -s $HOME/DotFiles/vimrc $HOME/.vimrc

ln -s $HOME/DotFiles/vim $HOME/.vim
git clone https://github.com/gmarik/Vundle.vim.git $HOME/DotFiles/vim/bundle/Vundle.vim
vim \+VundleInstall\! \+qall &

