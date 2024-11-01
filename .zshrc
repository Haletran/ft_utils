# History saving
HISTFILE=~/.zsh/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY

# Basic Utilities
alias n="norminette -R CheckForbiddenSourceHeader"
alias g="cc -Wall -Werror -Wextra"
alias g++="c++ -Wall -Werror -Wextra -std=c++98"
alias vg="valgrind --leak-check=full --track-fds=yes"
alias neo="~/sgoinfre/Others/Programs/fastfetch"
alias dc="cd ~/sgoinfre"
alias bonus="for file in *; do mv "$file" "${file%.*}_bonus.${file##*.}"; done"
alias code="DRI_PRIME=1 zed ."
alias codekill='kill $(pgrep zed)'
alias codev="/nfs/homes/bapasqui/sgoinfre/Others/VSCode-linux-x64/bin/code --no-sandbox"
alias gl="git log --oneline --abbrev-commit --all"
alias blue="~/sgoinfre/Others/Programs/clearb"
alias bro="nohup /nfs/homes/bapasqui/sgoinfre/Others/zen.linux-specific/zen/zen-bin > /dev/null 2>&1 &"
alias hist="cat ~/.zsh/.zsh_history"
alias cat_config="cat ~/.zshrc"

#Cleaning
alias clean="~/sgoinfre/Others/Programs/cleaning_pc"
alias clean1="du -d 1 -h | sort -h"
alias clean2="du -h - d 2 . | sort -hf"

#Makefile Commands
alias mf="make fclean"
alias mc="make clean"
alias mr="make re"
alias m="make"

function mfa() {
	echo "Cleaning all the exercices..."
	find . -type d -exec make fclean -C {} \; > /dev/null 2>&1
}

function cdc()
{
	cd $1
	code .
}
function gtn() {
    make fclean
    git add .
    cz commit
	git push
}

function gt() {
	make fclean
	git add .
	git commit -m $1
	git push
}

function gcl() {
	git clone $1 $2
	cd "$2"
}

function rendu()
{
    name=$(mktemp -u XXXXXXXXXX)
    cd /tmp
    git clone "$1" "$name"
    cd "$name"
}

function ignore()
{
	$1 2> /dev/null
}

#ZSHRC conf utilities
alias edit="vim ~/.zshrc"
alias reload="source ~/.zshrc"
export PATH=$HOME/.local/bin:$PATH
alias cd="z"
eval "$(zoxide init zsh)"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk
source /nfs/homes/bapasqui/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
