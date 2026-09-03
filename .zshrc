# ZSHRC

# -------- SETUP ZINIT --------
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

# -------- PLUGINS --------
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting
zinit light Aloxaf/fzf-tab

# -------- PLUGIN SETUP --------

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'



# -------- SNIPPET --------

zinit snippet OMZP::git
zinit snippet OMZP::github
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::copyfile
zinit snippet OMZP::ssh
zinit snippet OMZP::man
zinit snippet OMZP::zoxide
zinit snippet OMZP::command-not-found

# -------- HISTORY --------
HISTSIZE=1000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# -------- KEYBOARD SETTING --------
bindkey -v
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[1;5C" forward-word   # Ctrl+Right
bindkey "^[[1;5D" backward-word  # Ctrl+Left
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward

#-------- LOAD PROFILE --------
source $HOME/.profile

# -------- LOAD COMPLETIONS --------
autoload -U compinit && compinit
zinit cdreplay -q


# -------- SHELL INTEGRATION --------

#ohmyposh
eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/base.toml)"

#fzf cmd
eval "$(fzf --zsh)"

# zoxide use cd 
eval "$(zoxide init --cmd cd zsh)"

#yazi
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

alias rpi-imager='sudo QT_QPA_PLATFORM=wayland WAYLAND_DISPLAY=wayland-1 XDG_RUNTIME_DIR=/run/user/1000 rpi-imager'

# auto-start tmux, attaching to an existing session if one's alive
if [ -z "$TMUX" ] && [ -n "$PS1" ]; then
	tmux attach -t default 2>/dev/null || tmux new -s default
fi
