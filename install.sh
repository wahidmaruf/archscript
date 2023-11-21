#!/bin/bash

# Prompt for sudo password at the beginning
sudo echo "Prompting for sudo password..."

# Run scripts that need sudo
sudo bash grub.sh
sudo bash official_packages.sh

# Run scripts that don't need sudo
bash aur_packages.sh
bash dev_packages.sh
