#!/bin/bash

# Backup the original grub configuration file
cp /etc/default/grub /etc/default/grub.bak

# Set GRUB_TIMEOUT to 30
sed -i 's/^GRUB_TIMEOUT=0/GRUB_TIMEOUT=30/' /etc/default/grub

# Uncomment GRUB_DISABLE_OS_PROBER line and set it to false
sed -i 's/^#GRUB_DISABLE_OS_PROBER=false/GRUB_DISABLE_OS_PROBER=false/' /etc/default/grub

pacman -S os-prober --noconfirm --needed --quiet
pacman -S amd-ucode --noconfirm --needed --quiet

grub-mkconfig -o /boot/grub/grub.cfg