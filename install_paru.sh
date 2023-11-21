# install_paru.sh

# Function to install paru
install_paru() {
    if ! command -v paru &> /dev/null; then
        echo -e "\n${GREEN}paru is not installed. Installing paru...${NC}"

        # Install paru
        git clone https://aur.archlinux.org/paru-bin.git
        cd paru || exit 1
        makepkg -si --noconfirm --quiet
        cd ..
        rm -rf paru
    else
        echo -e "\n${GREEN}paru is already installed.${NC}\n"
    fi
}
