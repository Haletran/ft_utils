fpath+=($HOME/.local/share/zsh/site-functions)
function parse_git_branch() {
    git branch 2> /dev/null | sed -n -e 's/^\* \(.*\)/[\1]/p'
}
setopt PROMPT_SUBST
export PROMPT='~%F{green}$(parse_git_branch)%f %F{normal}$%f '
export NIXPKGS_ALLOW_UNFREE=1
export NIX_CONFIG="extra-experimental-features = nix-command flakes"
export LD_LIBRARY_PATH=\$HOME/lib

#History saving
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
alias code="~/Programs/vscode/bin/code --no-sandbox"
alias bonus="for file in *; do mv "$file" "${file%.*}_bonus.${file##*.}"; done"
alias gl="git log --oneline --abbrev-commit --all"
alias hist="cat ~/.zsh/.zsh_history"
alias cat_config="cat ~/.zshrc"
alias tmp="cd /tmp"
alias v="nvim"
alias vim="nvim"
alias cl="clear"

#Cleaning
alias clean1="du -d 1 -h | sort -h"
alias clean2="du -h - d 2 . | sort -hf"
alias boot="lightdm-session"
alias trash="rm -rf ~/.local/share/Trash/"

#Makefile Commands
alias mf="make fclean"
alias mc="make clean"
alias mr="make re"
alias m="make"

function mfa() {
	echo "Cleaning all the exercices..."
	find . -type d -exec make fclean -C {} \; > /dev/null 2>&1
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

#USELESS
autoload -Uz tetriscurses
alias tetris=tetriscurses

#LINKS
alias edit="vim ~/.zshrc"
alias reload="source ~/.zshrc"
export PATH=$HOME/.local/bin:$PATH
alias cd="z"
eval "$(zoxide init zsh)"

# ANTIGEN
source ~/antigen.zsh
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting
antigen apply

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export LD_LIBRARY_PATH=/home/bapasqui/.capt/root/lib/x86_64-linux-gnu:/home/bapasqui/.capt/root/usr/lib/x86_64-linux-gnu:$HOME/lib
export PATH=/home/bapasqui/.capt:/home/bapasqui/.capt/root/usr/local/sbin:/home/bapasqui/.capt/root/usr/local/bin:/home/bapasqui/.capt/root/usr/sbin:/home/bapasqui/.capt/root/usr/bin:/home/bapasqui/.capt/root/sbin:/home/bapasqui/.capt/root/bin:/home/bapasqui/.capt/root/usr/games:/home/bapasqui/.capt/root/usr/local/games:/home/bapasqui/.capt/snap/bin:/home/bapasqui/.nvm/versions/node/v23.10.0/bin:/home/bapasqui/.local/bin:/home/bapasqui/.nix-profile/bin:/nix/var/nix/profiles/default/bin:/home/bapasqui/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/home/bapasqui/.antigen/bundles/zsh-users/zsh-autosuggestions:/home/bapasqui/.antigen/bundles/zsh-users/zsh-syntax-highlighting


