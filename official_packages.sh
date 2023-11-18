#!/bin/bash

# Check if script is run as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root."
    exit 1
fi

# Function to install a package
install_package() {
    echo "Installing $1..."
    pacman -S --noconfirm --needed $1
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
install_package acroread

# Install Steam & wine
install_package steam
install_package proton
install_package wine

# Install Torrent
install_package qbittorrent

# Install misc
install_package libreoffice-fresh 

echo "All packages installed successfully."