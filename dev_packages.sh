#!/bin/bash

GREEN='\033[0;32m'
NC='\033[0m' # No Color
RED='\033[0;31m'
BROWN='\033[0;33m'

# Arrays to store success and failure messages
success_packages=()
failure_packages=()

# Install paru
source install_paru.sh
install_paru

# Function to install packages from external sources
install_aur_package() {
    echo -e "\n${GREEN}Installing AUR package $1...${NC}\n"
    paru -S --noconfirm --needed --quiet $1 

      # Check the exit status of the last command
    if [ $? -eq 0 ]; then
        success_packages+=("$1")
    else
        failure_packages+=("$1")
    fi
}


# Install IDE
install_aur_package android-studio
install_aur_package android-sdk
install_aur_package android-sdk-build-tools
install_aur_package android-sdk-platform-tools
install_aur_package android-sdk-cmdline-tools-latest
install_aur_package android-platform

install_aur_package pycharm-community-jre
install_aur_package vscodium-bin
install_aur_package dbeaver-git

# Others
install_aur_package zoom

# Install Flutter
cd ~
mkdir Development
cd ~/Development
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.16.0-stable.tar.xz
tar xf flutter_linux_3.16.0-stable.tar.xz
rm flutter_linux_3.16.0-stable.tar.xz

echo 'export PATH="$PATH:~/Development/flutter/bin"' >> ~/.bashrc
echo 'export CHROME_EXECUTABLE=/opt/google/chrome/google-chrome' >> ~/.bashrc
echo 'export ANDROID_HOME=/opt/android-sdk' >> ~/.bashrc
echo 'export JAVA_HOME=/usr/lib/jvm/java-21-openjdk' >> ~/.bashrc

source ~/.bashrc

flutter precache
flutter --disable-analytics
flutter doctor

# Install Firebase CLI
curl -sL https://firebase.tools | bash

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

echo -e "\n${GREEN}Installing Extensions!${NC}"
vscodium --install-extension Dart-Code.flutter
vscodium --install-extension FelixAngelov.bloc
vscodium --install-extension Nash.awesome-flutter-snippets
vscodium --install-extension jeroen-meijer.pubspec-assist
vscodium --install-extension luanpotter.dart-import

echo -e "\n${GREEN}Dev Packages Instllation Done!${NC}" 
