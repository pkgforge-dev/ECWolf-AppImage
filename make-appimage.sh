#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q ecwolf | awk '{print $2; exit}')
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/pixmaps/ecwolf.png
export DESKTOP=/usr/share/applications/net.maniacsvault.ecwolf.desktop
export DEPLOY_OPENGL=1

# Deploy dependencies
quick-sharun /usr/bin/ecwolf
cp /usr/share/ecwolf/ecwolf.pk3 ./AppDir/bin
echo 'SHARUN_WORKING_DIR=${SHARUN_DIR}/bin' >> ./AppDir/.env

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the app normally quits before that time
# then skip this or check if some flag can be passed that makes it stay open
quick-sharun --simple-test ./dist/*.AppImage
