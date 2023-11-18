#!/bin/bash

# Check if script is run as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root."
    exit 1
fi

# Arrays to store success and failure messages
success_packages=()
failure_packages=()

# Function to install a package
install_package() {
    echo -e "\n\e[1;35mInstalling $1...\e[0m\n"
    pacman -S --noconfirm --needed $1

    # Check the exit status of the last command
    if [ $? -eq 0 ]; then
        success_packages+=("$1")
    else
        failure_packages+=("$1")
    fi
}

# Install Browsers
install_package firefox
install_package tor

# Install Java (OpenJDK)
install_package jdk-openjdk

# Install IDE
install_package vscodium # Alternative to VS Code
install_package npm
install_package fork

# Install Virtualization
install_package docker
install_package virtualbox

# Install Media Players
install_package vlc
install_package gimp

# Install Document Viewer and Editor
install_package calibre
install_package okular

# Install Steam & wine
install_package steam
install_package proton
install_package wine

# Install Torrent
install_package qbittorrent

# Install misc
install_package libreoffice-fresh 

# Display results
echo -e "\n\e[1;32mPackages successfully installed:\e[0m"
for package in "${success_packages[@]}"; do
    echo -e "\e[1;32m- $package\e[0m"
done

echo -e "\n\e[1;31mPackages with installation errors:\e[0m"
for package in "${failure_packages[@]}"; do
    echo -e "\e[1;31m- $package\e[0m"
done
