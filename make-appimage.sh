#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q d1x-rebirth-git | awk '{print $2; exit}') # example command to get version of application here
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/pixmaps/d1x-rebirth.xpm
export DESKTOP=/usr/share/applications/d1x-rebirth.desktop
export DEPLOY_OPENGL=1

# Deploy dependencies
quick-sharun /usr/bin/d1x-rebirth

# Additional changes can be done in between here

# Turn AppDir into AppImage
quick-sharun --make-appimage
