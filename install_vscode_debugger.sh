#!bin/sh

user_input()
{
    read -p "For which project do you want to install the debugger? " project_name
    read -p "What args do you want to pass to the program? " args
    echo "Project name: $project_name"
    echo "Args: $args"
}

install_vscode_debugger()
{
    current_dir=$(pwd)
    user_input
    if [ ! -d ".vscode" ]; then
        echo "Creating .vscode directory..." 
        mkdir .vscode
    fi
    if [ ! -f ".vscode/launch.json" ]; then
        echo "Creating launch.json file..."
        wget -O .vscode/launch.json https://raw.githubusercontent.com/Haletran/ft_utils/main/vscode-debugger-utils/launch.json
        sed -i "s/\"name\": \"Launch\",/\"name\": \"Launch $project_name\",/g" .vscode/launch.json
        sed -i "s/\"program\": \"\${workspaceFolder}\/a.out\"/\"program\": \"\${workspaceFolder}\/$project_name\"/g" .vscode/launch.json
        sed -i "s/\"args\": \[\]/\"args\": \[\"$args\"\]/g" .vscode/launch.json
    else
        echo "launch.json file already exists."
        echo "Backing up launch.json file..."
        mv .vscode/launch.json .vscode/launch.json.bkp
        wget -O .vscode/launch.json https://raw.githubusercontent.com/Haletran/ft_utils/main/vscode-debugger-utils/launch.json
        sed -i "s/\"name\": \"Launch\",/\"name\": \"Launch $project_name\",/g" .vscode/launch.json
        sed -i "s/\"program\": \"\${workspaceFolder}\/a.out\"/\"program\": \"\${workspaceFolder}\/$project_name\"/g" .vscode/launch.json
        sed -i "s/\"args\": \[\]/\"args\": \[\"$args\"\]/g" .vscode/launch.json
    fi

    if [ ! -f ".vscode/tasks.json" ]; then
        echo "Creating tasks.json file..."
        wget -O .vscode/tasks.json https://raw.githubusercontent.com/Haletran/ft_utils/main/vscode-debugger-utils/tasks.json
    else
        echo "tasks.json file already exists."
        echo "Backing up tasks.json file..."
        mv .vscode/tasks.json .vscode/tasks.json.bkp
        wget -O .vscode/tasks.json https://raw.githubusercontent.com/Haletran/ft_utils/main/vscode-debugger-utils/tasks.json
    fi
    echo "Debugger files updated."
}

install_vscode_debugger