#Variables

setopt autocd

# Basic Utilities
alias n="norminette -R CheckForbiddenSourceHeader"
alias g="cc -Wall -Werror -Wextra"
alias cl="git clone git@github.com:Haletran/42-Cursus.git"
alias as="code ."
alias vg="valgrind --leak-check=full --trace-children=yes --track-fds=yes --show-below-main=no"
alias gd="~/Downloads/gf/./gf2"
alias ph="./philosopher 5 800 200 200"
alias neo="~/sgoinfre/Programs/fastfetch"
alias choose="~/sgoinfre/Programs/list_website/choose"
alias ls="ls --color=auto"

#Cleaning
alias clean="du -h  | sort -hf"
alias clean1="du -d 1 -h | sort -h"
alias clean2="du -h - d 2 . | sort -hf"

#Makefile Commands
alias mf="make fclean"
alias mc="make clean"
alias mr="make re"
alias m="make"

function gp() {
	if [ -f "Makefile" ]; then make fclean; fi
	git add .
	git commit -a -m "$1"
	git push
}

function mkcd() {
   mkdir -p $1
   cd $1
}

#ZSHRC conf utilities
alias edit="vim ~/.zshrc"
alias reload="source ~/.zshrc"
alias gs="gnome-session"

stty stop undef
stty start undef
export PATH=$HOME/.local/bin:$PATH
