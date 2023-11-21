# paru_install.sh

# Function to install paru
install_paru() {
    if ! command -v paru &> /dev/null; then
        echo -e "\n${GREEN}paru is not installed. Installing paru...${NC}"

        # Install paru
        git clone https://aur.archlinux.org/paru-bin.git
        cd paru-bin || exit 1
        makepkg -si --noconfirm
        cd ..
        rm -rf paru-bin
    else
        echo -e "\n${GREEN}paru is already installed.${NC}\n"
    fi
}
