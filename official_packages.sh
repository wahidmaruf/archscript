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
    pacman -S --noconfirm --needed --quiet $1

    # Check the exit status of the last command
    if [ $? -eq 0 ]; then
        success_packages+=("$1")
    else
        failure_packages+=("$1")
    fi
}

pacman -Syu --noconfirm --needed --quiet

# Specify the line to uncomment
line_color="Color"
# Uncomment the specified line in /etc/pacman.conf
sed -i '/^#Color/a ILoveCandy' /etc/pacman.conf
sed -i "s/^#${line_color}/${line_color}/" /etc/pacman.conf # See color text in terminal

pacman -Syy --noconfirm --needed --quiet  # -Syy means forceful refresh of pacman database sync

install_package pacman-contrib
systemctl enable paccache.timer


# Install addtional linux kernels as a safty precaution
install_package linux-lts
install_package linux-lts-headers
install_package linux-hardened
install_package linux-hardened-headers
install_package linux-zen
install_package linux-zen-headers

# Install and enable ufw (Uncomplicated Firewall)
install_package ufw
systemctl enable ufw
systemctl start ufw

# Install IDE
install_package npm

# Install Virtualization
install_package docker
install_package virtualbox

install_package firefox

# Install Media Players
install_package vlc
install_package smplayer-git
install_package smplayer-skins-git

# Install Graphics software
install_package gimp
install_package inkscape

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

# Graphics Drivers
install_package nvidia-open # Required for Turing Nvidia GPU, Current GPU Nvidia 2060
install_package nvidia-utils # Package contains a file which blacklists the nouveau module, so rebooting is necessary
install_package nvidia-settings # Configure many options using either CLI or GUI

# Others
install_package	bitwarden # Bitwarden Password Manager
install_package neofetch
install_package vi
install_package dbeaver # Database GUI Client
install_package	discord
install_package	openrazer-daemon # Open Razer background service for razer peripherals e.g. keyboard, mouse
install_package inxi # Full featured CLI system information tool
install_package lm_sensors # Required to control cpu fans

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
