#!bin/sh

install_vscode()
{
    current_dir=$(pwd)
    wget --user-agent=Mozilla --content-disposition -E -c "https://code.visualstudio.com/sha/download?build=stable&os=linux-x64"
    chmod 777 code-stable-x64-*.tar.gz
    tar -xzf code-stable-x64-*.tar.gz
    rm code-stable-x64-*.tar.gz
    echo "alias code=\"${current_dir}/VSCode-linux-x64/bin/code --no-sandbox\"" >> ~/.zshrc
    source ~/.zshrc
}

main()
{
    read -p "Do you want to update vscode? (y/n): " INSTALL_VSCODE
    if [ $? -eq 1 ] ; then echo -e "\nexit" && exit 1; fi
    if [ $INSTALL_VSCODE = "y" ]; then
        echo "Updating vscode..."
        install_vscode
    fi
}

main
