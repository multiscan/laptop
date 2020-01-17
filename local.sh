#!/bin/sh

if [ -z "$CASA" ] ; then
  cd $(dirname $0)
  CASA=$PWD
fi

# brew tap thoughtbot/formulae
brew install rcm

if [ ! -d $HOME/dotfiles ] ; then
  git clone https://github.com/thoughtbot/dotfiles.git $HOME/dotfiles
  env RCRC=$HOME/dotfiles/rcrc rcup
  [ -L $HOME/dotfiles.local ] || ln -s $CASA/dotfiles.local $HOME/dotfiles.local
fi
