
## error codes
chsherrno=1;
mvzshrcerrno=2;
mvvimrcerno=3;
mvvimerno=4;

if test $(basename $SHELL) != "zsh"; then 
  chsh -s $(which zsh) || return $chsherrno;
fi

if ! test -e $HOME/.oh-my-zsh; then
  git clone https://github.com/wsfreund/oh-my-zsh.git $HOME/.oh-my-zsh
fi

if test -e $HOME/.zshrc -a \! -e $HOME/.zshrc_bkg; then
  mv $HOME/.zshrc $HOME/.zshrc_bkg || return $mvzshrcerrno;
fi

if test -e $HOME/.dircolors.256dark -a \! -e $HOME/.dircolors.256dark_bkg; then
  mv $HOME/.dircolors.256dark $HOME/.dircolors.256dark_bkg || return $mvzshrcerrno;
fi

if test -e $HOME/.shell_prompt.sh -a \! -e $HOME/.shell_prompt_bkg.sh; then
  mv $HOME/.shell_prompt.sh $HOME/.shell_prompt_bkg.sh || return $mvzshrcerrno;
fi

if test -e $HOME/.vimrc -a \! -e $HOME/.vimrc_bkg; then
  mv $HOME/.vimrc $HOME/.vimrc_bkg || return $mvvimrcerno;
fi

if test -e $HOME/.vim -a \! -e $HOME/.vim_bkg; then
  mv $HOME/.vim $HOME/.vim_bkg || return $mvvimerno;
fi

ln -s $HOME/DotFiles/zshrc $HOME/.zshrc
ln -s $HOME/DotFiles/dircolors.256dark $HOME/.dircolors.256dark
ln -s $HOME/DotFiles/shell_prompt.sh $HOME/.shell_prompt.sh
ln -s $HOME/DotFiles/shell_prompt_no_pl.sh $HOME/.shell_prompt_no_pl.sh

# It is missing the +lua vim installation
ln -s $HOME/DotFiles/vimrc $HOME/.vimrc

ln -s $HOME/DotFiles/vim $HOME/.vim
git clone https://github.com/gmarik/Vundle.vim.git $HOME/DotFiles/vim/bundle/Vundle.vim
vim \+VundleInstall\! \+qall

