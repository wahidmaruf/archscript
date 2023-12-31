#!/bin/bash

# Color variables
GREEN='\033[0;32m'
NC='\033[0m' # No Color
RED='\033[0;31m'
PURPLE='\033[0;35m'

# Arrays to store success and failure messages
success_packages=()
failure_packages=()

# Install paru
source paru_install.sh
install_paru

# Check if flatpak is installed
if ! command -v flatpak &> /dev/null; then
    echo -e "\n${GREEN}flatpak is not installed. Some Package installation may fail.${NC}"
else
    echo -e "\n${GREEN}flatpak is installed.${NC}\n"
fi

# Function to install packages from external sources
install_aur_package() {
    echo -e "\n${GREEN}Installing AUR package $1...${NC}\n"
    paru -S --noconfirm --needed --quiet "$1" 

    # Check the exit status of the last command
    if [ $? -eq 0 ]; then
        success_packages+=("Flatpak $1")
    else
        failure_packages+=("Flatpak $1")
    fi
}

install_flatpak_package() {
    echo -e "\n${PURPLE}Installing Flatpak package $1...${NC}\n"
    flatpak install -y --noninteractive flathub "$1"

    # Check the exit status of the last command
    if [ $? -eq 0 ]; then
        success_packages+=("$1")
    else
        failure_packages+=("$1")
    fi
}

# Install Media Players
install_aur_package mpv

# Install Postman
install_aur_package postman-bin

# Install Document Viewer and Editor
install_aur_package notion-app

# Games packages
install_aur_package protonup-qt-bin
install_aur_package lutris-git 
install_aur_package heroic-games-launcher-bin 
install_aur_package mangohud-git # A Vulkan overlay layer for monitoring FPS, temperatures, CPU/GPU load and more.

# Install Utility
install_aur_package surfshark-client # Surfshark VPN Client App
install_aur_package timeshift-autosnap # Backup System

# Install Browsers
install_aur_package google-chrome 
install_aur_package librewolf-bin 

# Asus Fan Control
install_aur_package asusctl # lm_sensors also required

# Keyboard
install_aur_package keyman 
install_aur_package razergenie # Razer Peripherals UI

install_flatpak_package com.github.Murmele.Gittyup # Git Client
install_flatpak_package com.github.johnfactotum.Foliate # EBook Reader
install_flatpak_package com.github.micahflee.torbrowser-launcher


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
