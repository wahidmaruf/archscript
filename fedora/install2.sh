#!/bin/bash

# Color variables
GREEN='\033[0;32m'
NC='\033[0m' # No Color
RED='\033[0;31m'
PURPLE='\033[0;35m'

# Arrays to store success and failure messages
success_packages=()
failure_packages=()

# Arrays of packages to install
rpm_packages=(
    "mpv" # Media Player
    "protonup-qt" # Game package
    "lutris" # Game package
    "mangohud" # Game package
    "timeshift" # Utility
    "google-chrome-stable" # Browser
    "asusctl" # Asus Fan Control
    "keyman" # Keyboard
)

flatpak_packages=(
    "com.getpostman.Postman" # Postman
    "notion-app" # Document Viewer and Editor (replace if not available)
    "com.heroicgameslauncher.hgl" # Game package
    "com.surfshark.SurfsharkVPN" # Utility
    "org.librewolf.Librewolf" # Browser
    "com.github.Murmele.Gittyup" # Git Client
    "com.github.johnfactotum.Foliate" # EBook Reader
    "com.github.micahflee.torbrowser-launcher" # Tor Browser
)

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
    sudo flatpak install -y --noninteractive flathub "$1"

    # Check the exit status of the last command
    if [ $? -eq 0 ]; then
        success_packages+=("$1")
    else
        failure_packages+=("$1")
    fi
}

# Execute the following block with sudo
sudo bash <<EOF

# Update system and install basic tools
echo -e "\n${GREEN}Updating system and installing basic tools...${NC}"
dnf update -y && dnf install -y dnf-plugins-core

# Enable RPM Fusion repositories
echo -e "\n${GREEN}Enabling RPM Fusion repositories...${NC}"
dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-\$(rpm -E %fedora).noarch.rpm
dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-\$(rpm -E %fedora).noarch.rpm

# Check if flatpak is installed
if ! command -v flatpak &> /dev/null; then
    echo -e "\n${GREEN}flatpak is not installed. Installing flatpak...${NC}"
    dnf install -y flatpak
else
    echo -e "\n${GREEN}flatpak is installed.${NC}\n"
fi

# Add Flathub repository for flatpak
echo -e "\n${GREEN}Adding Flathub repository for flatpak...${NC}"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

EOF

# Install RPM packages
for package in "${rpm_packages[@]}"; do
    install_rpm_package "$package"
done

# Install Flatpak packages
for package in "${flatpak_packages[@]}"; do
    install_flatpak_package "$package"
done

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
