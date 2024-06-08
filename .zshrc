# Set the GPG_TTY to be the same as the TTY, either via the env var
# or via the tty command.
if [ -n "$TTY" ]; then
  export GPG_TTY=$(tty)
else
  export GPG_TTY="$TTY"
fi

# SSH_AUTH_SOCK set to GPG to enable using gpgagent as the ssh agent.
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent

export PATH="/usr/local/bin:/usr/bin"

autoload -Uz compinit && compinit

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

zinit light ohmyzsh/ohmyzsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::rust
zinit snippet OMZP::command-not-found

zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

source $HOME/.profile
source $HOME/.config/tmuxinator/tmuxinator.zsh

if [ Darwin = `uname` ]; then
  source $HOME/.profile-macOS
elif [ Linux = `uname` ]; then
  source $HOME/.profile-linux
fi

setopt auto_cd

#export PATH="/usr/local/opt/curl/bin:$PATH"
#
alias sudo='sudo '
export LD_LIBRARY_PATH=/usr/local/lib

export PATH="/opt/cuda/bin${PATH:+:${PATH}}"
export LD_LIBRARY_PATH=/opt/cuda/lib64

# Completions


# Fix for password store
export PASSWORD_STORE_GPG_OPTS='--no-throw-keyids'
export NVM_DIR="$HOME/.nvm"                            # You can change this if you want.
export NVM_SOURCE="/usr/share/nvm"                     # The AUR package installs it to here.
[ -s "$NVM_SOURCE/nvm.sh" ] && . "$NVM_SOURCE/nvm.sh"  # Load N

bindkey "^P" up-line-or-beginning-search
bindkey "^N" down-line-or-beginning-search


# Capslock command
alias capslock="sudo killall -USR1 caps2esc"

if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    export MOZ_ENABLE_WAYLAND=1
fi

eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/base.toml)"

eval "$(zoxide init zsh)"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/papop/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/papop/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/papop/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/papop/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# precmd() {
#   if [[ -n $TMUX && -n $CONDA_DEFAULT_ENV ]]; then
#     tmux setenv -g TMUX_CONDA_ENV "$CONDA_DEFAULT_ENV"
#   else
#     tmux setenv -gu TMUX_CONDA_ENV
#   fi
# }
