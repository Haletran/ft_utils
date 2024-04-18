# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    setup_linux_pc.sh                                  :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: bapasqui <bapasqui@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/04/18 17:02:08 by bapasqui          #+#    #+#              #
#    Updated: 2024/04/18 18:25:14 by bapasqui         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!bin/sh
#read -p "Do you want to setup your zshrc? (y/n): " SETUP_ZSHRC
#if [ $? -eq 1 ] ; then echo -e "\nexit" && exit 1; fi
#if [ $SETUP_ZSHRC = "y" ]; then
#   if [ -f "~/.zshrc" ]
#    curl -LO https://raw.githubusercontent.com/Haletran/ft_utils/main/.zshrc
#    cat .zshrc >> ~/.zshrc
#fi

current_dir=$(pwd)

if [[ "$current_dir" != */sgoinfre ]]; then
  echo "You are not in the sgoinfre directory."
  exit 1
fi

install_nvim()
{
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
    chmod 777 nvim-linux64.tar.gz
    tar -xzf nvim-linux64.tar.gz
    rm nvim-linux64.tar.gz
    echo 'alias nvim="~/sgoinfre/nvim-linux64/bin/nvim"' >> ~/.zshrc
}

install_vscode()
{
    wget --user-agent=Mozilla --content-disposition -E -c "https://code.visualstudio.com/sha/download?build=stable&os=linux-x64"
    chmod 777 code-stable-x64-*.tar.gz
    tar -xzf code-stable-x64-*.tar.gz
    rm code-stable-x64-*.tar.gz
    echo 'alias code="~/sgoinfre/code-stable-x64/bin/code"' >> ~/.zshrc
}

main()
{
    read -p "Do you want to setup your ssh key? (y/n): " SETUP_SSH_KEY
    if [ $? -eq 1 ] ; then echo -e "\nexit" && exit 1; fi
    if [ $SETUP_SSH_KEY = "y" ]; then
        ssh-keygen
        cat ~/.ssh/id_rsa.pub
        read -p "Copy the key and put it in your intra profile"
    fi
    
    read -p "Do you want to install nvim? (y/n): " INSTALL_NVIM
    if [ $? -eq 1 ] ; then echo -e "\nexit" && exit 1; fi
    if [ $INSTALL_NVIM = "y" ]; then
        install_nvim
    fi
    read -p "Do you want to install vscode? (y/n): " INSTALL_VSCODE
    if [ $? -eq 1 ] ; then echo -e "\nexit" && exit 1; fi
    if [ $INSTALL_VSCODE = "y" ]; then
        install_vscode
    fi
    read -p "Do you want to install 42 c-formatter? (y/n): " INSTALL_42_C_FORMATTER
    if [ $? -eq 1 ] ; then echo -e "\nexit" && exit 1; fi
    if [ $INSTALL_42_C_FORMATTER = "y" ]; then
        pip3 install c-formatter-42
    fi

    read -p "Do you want to install vlc? (y/n): " INSTALL_VLC
    if [ $? -eq 1 ] ; then echo -e "\nexit" && exit 1; fi
    if [ $INSTALL_VLC = "y" ]; then
        flatpak install flathub org.videolan.VLC
    fi
    
    read -p "Do you want to install spotify? (y/n): " INSTALL_SPOTIFY
    if [ $? -eq 1 ] ; then echo -e "\nexit" && exit 1; fi
    if [ $INSTALL_SPOTIFY = "y" ]; then
        flatpak install flathub com.spotify.Client  
    fi
}
main

