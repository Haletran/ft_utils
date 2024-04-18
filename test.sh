#!/bin/bash

if [ -n "$BASH_VERSION" ]; then
    echo "Running under bash version $BASH_VERSION"
elif [ -n "$ZSH_VERSION" ]; then
    echo "Running under zsh version $ZSH_VERSION"
else
    echo "Running under another shell"
fi
