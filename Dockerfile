FROM archlinux:base-devel-20241215.0.289170⁠

LABEL maintainer="michal@sotolar.com"

RUN set -ex; \
    useradd -m build; \
    pacman -Syu --noconfirm --needed base-devel git

COPY resources/sudoers /etc/sudoers.d/build
COPY resources/gpg.conf /home/build/.gnupg/gpg.conf

USER build
WORKDIR /home/build

RUN set -ex; \
    sudo chmod 0700 /home/build/.gnupg; \
    sudo chown -R build:build /home/build/.gnupg; \
    git config --global init.defaultBranch master; \
    git clone https://aur.archlinux.org/yay.git; \
    env -C yay makepkg -cfisrc --noconfirm; \
    sudo rm -rf yay

COPY makepkg.sh /usr/local/bin/makepkg.sh

ENTRYPOINT ["makepkg.sh"]
