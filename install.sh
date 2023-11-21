#!/bin/bash

GREEN='\033[0;32m'
BROWN='\033[0;33m'
NC='\033[0m' # No Color

# Prompt for sudo password at the beginning
sudo echo "Prompting for sudo password..."

# Install paru
source paru_install.sh
install_paru

# Run scripts that need sudo
sudo bash grub.sh
sudo bash official_packages.sh

# Run scripts that don't need sudo
bash aur_packages.sh
bash dev_packages.sh

# Accept Android Licenses
echo -e "\n${GREEN}Change /opt/android-sdk folder permission${NC}"
sudo chmod 777 /opt/android-sdk

echo -e "\n${BROWN}All Done${NC}"
