#!/bin/bash

# Install yay package
pacman -S --needed base-devel git
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
cd ../
rm -rf yay


# Function to install packages from external sources
install_aur_package() {
    echo -e "\n\e[1;35mInstalling $1...\e[0m\n"
    yay -S --noconfirm --needed $1
}

# Install Browsers
install_aur_package google-chrome
install_aur_package librewolf

# Install IDE
install_aur_package android-studio
install_aur_package pycharm-community
install_aur_package dbeaver

# Install Media Players
install_aur_package mpv

# Install Postman
install_aur_package postman-bin

# Install Document Viewer and Editor
install_aur_package notion-app

# Install VPN
install_aur_package surfshark-vpn

echo "All packages installed successfully."