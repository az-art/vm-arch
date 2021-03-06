# vm-arch

`vm-arch` is a set of Packer template, installation scripts, Ansible playbook, Vagrantfile and Makefile which provides automated build of the Arch Linux. 
 
## Dependencies

You'll need the following dependencies to start:

* packer (for base box creation)
* vagrant (for vagrant images)
* make (https://gist.github.com/evanwill/0207876c3243bbb6863e65ec5dc3f058)
* virtualbox (for virtualbox support)
 
## Overview

By default will be created VM will configuration: 

* 64-bit
* 40 GB disk
* 8192 MB memory
* root partition (ext4)
* swap partition
* //Only a single /root partition (ext4)
* //No swap
* Includes the base and base-devel package groups, grub2
 * OpenSSH is also installed and enabled on boot
 
## Packer variables
 
Overview over all variables you can set in `archlinux-x86_64.json` or
`Makefile`:

* `arch_version`: Arch version to install (default: 64-bit).
* `compression_level`: compression level of .box (default: 6).
* `cpus`: this specifies the number of cores for your VM (default:2).
* `memory`: this specifies the size of the RAM in bytes (default: 512).
* `disk_size`: this specifices the disk size in bytes (default: 20000).
* `headless`: this sets GUI on or off (default: false).
* `iso_checksum`: the url to the checksum file. This can be an url or a filepath beginning with `file://` (default: 0755f656917eb201bff8f702f33c2e2fe149d69d).
* `iso_checksum_type`: this specifies the hashing algorithm for the checksum (default: sha1).
* `mirror`: mirror URL (default: http://mirrors.kernel.org/archlinux).
* `ssh_timeout`: specify for how long packer will try to access VM (default: 60m).


## How to start the build process locally
(Optional) Edit the `archlinux-x86_64.json` of `ARG` variable in a Makefile before you start the build.

Execute following commands:
* `make buld` - build packer image and convert it to box.
* `make register` - register Packer image as a `arch` in Vagrant library.
* `make up` - create VirtualBox virtual machine using Vagrant.

## Post-processors
* vagrant
* ansible

## Ansible roles
* `arch-xfce4`: following role will install: 
    * xorg package, xfce4 package, xfce4-goodies package, lightdm, lightdm-gtk-greeter 
    * openbox, conky, tint2, feh, nitrogen, git, wget, unzip, python-pip, ranger, terminator, vim e.t.c
     