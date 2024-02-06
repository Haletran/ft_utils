#MY ZSHRC CONFIG

#VARIABLES
PS1="${PS1:0:-3}\$(__git_ps1 \"\[\033[0;33m\]:%s\[\033[00m\]\")\$ "
export HISTCONTROL=ignoredups
export EDITOR=vim
YOUR_PROJECT_REPO=""

#ALIAS

##Basic Utilities
alias repo="git clone $YOUR_PROJECT_REPO"
alias n="norminette -R CheckForbiddenSourceHeader"
alias ccw="cc -Wall -Werror -Wextra"
alias c="code ."
alias clean="du -h | sort -hf"
alias intra="xdg-open https://intra.42.fr"
alias ls="ls --color=auto"
alias cl="git clone"
alias rmf="rm -rf"
#alias trash="mv -t ~/.local/share/Trash/files --backup=t"

##ZSHRC config utilities
alias edit="vim ~/.zshrc"
alias reload="source ~/.zshrc"

#Functions
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
