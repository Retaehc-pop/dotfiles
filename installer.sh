#!/bin/bash

# -------- SUDO ENFORCE --------
if [[ $EUID -ne 0 ]]; then
    exec sudo "$0" "$@"
fi

REAL_USER=${SUDO_USER:-$USER}
USER_HOME=$(getent passwd "$REAL_USER" | cut -d: -f6)

# -------- FAILSAFE --------
set -Eeuo pipefail

# ------- DEPENDENCIES ------------
echo "[LOG] Installing package"
pacman -S --needed --noconfirm neovim bluez bluez-utils networkmanager stow git base-devel nano zsh chromium sddm python cmake yazi zathura cava btop quickshell go python zoxide man less fzf fastfetch btop htop wl-clipboard cliphist clang unzip zip luarocks qt6-wayland tree-sitter-cli pyright yarn npm imagemagick brightnessctl ripgrep fd udiskie wlsunset resvg 7zip github-cli spotify-launcher evolution mpv


# -------- AUR --------
if ! command -v paru &> /dev/null; then
    PARU_BUILD_DIR="/tmp/paru"
    mkdir -p "$PARU_BUILD_DIR"
    chown "$REAL_USER:$REAL_USER" "$PARU_BUILD_DIR"

    sudo -u "$REAL_USER" git clone https://aur.archlinux.org/paru.git "$PARU_BUILD_DIR"

    cd "$PARU_BUILD_DIR"
    sudo -u "$REAL_USER" makepkg -si --noconfirm
    cd -> /dev/null
    rm -rf "$PARU_BUILD_DIR"
fi

# -------- AUR PKG --------
sudo -u "$REAL_USER" paru -S --noconfirm --needed --skipreview oh-my-posh spicetify


# ------- SERVICE ENABLE ----------
systemctl enable --now bluetooth.service
systemctl enable --now NetworkManager.service


# -------- SDDM AUTOLOGIN --------
if [ ! -f "/etc/sddm.conf.d/autologin.conf" ]; then
    mkdir -p /etc/sddm.conf.d
    cat << EOF > /etc/sddm.conf.d/autologin.conf
[Autologin]
User=$REAL_USER
Session=hyprland
EOF
fi
# -------- FONT --------
pacman -S --needed --noconfirm noto-fonts noto-fonts-emoji noto-fonts-cjk ttf-dejavu ttf-hack-nerd

gsettings set org.gnome.desktop.interface font-name 'Noto Sans Thai 11'

mkdir -p ~/.local/share/fonts
fc-cache -fv

# -------- ZSH SHELL --------
CURRENT_SHELL=$(getent passwd papop | cut -d: -f7)
if [[ "$CURRENT_SHELL" != "/bin/zsh" ]]; then
    chsh  -s /bin/zsh "$REAL_USER"
fi

# -------- GNU STOW --------
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
cd "$SCRIPT_DIR"
sudo -u "$REAL_USER" stow . --adopt



# -------- POST STOW SETUP --------
cp ~/.themes/fonts/* ~/.local/share/fonts



echo "--------------------------------------------------"
echo " ✅ Setup Complete! All tasks finished."
echo "--------------------------------------------------"

cd "$USER_HOME"
sudo -u "$REAL_USER" zsh
