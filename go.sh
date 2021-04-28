#!/bin/sh
# This is the first script to run although it is idempotent hence rerunnable
#
trap 'ret=$?; test $ret -ne 0 && printf "failed\n\n" >&2; exit $ret' EXIT
set -e

if [ -z "$CASA" ] ; then
  cd $(dirname $0)
  CASA=$PWD
fi

. common.sh


# Check if root user is enables:
dscl . -read /Users/root Password
if [ "$?" != "0" ] ; then
  dsenableroot
fi

# Install xcode command line tools
xcode-select -p
if [  "$?" != "0" ] ; then
  echo "Installing xcode tools. Please restart this script once done"
  xcode-select --install
  exit
fi

ensure_dir $HOME/bin

if [ ! -L ~/.dotfiles ] ; then
  ln -s $CASA/dotfiles ~/.dotfiles
fi

if [ ! -L ~/.config ] ; then
  ln -s $CASA/dotfiles/config ~/.config
fi

for f in aliases gemrc  gitconfig gitignore oh-my-zsh tmux.conf vim vimrc zshrc zshenv ; do 
	if [ ! -L ~/.$f ] ; then
		ln -s ~/.dotfiles/$f ~/.$f
	fi
done

HOMEBREW_PREFIX="/usr/local"

if [ -d "$HOMEBREW_PREFIX" ]; then
  if ! [ -r "$HOMEBREW_PREFIX" ]; then
    sudo chown -R "$LOGNAME:admin" /usr/local
  fi
else
  sudo mkdir "$HOMEBREW_PREFIX"
  sudo chflags norestricted "$HOMEBREW_PREFIX"
  sudo chown -R "$LOGNAME:admin" "$HOMEBREW_PREFIX"
fi


update_shell() {
  local shell_path;
  shell_path="$(command -v zsh)"

  fancy_echo "Changing your shell to zsh ..."
  if ! grep "$shell_path" /etc/shells > /dev/null 2>&1 ; then
    fancy_echo "Adding '$shell_path' to /etc/shells"
    sudo sh -c "echo $shell_path >> /etc/shells"
  fi
  sudo chsh -s "$shell_path" "$USER"
}

case "$SHELL" in
  */zsh)
    if [ "$(command -v zsh)" != '/usr/local/bin/zsh' ] ; then
      update_shell
    fi
    ;;
  *)
    update_shell
    ;;
esac


if ! command -v brew >/dev/null; then
  fancy_echo "Installing Homebrew ..."
    curl -fsS \
      'https://raw.githubusercontent.com/Homebrew/install/master/install' | ruby

    append_to_zshrc '# recommended by brew doctor'

    # shellcheck disable=SC2016
    append_to_zshrc 'export PATH="/usr/local/bin:$PATH"' 1

    export PATH="/usr/local/bin:$PATH"
fi

if brew list | grep -Fq brew-cask; then
  fancy_echo "Uninstalling old Homebrew-Cask ..."
  brew uninstall --force brew-cask
fi

fancy_echo "Updating Homebrew formulae ..."
brew update --force # https://github.com/Homebrew/brew/issues/1151
brew bundle --file=- <<EOF
tap "thoughtbot/formulae"
tap "homebrew/services"
tap "universal-ctags/universal-ctags"
tap "heroku/brew"

# Unix
brew "universal-ctags", args: ["HEAD"]
brew "git"
brew "openssl"
brew "rcm"
brew "reattach-to-user-namespace"
brew "the_silver_searcher"
brew "tmux"
brew "vim"
brew "watchman"
brew "zsh"

# Heroku
brew "heroku/brew/heroku"
brew "parity"

# GitHub
brew "hub"

# Image manipulation
brew "imagemagick"

# Programming language prerequisites and package managers
brew "libyaml" # should come after openssl
brew "coreutils"
brew "yarn"
cask "gpg-suite"

# Databases
brew "postgres", restart_service: :changed
brew "redis", restart_service: :changed
EOF

fancy_echo "Update heroku binary ..."
brew unlink heroku
brew link --force heroku

fancy_echo "Configuring asdf version manager ..."
if [ ! -d $SCRATCH ] ; then
	echo "Please create the Scratch volume ($SCRATCH) and restart"
	exit 1
fi

if [ ! -d "$SCRATCH/asdf" ]; then
  git clone https://github.com/asdf-vm/asdf.git $SCRATCH/asdf --branch v0.5.0
fi
[ -L $HOME/.asdf ] || ln -s $SCRATCH/asdf $HOME/.asdf

# shellcheck disable=SC1090
source "$HOME/.asdf/asdf.sh"
add_or_update_asdf_plugin "ruby" "https://github.com/asdf-vm/asdf-ruby.git"
add_or_update_asdf_plugin "nodejs" "https://github.com/asdf-vm/asdf-nodejs.git"
add_or_update_asdf_plugin "python" "https://github.com/danhper/asdf-python.git"

fancy_echo "Installing latest Ruby ..."
install_asdf_language "ruby"
gem update --system
number_of_cores=$(sysctl -n hw.ncpu)
bundle config --global jobs $((number_of_cores - 1))

fancy_echo "Installing latest Node ..."
bash "$HOME/.asdf/plugins/nodejs/bin/import-release-team-keyring"
install_asdf_language "nodejs"

fancy_echo "Installing latest Python ..."
install_asdf_language "python"

. $CASA/local.sh
# DO NOT add anythig below this line. Add it to local.sh instead.
