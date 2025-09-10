FROM archlinux:base-devel-20250907.0.417472

LABEL org.opencontainers.image.url="https://github.com/misotolar/docker-makepkg"
LABEL org.opencontainers.image.description="Arch Linux build environment"
LABEL org.opencontainers.image.authors="Michal Sotolar <michal@sotolar.com>"

RUN set -ex; \
    useradd -m build; \
    pacman -Syu --noconfirm --needed base-devel git

COPY resources/config/sudoers /etc/sudoers.d/build
COPY resources/config/gpg.conf /home/build/.gnupg/gpg.conf

USER build
WORKDIR /home/build

RUN set -ex; \
    sudo chmod 0700 /home/build/.gnupg; \
    sudo chown -R build:build /home/build/.gnupg; \
    git config --global init.defaultBranch master; \
    git clone https://aur.archlinux.org/yay.git; \
    env -C yay makepkg -cfisrc --noconfirm; \
    sudo rm -rf yay

COPY resources/makepkg.sh /usr/local/bin/makepkg.sh

ENTRYPOINT ["makepkg.sh"]
