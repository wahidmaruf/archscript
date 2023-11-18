#!/bin/bash

# Check if script is run as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root."
    exit 1
fi

# Install yay package
pacman -S --needed base-devel git
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
cd ../
rm -rf yay

# Function to install a package
install_package() {
    echo "Installing $1..."
    pacman -S --noconfirm --needed $1
}

# Function to install packages from external sources
install_external_package() {
    echo "Installing $1..."
    yay -S --noconfirm --needed $1
}

# Install Browsers
install_package firefox
install_external_package google-chrome
install_external_package librewolf
install_package tor

# Install Java (OpenJDK)
install_package jdk-openjdk

# Install IDE
install_external_package android-studio
install_package vscodium # Alternative to VS Code
install_external_package pycharm-community
install_package fork
install_external_package dbeaver

# Install Virtualization
install_package docker
install_package virtualbox

# Install Media Players
install_package vlc
install_external_package mpv
install_package gimp

# Install Postman
install_external_package postman-bin

# Install Document Viewer and Editor
install_package calibre
install_package acroread
install_external_package notion-app

# Install Steam & wine
install_package steam
install_package proton
install_package wine

# Install VPN
install_external_package surfshark-vpn

# Install Torrent
install_package qbittorrent

# Install misc
install_package libreoffice-fresh 

echo "All packages installed successfully."