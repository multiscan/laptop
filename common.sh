#!/bin/sh

if [ -z "$CASA" ] ; then
  cd $(dirname $0)
  CASA=$PWD
fi

ensure_brew() {
  p=$1
  cf=$CASA/cache/brewlist.txt
  [ -d $(dirname $cf) ] || mkdir -p $(dirname $cf)
  [ -f $cf ] || brew list -1 > $cf
  if egrep -q "^$p\$"  $cf ; then
    echo "$p already installed"
  else
    brew install $p
    brew list -1 > $cf
  fi
}

ensure_cask() {
  p=$1
  cf=$CASA/cache/casklist.txt
  [ -d $(dirname $cf) ] || mkdir -p $(dirname $cf)
  [ -f $cf ] || brew cask list -1 > $cf
  if egrep -q "^$p\$"  $cf ; then
    echo "$p already installed"
  else
    brew cask install $p
    brew cask list -1 > $cf
  fi
}
