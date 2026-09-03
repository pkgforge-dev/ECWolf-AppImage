#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    cmake      \
    sdl2_mixer \
    sdl2_net

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano libdecor-mini

# Comment this out if you need an AUR package
#make-aur-package ecwolf

# If the application needs to be manually built that has to be done down here
echo "Building stable version of UEFITool..."
echo "---------------------------------------------------------------"
REPO="https://github.com/ECWolfEngine/ECWolf"
VERSION="$(curl -s https://api.github.com/repos/ECWolfEngine/ECWolf/releases/latest | grep '"tag_name"' | cut -d '"' -f 4)"
git clone --branch "$VERSION" --depth 1 "$REPO" ./ECWolf
echo "$VERSION" > ~/version

mkdir -p ./AppDir/bin
cd ./ECWolf
cmake -S ./ -B build \
	-DCMAKE_BUILD_TYPE=Release \
	-DGPL=ON
cmake --build build -j$(nproc)
mv -v build/ecwolf build/ecwolf.pk3 ../AppDir/bin
