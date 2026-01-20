#!/usr/bin/env bash

install_vscode()
{
    local install_dir="$1"

    mkdir -p "$install_dir"
    cd "$install_dir" || exit 1

    rm -rf "$install_dir/VSCode-linux-x64"

    wget --user-agent=Mozilla --content-disposition -E -c "https://code.visualstudio.com/sha/download?build=stable&os=linux-x64"
    chmod 777 code-stable-x64-*.tar.gz
    tar -xzf code-stable-x64-*.tar.gz
    rm code-stable-x64-*.tar.gz

    sed -i '/alias code=/d' ~/.zshrc 2>/dev/null
    echo "alias code=\"${install_dir}/VSCode-linux-x64/bin/code --no-sandbox\"" >> ~/.zshrc

    mkdir -p ~/.local/share/applications
    cat > ~/.local/share/applications/code.desktop << EOF
[Desktop Entry]
Name=Visual Studio Code
Comment=Code Editing. Redefined.
GenericName=Text Editor
Exec=${install_dir}/VSCode-linux-x64/bin/code --no-sandbox %F
Icon=${install_dir}/VSCode-linux-x64/resources/app/resources/linux/code.png
Type=Application
StartupNotify=false
StartupWMClass=Code
Categories=TextEditor;Development;IDE;
MimeType=text/plain;inode/directory;
Actions=new-empty-window;
Keywords=vscode;

[Desktop Action new-empty-window]
Name=New Empty Window
Exec=${install_dir}/VSCode-linux-x64/bin/code --no-sandbox --new-window %F
Icon=${install_dir}/VSCode-linux-x64/resources/app/resources/linux/code.png
EOF

    echo "VSCode installed to: $install_dir/VSCode-linux-x64"
    echo "Desktop shortcut created in GNOME"
}

main()
{
    read -p "Do you want to install the latest vscode version? (y/n): " INSTALL_VSCODE
    if [ $? -eq 1 ] ; then echo -e "\nexit" && exit 1; fi
    if [ "$INSTALL_VSCODE" = "y" ]; then
        read -e -p "Installation directory (default: $HOME/Apps): " INSTALL_DIR
        INSTALL_DIR="${INSTALL_DIR:-$HOME/Apps}"
        INSTALL_DIR="${INSTALL_DIR/#\~/$HOME}"
        echo "Installing vscode to $INSTALL_DIR..."
        install_vscode "$INSTALL_DIR"
    fi
}

main
