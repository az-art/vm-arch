#!/bin/bash

set -e
set -x

if [ "$PACKER_BUILDER_TYPE" != "virtualbox-iso" ]; then
  exit 0
fi

#sudo pacman -S --noconfirm linux-headers
#sudo pacman -S --noconfirm virtualbox-guest-utils
printf '2\nY\n' | pacman -S virtualbox-guest-utils
sudo systemctl enable vboxservice
