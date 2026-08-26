#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q ecwolf | awk '{print $2; exit}') # example command to get version of application here
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/pixmaps/ecwolf.png
export DESKTOP=/usr/share/applications/net.maniacsvault.ecwolf.desktop
export DEPLOY_GTK=1
export GTK_DIR=gtk-3.0
export DEPLOY_OPENGL=1

# Deploy dependencies
quick-sharun /usr/bin/ecwolf
cp /usr/share/ecwolf/ecwolf.pk3 ./AppDir/bin
echo 'SHARUN_WORKING_DIR=${SHARUN_DIR}/bin' >> ./AppDir/.env

# Turn AppDir into AppImage
quick-sharun --make-appimage
