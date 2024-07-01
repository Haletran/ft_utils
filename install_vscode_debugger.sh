#!bin/sh

install_vscode_debugger()
{
    current_dir=$(pwd)
    if [ ! -d ".vscode" ]; then
        "Creating .vscode directory..." 
        mkdir .vscode
    fi
    if [ ! -f ".vscode/launch.json" ]; then
        echo "Creating launch.json file..."
        wget -O vscode-debugger-utils/launch.json https://raw.githubusercontent.com/rafael-pieri/vscode-debugger-utils/main/launch.json
    else
        echo "launch.json file already exists."
        echo "Backing up launch.json file..."
        mv .vscode/launch.json .vscode/launch.json.bkp
        wget -O vscode-debugger-utils/launch.json https://raw.githubusercontent.com/rafael-pieri/vscode-debugger-utils/main/launch.json
    fi

    if [ ! -f ".vscode/tasks.json" ]; then
        echo "Creating tasks.json file..."
        wget -O vscode-debugger-utils/tasks.json https://raw.githubusercontent.com/rafael-pieri/vscode-debugger-utils/main/tasks.json
    else
        echo "tasks.json file already exists."
        echo "Backing up tasks.json file..."
        mv .vscode/tasks.json .vscode/tasks.json.bkp
        wget -O vscode-debugger-utils/tasks.json https://raw.githubusercontent.com/rafael-pieri/vscode-debugger-utils/main/tasks.json
    fi
    echo "Debugger files updated."
}

install_vscode_debugger