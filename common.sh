#!/bin/sh

if [ -z "$CASA" ] ; then
  cd $(dirname $0)
  CASA=$PWD
fi

SCRATCH=/Volumes/Scratch
PRIV=/Volumes/Priv

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

ensure_dir() {
  [ -d $1 ] || mkdir -p $1
}

fancy_echo() {
  local fmt="$1"; shift

  # shellcheck disable=SC2059
  printf "\\n$fmt\\n" "$@"
}

gem_install_or_update() {
  if gem list "$1" --installed > /dev/null; then
    gem update "$@"
  else
    gem install "$@"
  fi
}

alias install_asdf_plugin=add_or_update_asdf_plugin
add_or_update_asdf_plugin() {
  local name="$1"
  local url="$2"

  if ! asdf plugin-list | grep -Fq "$name"; then
    asdf plugin-add "$name" "$url"
  else
    asdf plugin-update "$name"
  fi
}

install_asdf_language() {
  local language="$1"
  local version
  version="$(asdf list-all "$language" | grep -v "[a-z]" | tail -1)"

  if ! asdf list "$language" | grep -Fq "$version"; then
    asdf install "$language" "$version"
    asdf global "$language" "$version"
  fi
}

