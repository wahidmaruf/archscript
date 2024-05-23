#!/bin/bash

GREEN='\033[0;32m'
NC='\033[0m'
RED='\033[0;31m'
PURPLE='\033[0;35m'

if [[ $EUID -ne 0 ]]; then
    echo "${RED}This script must be run as root.${NC}"
    exit 1
fi

success_packages=()
failure_packages=()

rpm_packages=(
    "mpv"
    "mangohud"
    "timeshift"
    "google-chrome-stable"
    "asusctl"
    "npm"
    "docker"
    "virtualbox"
    "vlc"
    "smplayer"
    "gimp"
    "inkscape"
    "okular"
    "qbittorrent"
    "libreoffice"
    "vim-enhanced"
    "dbeaver"
    "discord"
    "openrazer-meta"
    "inxi"
    "lm_sensors"
    "steam"
    "foliate"
    "calibre"
    "cmake"
    "clang"
    "ninja-build"
    "pkg-config"
)

flatpak_packages=(
    "com.getpostman.Postman"
    "notion-app"
    "com.github.Murmele.Gittyup"
    "com.github.johnfactotum.Foliate"
    "com.github.micahflee.torbrowser-launcher"
)

install_rpm_package() {
    echo -e "\n${GREEN}Installing RPM package $1...${NC}\n"
    sudo dnf install -y "$1"
    if [ $? -eq 0 ]; then
        success_packages+=("$1")
    else
        failure_packages+=("$1")
    fi
}

install_flatpak_package() {
    echo -e "\n${PURPLE}Installing Flatpak package $1...${NC}\n"
    sudo flatpak install -y --noninteractive flathub "$1"
    if [ $? -eq 0 ]; then
        success_packages+=("$1")
    else
        failure_packages+=("$1")
    fi
}

sudo bash <<EOF

echo -e "\n${GREEN}Updating system and installing basic tools...${NC}"
dnf update -y && dnf install -y dnf-plugins-core

echo -e "\n${GREEN}Enabling RPM Fusion repositories...${NC}"
dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-\$(rpm -E %fedora).noarch.rpm
dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-\$(rpm -E %fedora).noarch.rpm

dnf install fedora-workstation-repositories
dnf config-manager --set-enabled google-chrome
dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc

if ! command -v flatpak &> /dev/null; then
    echo -e "\n${GREEN}flatpak is not installed. Installing flatpak...${NC}"
    dnf install -y flatpak
else
    echo -e "\n${GREEN}flatpak is installed.${NC}\n"
fi

echo -e "\n${GREEN}Adding Flathub repository for flatpak...${NC}"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo


wget https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2023.3.1.19/android-studio-2023.3.1.19-linux.tar.gz
tar -xzvf android-studio-2023.3.1.19-linux.tar.gz
sudo mv android-studio /opt/
rm android-studio-2023.3.1.19-linux.tar.gz
sudo tee /usr/share/applications/android-studio.desktop > /dev/null <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Android Studio
Exec=/opt/android-studio/bin/studio.sh
Icon=/opt/android-studio/bin/studio.png
Comment=Android IDE
Categories=Development;IDE;
Terminal=false
EOF

EOF

for package in "${rpm_packages[@]}"; do
    install_rpm_package "$package"
done

for package in "${flatpak_packages[@]}"; do
    install_flatpak_package "$package"
done

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

