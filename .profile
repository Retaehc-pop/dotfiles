
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export EDITOR=nvim
export VISUAL=nvim
export PAGER=less
export LESS=-R
export BROWSER=chromium
export FONT=ttf-hack-nerd
export PATH="/usr/local/bin:/usr/bin:$PATH"
export LD_LIBRARY_PATH=/usr/local/lib
export QT_QPA_PLATFORMTHEME=qt6ct # Noctalia app icon

export PATH="$HOME/opt/cross/bin:$PATH"



export PREFIX="$HOME/opt/cross"
export TARGET=i686-elf
export PATH="$PREFIX/bin:$PATH"



# -------- SET ALIAS --------
alias cd="z" # or eval "${zoxide init --cmd cd zsh}"
alias ls="ls --color"
alias ll="ls -alF"
alias vim="nvim"
alias c="clear"
alias ff="fastfetch"
alias open="xdg-open"
[ "$TERM" = "xterm-kitty" ] && alias ssh="kitty +kitten ssh"

