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

echo "Building stable version of ECWolf..."
echo "---------------------------------------------------------------"
REPO="https://github.com/ECWolfEngine/ECWolf"
VERSION="$(curl -s https://api.github.com/repos/ECWolfEngine/ECWolf/tags | grep '"name"' | grep -v 'pre' | head -1 | cut -d '"' -f 4)"
git clone --branch "$VERSION" --depth 1 "$REPO" ./ECWolf
echo "$VERSION" > ~/version

mkdir -p ./AppDir/bin
cmake -S ./ECWolf -B build -DCMAKE_BUILD_TYPE=Release -DGPL=ON
cmake --build build -j$(nproc)
mv -v build/ecwolf build/ecwolf.pk3 ./AppDir/bin
