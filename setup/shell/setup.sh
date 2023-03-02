#! /bin/bash

###########################################
# Nanamiiiii's dotfile shell setup script #
###########################################

VER_MJ=0
VER_MN=1
VER_REV=0

if [ -z "$DOTFILES" ]; then
    DOTFILES="dotfiles"
fi

if [ -z "$PROFILE" ]; then
    PROFILE="ws-linux"
fi

WORK_DIR=$(pwd)
CONFIG_DIR="$HOME/.config"
DIST_ID=$(awk 'match($0, /^ID=(.*)/, a) {print a[1]}' /etc/os-release)

function print_greeting() {
    printf "     __                            _ _ _ _ _ \n"
    printf "  /\ \ \__ _ _ __   __ _ _ __ ___ (_|_|_|_|_)\n"
    printf " /  \/ / _\` | '_ \ / _\` | '_ \` _ \| | | | | |\n"
    printf "/ /\  / (_| | | | | (_| | | | | | | | | | | |\n"
    printf "\_\ \/ \__,_|_| |_|\__,_|_| |_| |_|_|_|_|_|_|\n\n"

    printf "Nanamiiiii's shell setup script v%d.%d.%d\n\n" $VER_MJ $VER_MN $VER_REV
    printf "This script will setup apps/tools/configurations below\n"
    printf "1) zsh\n"
    printf "2) zinit\n"
    printf "3) rustup\n"
    printf "4) starship\n\n"

    printf "Selected shell profile: %s\n\n" "$PROFILE"

    printf "Are you sure proceeding? (y/N): "
    read -r INPUT

    case $INPUT in
        [Yy]* )
            ;;
        * )
            echo >&2 "Aborting."
            exit 1
            ;;
    esac
}

function check_prerequisite() {
    echo -e "\033[1m==> Checking prerequisite...\033[0m"
    # Working directory
    if [[ ! "$WORK_DIR" = */"$DOTFILES" ]]; then
        echo -e "\033[1merror:\033[0m please execute in dotfiles' root directory."
        echo "if you changed repo's name, passing the name via DOTFILES"
        exit 1
    fi

    # Shell profile name
    if [ ! -d "$WORK_DIR/zsh/$PROFILE" ]; then
        echo -e "  -> \033[1merror:\033[0m specified shell profile name's configuration does not exist."
        exit 1
    fi

    # Distribution
    if [ "$DIST_ID" = 'arch' ]; then
        echo "  -> Distribution: ArchLinux detected."
    elif [ "$DIST_ID" = 'ubuntu' ]; then
        echo "  -> Distribution: Ubuntu detected."
    else
        echo -e "\033[1merror:\033[0m Not supported distribution."
        exit 1
    fi

    # user
    if [ $UID -eq 0 ]; then
        echo -e "  -> \033[1mwarning:\033[0m running script as root user is not recommended."
    fi

    # git
    command -v git > /dev/null 2>&1 || { echo -e >&2 "\033[1merror:\033[0m git is not installed. Aborting."; exit 1; } 
    echo "  -> git is installed."

    # curl
    command -v curl > /dev/null 2>&1 || { echo -e >&2 "\033[1merror:\033[0m curl is not installed. Aborting." exit 1; }

    # cmake
    command -v cmake > /dev/null 2>&1 || { echo -e >&2 "\033[1merror:\033[0m cmake is not installed. Aborting." exit 1; }
}

function install_zsh() {
    echo -e "\033[1m[Install]\033[0m zsh"

    echo -e "\033[1m==> Checking shell...\033[0m"
    if ! command -v zsh; then
        echo "  -> zsh is not installed. install from package."
        if [ "$DIST_ID" = 'arch' ]; then
            sudo pacman -Sy --noconfirm --needed zsh
        elif [ "$DIST_ID" = 'ubuntu' ]; then
            sudo apt install -y zsh
        fi
    fi

    if [ "$SHELL" != "/bin/zsh" ]; then
        echo " -> zsh is not set as default shell. run chsh."
        chsh -s /bin/zsh
    fi

    echo -e "\033[1m==> Creating symbolic links of configuration...\033[0m"
    if [ -e "$HOME/.zshrc" ]; then
        echo "  -> .zshrc alredy exists. backing up & replacing..."
        mv "$HOME/.zshrc" "$HOME/zshrc.bak" 
    fi
    ln -sf "$WORK_DIR/zsh/$PROFILE/zshrc" "$HOME/.zshrc"
    echo "  -> created symlink $HOME/.zshrc to $WORK_DIR/zsh/$PROFILE/zshrc"

    if [ -e "$HOME/.zshenv" ]; then
        echo "  -> .zshenv already exists. backing up & replacing..."
        mv "$HOME/.zshenv" "$HOME/zshenv.bak"
    fi
    ln -sf "$WORK_DIR/zsh/$PROFILE/zshenv" "$HOME/.zshenv"
    echo "  -> created symlink $HOME/.zshenv to $WORK_DIR/zsh/$PROFILE/zshenv"

    if [ -e "$HOME/.zprofile" ]; then
        echo "  -> .zprofile already exists. backing up & replacing..."
        mv "$HOME/.zprofile" "$HOME/zprofile.bak"
    fi
    ln -sf "$WORK_DIR/zsh/$PROFILE/zprofile" "$HOME/.zprofile"
    echo "  -> created symlink $HOME/.zprofile to $WORK_DIR/zsh/$PROFILE/zprofile"
}

function install_zinit() {
    echo -e "\033[1m[Install]\033[0m zinit"
    echo -e "\033[1m==> Creating symbolic links of configuration...\033[0m"
    ln -sf "$WORK_DIR/zsh/myzinit" "$HOME/.myzinit"
    echo "  -> you need to reload shell to install plugins."
}

function install_rustup() {
    echo -e "\033[1m[Install]\033[0m rustup"
    if command -v rustup; then
        echo "  -> rustup is already installed. skipping."
        return
    fi
    echo -e "\033[1m==> Run installation script...\033[0m"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    echo -e "\033[1m==> Load configuration...\033[0m"
    source "$HOME/.cargo/env"
}

function install_starship() {
    echo -e "\033[1m[Install]\033[0m starship"
    if ! command -v cargo; then
        echo -e "  -> \033[1merror:\033[0m cargo is not in PATH. aborting."
    fi
    if command -v starship; then
        echo "  -> starship is already installed. skipping."
        ln -sf "$WORK_DIR/starship/starship.toml" "$CONFIG_DIR/"
        echo "  -> created symlink $CONFIG_DIR/starship.toml to $WORK_DIR/starship/starship.toml"
        echo "  -> starship prompt will be activated after reloading shell"
        return
    fi
    echo -e "\033[1m==> Installing with cargo...\033[0m"
    cargo install --locked starship
    echo -e "\033[1m==> Creating symbolic links of configuration...\033[0m"
    if [ -e "$CONFIG_DIR/starship.toml" ]; then
        echo "  -> starship.toml already exists. backing up & replacing..."
        mv "$CONFIG_DIR/starship.toml" "$CONFIG_DIR/starship.toml.bak"
    fi
    ln -sf "$WORK_DIR/starship/starship.toml" "$CONFIG_DIR/"
    echo "  -> created symlink $CONFIG_DIR/starship.toml to $WORK_DIR/starship/starship.toml"
    echo "  -> starship prompt will be activated after reloading shell"
}

print_greeting
check_prerequisite
install_zsh
install_zinit
install_rustup
install_starship

echo "Complete!"
