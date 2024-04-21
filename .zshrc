#Variables
setopt autocd

# Basic Utilities
alias n="norminette -R CheckForbiddenSourceHeader"
alias g="cc -Wall -Werror -Wextra"
alias vg="valgrind --leak-check=full --trace-children=yes --track-fds=yes --show-below-main=no"
alias ls="ls --color=auto"

#Cleaning
alias check="du -h  | sort -hf"
alias clean="rm -rf /nfs/homes/bapasqui/.Trash/* && rm -rf /nfs/homes/bapasqui/./.cache/"

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
