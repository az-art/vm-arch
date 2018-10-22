#!/bin/bash

set -e
set -x

if [ "$PACKER_BUILDER_TYPE" != "virtualbox-iso" ]; then
  exit 0
fi

#sudo pacman -S --noconfirm linux-headers
#sudo pacman -S --noconfirm virtualbox-guest-utils
#printf '2\nY\n' | sudo pacman -S virtualbox-guest-utils
#sudo systemctl enable vboxservice

#sudo pacman -S --noconfirm linux-headers virtualbox-guest-utils virtualbox-guest-modules-arch nfs-utils
#echo 'vboxguest\nvboxsf\nvboxvideo' | sudo tee /etc/modules-load.d/virtualbox.conf > /dev/null
#sudo systemctl enable vboxservice.service
#sudo systemctl enable rpcbind.service

# Add groups for VirtualBox folder sharing
#sudo usermod --append --groups vagrant,vboxsf vagrant

sudo pacman -S --noconfirm virtualbox-guest-utils virtualbox-guest-modules-arch
sudo systemctl enable vboxservice
#echo 'LD_PRELOAD=/lib/VBoxOGL.so' | sudo tee --append /etc/environment