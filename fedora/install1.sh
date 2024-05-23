#!/bin/bash

# Color variables
GREEN='\033[0;32m'
NC='\033[0m' # No Color
RED='\033[0;31m'
PURPLE='\033[0;35m'

# Arrays to store success and failure messages
success_packages=()
failure_packages=()

# Update system and install basic tools
echo -e "\n${GREEN}Updating system and installing basic tools...${NC}"
sudo dnf update -y && sudo dnf install -y dnf-plugins-core

# Enable RPM Fusion repositories
echo -e "\n${GREEN}Enabling RPM Fusion repositories...${NC}"
sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Check if flatpak is installed
if ! command -v flatpak &> /dev/null; then
    echo -e "\n${GREEN}flatpak is not installed. Installing flatpak...${NC}"
    sudo dnf install -y flatpak
else
    echo -e "\n${GREEN}flatpak is installed.${NC}\n"
fi

# Add Flathub repository for flatpak
echo -e "\n${GREEN}Adding Flathub repository for flatpak...${NC}"
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Function to install RPM packages
install_rpm_package() {
    echo -e "\n${GREEN}Installing RPM package $1...${NC}\n"
    sudo dnf install -y "$1"

    # Check the exit status of the last command
    if [ $? -eq 0 ]; then
        success_packages+=("$1")
    else
        failure_packages+=("$1")
    fi
}

# Function to install Flatpak packages
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
install_rpm_package mpv

# Install Postman
install_flatpak_package com.getpostman.Postman

# Install Document Viewer and Editor
install_flatpak_package notion-app # No official flatpak, replace with alternative if needed

# Games packages
install_rpm_package protonup-qt
install_rpm_package lutris 
install_flatpak_package com.heroicgameslauncher.hgl 
install_rpm_package mangohud

# Install Utility
install_flatpak_package com.surfshark.SurfsharkVPN
install_rpm_package timeshift

# Install Browsers
install_rpm_package google-chrome-stable
install_flatpak_package org.librewolf.Librewolf

# Asus Fan Control
install_rpm_package asusctl # lm_sensors also required

# Keyboard
install_rpm_package keyman
install_flatpak_package razergenie # No official flatpak, replace with alternative if needed

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
