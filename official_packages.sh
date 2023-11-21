#!/bin/bash

# Color variables
GREEN='\033[0;32m'
NC='\033[0m' # No Color
RED='\033[0;31m'
PURPLE='\033[0;35m'

# Check if script is run as root
if [[ $EUID -ne 0 ]]; then
    echo "${RED}This script must be run as root.${NC}"
    exit 1
fi

# Arrays to store success and failure messages
success_packages=()
failure_packages=()

# Function to install a package
install_package() {
    echo -e "\n${PURPLE}Installing $1...${NC}\n"
    pacman -S --noconfirm --needed $1 --quiet

    # Check the exit status of the last command
    if [ $? -eq 0 ]; then
        success_packages+=("$1")
    else
        failure_packages+=("$1")
    fi
}

# Install IDE
install_package npm

# Install Virtualization
install_package docker
install_package virtualbox
install_package firefox
# Install Media Players
install_package vlc
install_package gimp

# Install and Editor
install_package okular

# Install Torrent
install_package qbittorrent

# Install LIbre Office
install_package libreoffice-fresh 

# Required for Linux development
install_package ninja
install_package cmake
install_package clang

# Others
install_package	bitwarden # Bitwarden Password Manager
install_package neofetch
install_package vi

# # Install Calibre
echo -e "\n${PURPLE}Installing Calibre${NC}\n"
wget -nv -O- https://download.calibre-ebook.com/linux-installer.sh | sudo sh /dev/stdin

# Activate Multilib repository
echo -e "\n${PURPLE}Activating multilib Repo${NC}\n"
awk '$0=="#[multilib]"{c=2} c&&c--{sub(/#/,"")} 1' /etc/pacman.conf > /tmp/pacman.conf.tmp && mv /tmp/pacman.conf.tmp /etc/pacman.conf

pacman -Sy # Update the repository database
install_package steam

install_package foliate # Document Viewer

install_package flatpak

# Display results
echo -e "\n${GREEN}Packages successfully installed:${NC}"
for package in "${success_packages[@]}"; do
    echo -e "${GREEN}- $package${NC}"
done

if [ ${#failure_packages[@]} -eq 0 ]; then
    echo -e "\n${GREEN}Congrats! No installation error${NC}"
else
    echo -e "\n${RED}Packages with installation errors:${NC}"
    for package in "${failure_packages[@]}"; do
        echo -e "${RED}- $package${NC}"
    done
fi
