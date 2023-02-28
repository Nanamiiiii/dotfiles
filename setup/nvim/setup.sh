#! /bin/bash

############################################
# Nanamiiiii's dotfile neovim setup script #
############################################

VER_MJ=0
VER_MN=1
VER_REV=0

if [ -z "$DOTFILES" ]; then
    DOTFILES="dotfiles"
fi
WORK_DIR=$(pwd)
SOURCE_DIR="$HOME/src"
CONFIG_DIR="$HOME/.config"
NEOVIM_REPO="https://github.com/neovim/neovim.git"
DIST_ID=$(awk 'match($0, /^ID=(.*)/, a) {print a[1]}' /etc/os-release)
DEIN_DIR="$HOME/.cache/dein"

function print_greeting() {
    printf "     __                            _ _ _ _ _ \n"
    printf "  /\ \ \__ _ _ __   __ _ _ __ ___ (_|_|_|_|_)\n"
    printf " /  \/ / _\` | '_ \ / _\` | '_ \` _ \| | | | | |\n"
    printf "/ /\  / (_| | | | | (_| | | | | | | | | | | |\n"
    printf "\_\ \/ \__,_|_| |_|\__,_|_| |_| |_|_|_|_|_|_|\n\n"

    printf "Nanamiiiii's neovim setup script v%d.%d.%d\n\n" $VER_MJ $VER_MN $VER_REV
    printf "This script will setup apps/tools/configurations below\n"
    printf "1) neovim-HEAD (install to /usr/bin/nvim)\n"
    printf "2) dein.vim (neovmim plugin manager)\n"
    printf "3) deno (used by some plugins)\n"
    printf "4) node.js, npm (used by some plugins)\n"
    printf "5) pynvim\n"
    printf "6) Neovim configuration (init.vim, ~/.vim/*)\n\n"

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

    # Python3 / pip
    command -v python > /dev/null 2>&1 || command -v python3 > /dev/null 2>&1 || { echo -e >&2 "\033[1merror:\033[0m python is not installed.  Aborting."; exit 1; }
    echo "  -> python is installed."
    command -v pip > /dev/null 2>&1 || python -m pip > /dev/null 2>&1 || python3 -m pip > /dev/null 2>&1 || { echo -e >&2 "\033[1merror:\033[0m pip is not installed. Aborting."; exit 1; }
    echo "  -> python pip is installed."

    # git
    command -v git > /dev/null 2>&1 || { echo -e >&2 "\033[1merror:\033[0m git is not installed. Aborting."; exit 1; } 
    echo "  -> git is installed."

    # curl
    command -v curl > /dev/null 2>&1 || { echo -e >&2 "\033[1merror:\033[0m curl is not installed. Aborting." exit 1; }
}

function install_neovim() {
    echo -e "\033[1m[Install]\033[0m neovim-HEAD"

    # neovim existence
    ! command -v nvim > /dev/null 2>&1 || { echo >&2 "  -> neovim already installed. Skipping."; return; }
    echo "  -> neovim installation target is clean."

    echo -e "\033[1m==> Installing required packages...\033[0m"
    if [ "$DIST_ID" = 'arch' ]; then
        sudo pacman -Sy --noconfirm --needed base-devel cmake unzip ninja curl
    elif [ "$DIST_ID" = 'ubuntu' ]; then
        sudo apt-get install -y ninja-build gettext libtool-bin cmake g++ pkg-config unzip curl
    fi

    echo -e "\033[1m==> Cloning neovim source to $SOURCE_DIR\033[0m..."
    if [ ! -d "$SOURCE_DIR" ]; then
        mkdir "$SOURCE_DIR"
    fi
    if [ -d "$SOURCE_DIR"/neovim ]; then
        echo -n >&2 "Directory $SOURCE_DIR/neovim already exists. Are you sure removing this directory? (y/n): "
        read -r INPUT
        case $INPUT in
            [Yy]* )
                rm -rf "$SOURCE_DIR/neovim"
                ;;
            * )
                echo -e >&2 "\033[1merror:\033[0m Cannot clone source. Aborting."
                exit 1
                ;;
        esac
    fi

    git clone "$NEOVIM_REPO" "$SOURCE_DIR/neovim"

    echo -e "\033[1m==> Entering into source directory...\033[0m"
    cd "$SOURCE_DIR" || { echo "Failed to change directory."; exit 1; }

    echo -e "\033[1m==> Building neovim...\033[0m"
    make CMAKE_BUILD_TYPE=RelWithDebInfo

    echo -e "\033[1m==> Installing neovim...\033[0m"
    sudo make install

    echo -e "\033[1m==> Getting back working directory...\033[0m"
    cd "$WORK_DIR" || { echo "Failed to change directory."; exit 1; }
}

