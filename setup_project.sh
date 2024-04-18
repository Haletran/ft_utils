# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    setup_project.sh                                   :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: bapasqui <bapasqui@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/04/18 16:58:54 by bapasqui          #+#    #+#              #
#    Updated: 2024/04/18 17:02:34 by bapasqui         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!bin/sh

create_folder()
{
    if [ ! -d $PROJECT_NAME ]; then
        mkdir $PROJECT_NAME
    fi
    if [ ! -d $PROJECT_NAME/src ]; then
        mkdir $PROJECT_NAME/src
    fi
    if [ ! -d $PROJECT_NAME/include ]; then
        mkdir $PROJECT_NAME/include
        if [ $IS_C_PROJECT = "y" ]; then
            touch $PROJECT_NAME/include/$PROJECT_NAME.h
            touch $PROJECT_NAME/src/main.c
        fi
        if [ $IS_CPP_PROJECT = "y" ]; then
            touch $PROJECT_NAME/include/$PROJECT_NAME.hpp
            touch $PROJECT_NAME/src/main.cpp
        fi
    fi
    touch $PROJECT_NAME/Makefile
}

main()
{
    read -p "Enter project name: " PROJECT_NAME
    if [ $? -eq 1 ] ; then echo -e "\nexit" && exit 1; fi
    read -p "Is this a C project? (y/n): " IS_C_PROJECT
    if [ $? -eq 1 ] ; then echo -e "\nexit" && exit 1; fi
    if [ $IS_C_PROJECT = "n" ]; then 
        read -p "Is this a C++ project? (y/n): " IS_CPP_PROJECT
        if [ $? -eq 1 ] ; then echo -e "\nexit" && exit 1; fi
        if [ $IS_CPP_PROJECT = "n" ]; then
            echo "Invalid project type"
            exit 1
        fi
    fi
    read -p "Do you have a git repository? (y/n): " IS_GIT_REPO
    if [ $? -eq 1 ] ; then echo -e "\nexit" && exit 1; fi
    if [ $IS_GIT_REPO = "y" ]; then
        read -p "Enter git repository URL: " GIT_REPO_URL
        if [ $? -eq 1 ] ; then echo -e "\nexit" && exit 1; fi
        git clone $GIT_REPO_URL $PROJECT_NAME
    fi
    read -p "Do you want to create a folder structure? (y/n): " CREATE_FOLDER
    if [ $? -eq 1 ] ; then echo -e "\nexit" && exit 1; fi
    if [ $CREATE_FOLDER = "y" ]; then
        create_folder
    fi
    read -p "Do you want to open the project after his creation? (y/n): " OPEN_PROJECT
    if [ $? -eq 1 ] ; then echo -e "\nexit" && exit 1; fi
    if [ $OPEN_PROJECT = "y" ]; then
        cd $PROJECT_NAME
        read -p "Do you want to open the project with VSCODE? (y/n): " OPEN_VSCODE
        if [ $? -eq 1 ] ; then echo -e "\nexit" && exit 1; fi
        if [ $OPEN_VSCODE = "y" ]; then
            code .
        fi
        if [ $OPEN_VSCODE = "n" ]; then
            read -p "Do you want to open the project with VIM? (y/n): " OPEN_VIM
            if [ $? -eq 1 ] ; then echo -e "\nexit" && exit 1; fi
            if [ $OPEN_VIM = "y" ]; then
                vim .
            fi
        fi
    fi

}
main
