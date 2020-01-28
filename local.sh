#!/bin/sh
set -e

if [ -z "$CASA" ] ; then
  cd $(dirname $0)
  CASA=$PWD
fi

. common.sh

if [ ! -L ~/.dotfiles ] ; then
  ln -s $CASA/dotfiles ~/.dotfiles
fi

for f in zshrc zshenv aliases vimrc tmux.conf gitconfig gitignore gemrc ; do 
	if [ ! -L ~/.$f ] ; then
		ln -s ~/.dotfiles/$f ~/.$f
	fi
done

if [ ! -L $HOME/bin/sute ] ; then
  ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" $HOME/bin/sute
fi

ensure_cask aquaterm
ensure_cask bean                       # Simple rtf text editor
ensure_cask calibre
ensure_cask carbon-copy-cloner
ensure_cask drawio
ensure_cask firefox
ensure_cask handbrake
ensure_cask idagio
ensure_cask keybase
ensure_cask kindle
ensure_cask kitematic                  # GUI for docker
ensure_cask launchbar
ensure_cask love
ensure_cask mactex
ensure_cask manuscripts                # Yet another wordprocessor
ensure_cask musescore
ensure_cask notable
ensure_cask obs
ensure_cask omnidb
ensure_cask osxfuse
ensure_cask pencil
ensure_cask postman
ensure_cask sequel-pro                 # SQL client
ensure_cask shiftit
ensure_cask spotify
ensure_cask sublime-text
ensure_cask telegram
ensure_cask tigervnc-viewer
ensure_cask virtualbox
ensure_cask virtualbox-extension-pack
ensure_cask visual-studio-code