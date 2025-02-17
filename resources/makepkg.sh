#!/bin/bash

set -e

sudo pacman -Syu --noconfirm

if [[ -z "$BUILD_PATH" ]]; then
    BUILD_PATH=$(pwd)
fi

if [[ -z "$EXPORT_PATH" ]]; then
    EXPORT_PATH="$BUILD_PATH"/export
fi

if [[ ! -d "$EXPORT_PATH" ]]; then
    sudo mkdir -p "$EXPORT_PATH"
    sudo chown "$(stat -c '%u:%g' "$BUILD_PATH"/PKGBUILD)" "$EXPORT_PATH"
fi

cp -r "$BUILD_PATH" /tmp/build
if [[ -d /tmp/build/keys/pgp ]]; then
    echo '==> Importing PGP keys...'
    gpg --import /tmp/build/keys/pgp/*.asc
fi

source PKGBUILD
if [[ ${#validpgpkeys[@]} > 0 ]]; then
    echo '==> Fetching PGP keys...'
    gpg --recv-keys ${validpgpkeys[@]}
fi

yay -Bi /tmp/build
sudo mv /tmp/build/*pkg.tar* "$EXPORT_PATH"
sudo chown "$(stat -c '%u:%g' "$BUILD_PATH"/PKGBUILD)" "$EXPORT_PATH"/*pkg.tar*
