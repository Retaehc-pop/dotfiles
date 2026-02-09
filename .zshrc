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

bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward

# -------- KEYBOARD SETTING --------
bindkey -v
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

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
