#!/bin/sh
# This is the first script to run although it is idempotent hence rerunnable
#

CASA=$(dirname $0)
cd $(dirname $0)
CASA=$PWD

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

if [ ! -d laptop ] ; then
  pwd
  git clone https://github.com/thoughtbot/laptop.git 
fi

if [ -f $CASA/laptop/mac ] ; then
  sh $casa/laptop/mac | tee $CASA/laptop.log
fi

. $CASA/local.sh
# DO NOT add anythig below this line. Add it to local.sh instead.