function install_dein() {
    echo -e "\033[1m[Install]\033[0m dein.vim"
    echo -e "\033[1m==> Checking install directory...\033[0m"
    echo "  -> install directory: $DEIN_DIR"
    if [ -d "$DEIN_DIR" ]; then
        echo "  -> $DEIN_DIR already exists."
    else
        echo "  -> Creating directory $DEIN_DIR"
        mkdir -p "$DEIN_DIR"
    fi
    echo -e "\033[1m==> Installing...\033[0m"
    DEIN_REPO="$DEIN_DIR/repos/github.com/Shougo/dein.vim"
    if [ -d "$DEIN_REPO" ]; then
        echo "  -> $DEIN_REPO already exists."
        echo -n "Are you sure overwrite? (y/n): "
        read -r INPUT
        case $INPUT in
            [Yy]* )
                rm -rf "$DEIN_REPO"
                ;;
            * )
                echo -e >&2 "\033[1merror:\033[0m Cannot clone source. Aborting."
                exit 1
                ;;
        esac
    fi
    echo "  -> Cloning to $DEIN_REPO"
    git clone https://github.com/Shougo/dein.vim "$DEIN_REPO"
}

function install_deno() {
    echo -e "\033[1m[Install]\033[0m deno"
    ! command -v deno > /dev/null 2>&1 || { echo "  -> deno already installed. skipping."; return; }
    echo -e "\033[1m==> Execute install script.\033[0m"
    curl -fsSL https://deno.land/x/install/install.sh | sh
}

function install_npm() {
    echo -e "\033[1m[Install]\033[0m node.js/npm"
    ! command -v npm > /dev/null 2>&1 || { echo "  -> npm already installed. skipping."; return; }
    echo -e "\033[1m==> Installing n & node.js with n-install.\033[0m"
    curl -L https://bit.ly/n-install | bash
}

function install_pynvim() {
    echo -e "\033[1m[Install]\033[0m pynvim"
    ! pip list | grep -x -E '^pynvi\s+[0-9]+\.[0-9]+\.[0-9]+$' > /dev/null || { echo "  -> pynvim already installed. skipping."; return; }
    echo -e "\033[1m==> Installing pynvim...\033[0m"
    pip install pynvim 2> /dev/null || python -m pip install pynvim 2> /dev/null || python3 -m pip install pynvim 2> /dev/null
}

function configure_neovim() {
    echo -e "\033[1m[Configure]\033[0m neovim"
    echo -e "\033[1m==> Checking configuration directory...\033[0m"
    if [ ! -d "$CONFIG_DIR" ]; then
        mkdir -p "$CONFIG_DIR"
    fi
    if [ ! -d "$CONFIG_DIR"/nvim ]; then
        mkdir -p "$CONFIG_DIR"/nvim
    fi
    echo -e "\033[1m==> Checking configuration file...\033[0m"
    if [ ! -e "$WORK_DIR"/nvim/init.vim ]; then
        echo -e "  -> \033[1merror:\033[0m missing config file \"init.vim\". Aborting."
        exit 1
    fi
    if [ ! -d "$WORK_DIR"/nvim/.vim ]; then
        echo -e "  -> \033[1merror:\033[0m missing config directory \".vim\". Aborting."
        exit 1
    fi
    echo -e "\033[1m==> Backing up existing configuration...\033[0m"
    if [ -e "$CONFIG_DIR/nvim/init.vim" ]; then
        mv "$CONFIG_DIR"/nvim/init.vim "$CONFIG_DIR"/nvim/init.vim.old
        echo "  -> backed up $CONFIG_DIR/nvim/init.vim"
    fi
    if [ -d "$HOME/.vim" ]; then
        mv "$HOME"/.vim "$HOME"/.vim.old
        echo "  -> backed up $HOME/.vim"
    fi
    echo -e "\033[1m==> Creating symbolic links of configurations...\033[0m"
    ln -sf "$WORK_DIR"/nvim/init.vim "$CONFIG_DIR"/nvim/
    ln -sf "$WORK_DIR"/nvim/.vim "$HOME"
}

# main process
print_greeting
check_prerequisite
install_neovim
install_dein
install_deno
install_npm
install_pynvim
configure_neovim

echo "Complete!"
