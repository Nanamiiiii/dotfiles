#!/bin/bash

if ($(which nvim > /dev/null))
then
    NVIM_VER=`nvim -v | head -1 | awk '{ print $2 }'`
    MIDDLE_VER=`echo $NVIM_VER | awk -F "-" '{ print $1 }' | awk -F "." '{ print $2 }'`
    echo "Neovim $NVIM_VER is installed."
    if [ $MIDDLE_VER -lt 7 ]; then
        echo "Error: Require v0.7.0 or newer."
        exit 1
    fi
else
    echo "Error: Neovim is not installed."
    exit 1
fi

if [ -d ~/.cache/dein ]; then
    echo "dein.vim maybe already configured. skipping."
    echo "if not, delete folder ~/.cache/dein and re-run."
else
    echo "Setup dein.vim"
    curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
    if [ $? -ne 0 ]; then
        echo "Error: downloading failed."
        exit 1
    fi
    sh ./installer.sh ~/.cache/dein
    if [ $? -ne 0 ]; then
        echo "Error: setup failed."
        exit 1
    fi
    
    echo "Create symlink to vim confinguration."
    mkdir -p ~/.config/nvim
    if [ -e ~/.config/nvim/init.vim ]; then
        rm ~/.config/nvim/init.vim
    fi
    ln -s $PWD/vim-conf/init.vim ~/.config/nvim/init.vim
    if [ -d ~/.vim ]; then
        rm -rf ~/.vim
    fi
    ln -s $PWD/vim-conf/.vim ~/
fi

if ($(which pip > /dev/null))
then
    echo "pip is installed."
else
    echo "Error: pip is not installed."
    echo "Make sure that python3 and pip is configured."
    exit 1
fi

if ($(pip list 2>/dev/null | grep pynvim >/dev/null))
then
    echo "pynvim is installed."
else
    echo "Setup pynvim"
    pip install pynvim
fi

if ($(pip list 2>/dev/null | grep compiledb >/dev/null))
then
    echo "compiledb is installed."
else
    echo "Setup compiledb"
    pip install compiledb
fi

if ($(which zsh > /dev/null))
then
    echo "zsh is installed."
else
    echo "Error: zsh is not installed."
    exit 1
fi
echo "Setup prezto"
zsh ./setup_prezto.zsh

rm ~/.zpreztorc
ln -s $PWD/zpreztorc ~/.zpreztorc

echo 'export PATH=$PATH:~/.local/bin' >> ~/.zshrc

echo "Finished."

