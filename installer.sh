#!/bin/bash
set -Eeuo pipefail

# -------- SUDO CACHE --------
# Ask for password once, then keep the ticket alive for the full script
sudo -v
while true; do sudo -n true; sleep 50; kill -0 "$$" 2>/dev/null || exit; done &
SUDO_KEEPALIVE_PID=$!
trap 'kill "$SUDO_KEEPALIVE_PID" 2>/dev/null' EXIT

REAL_USER=$USER
USER_HOME=$HOME
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

BROWSER=chromium   # change this to switch the default browser everywhere

# -------- OUTPUT HELPERS --------
stage() {
    echo ""
    echo "============================================================"
    printf "  [%d/%d] %s\n" "$1" "$TOTAL_STAGES" "$2"
    echo "============================================================"
}
ok()   { echo "    OK  $1"; }
info() { echo "    ..  $1"; }

TOTAL_STAGES=10

# -------- [1] PREREQUISITES --------
stage 1 "Prerequisites: multilib + GRUB"
if ! grep -q "^\[multilib\]" /etc/pacman.conf; then
    info "Uncommenting multilib in /etc/pacman.conf"
    sudo sed -i 's/^#\[multilib\]/[multilib]/' /etc/pacman.conf
    sudo sed -i '/^\[multilib\]/{n;s/^#Include/Include/}' /etc/pacman.conf
    sudo pacman -Sy --noconfirm
    ok "multilib enabled and repos synced"
else
    ok "multilib already enabled"
fi

if grep -q "^GRUB_TIMEOUT=0" /etc/default/grub && grep -q "^GRUB_TIMEOUT_STYLE=hidden" /etc/default/grub; then
    ok "GRUB already set to boot immediately"
else
    sudo sed -i 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=0/' /etc/default/grub
    sudo sed -i 's/^GRUB_TIMEOUT_STYLE=.*/GRUB_TIMEOUT_STYLE=hidden/' /etc/default/grub
    sudo grub-mkconfig -o /boot/grub/grub.cfg
    ok "GRUB configured to skip boot menu"
fi

# -------- [2] PACKAGES --------
stage 2 "Installing packages"
sudo pacman -S --needed --noconfirm \
    neovim bluez bluez-utils networkmanager stow git base-devel nano zsh chromium sddm \
    python cmake yazi zathura btop go zoxide man less fzf fastfetch jq \
    htop wl-clipboard cliphist clang unzip zip luarocks qt6-wayland tree-sitter-cli \
    pyright yarn npm brightnessctl ripgrep fd udiskie wlsunset resvg \
    7zip github-cli spotify-launcher mpv steam
ok "all packages installed"

# -------- [3] AUR HELPER --------
stage 3 "Setting up paru (AUR helper)"
if ! command -v paru &>/dev/null; then
    info "Cloning and building paru..."
    PARU_BUILD_DIR="/tmp/paru-install"
    rm -rf "$PARU_BUILD_DIR"
    git clone https://aur.archlinux.org/paru.git "$PARU_BUILD_DIR"
    cd "$PARU_BUILD_DIR"
    makepkg -si --noconfirm
    cd - >/dev/null
    rm -rf "$PARU_BUILD_DIR"
    ok "paru installed"
else
    ok "paru already installed"
fi

# -------- [4] AUR PACKAGES --------
stage 4 "Installing AUR packages"
paru -S --noconfirm --needed --skipreview oh-my-posh spicetify claude-code
ok "AUR packages installed"

# -------- [5] SERVICES --------
stage 5 "Enabling system services"
sudo systemctl enable --now bluetooth.service
ok "bluetooth.service enabled"

sudo systemctl disable systemd-networkd
sudo systemctl stop systemd-networkd
sudo systemctl enable --now NetworkManager.service
ok "NetworkManager.service enabled"

# -------- [6] SDDM AUTOLOGIN --------
stage 6 "Configuring SDDM autologin"
if [ ! -f "/etc/sddm.conf.d/autologin.conf" ]; then
    sudo mkdir -p /etc/sddm.conf.d
    sudo tee /etc/sddm.conf.d/autologin.conf >/dev/null <<EOF
[Autologin]
User=$REAL_USER
Session=hyprland
EOF
    ok "autologin configured for $REAL_USER"
else
    ok "autologin already configured"
fi

# -------- [7] FONTS --------
stage 7 "Installing fonts"
sudo pacman -S --needed --noconfirm \
    noto-fonts noto-fonts-emoji noto-fonts-cjk ttf-dejavu ttf-hack-nerd
ok "font packages installed"

gsettings set org.gnome.desktop.interface font-name 'Noto Sans Thai 11'
gsettings set org.gnome.desktop.interface document-font-name 'Noto Sans Thai 11'
gsettings set org.gnome.desktop.interface monospace-font-name 'Hack Nerd Font Mono 11'
ok "GTK fonts set (interface + document → Noto Sans Thai, monospace → Hack Nerd Font Mono)"

mkdir -p "$USER_HOME/.local/share/fonts"
fc-cache -fv >/dev/null 2>&1
ok "font cache updated"

# -------- [8] SHELL --------
stage 8 "Setting default shell"
CURRENT_SHELL=$(getent passwd "$REAL_USER" | cut -d: -f7)
if [[ "$CURRENT_SHELL" != "/bin/zsh" ]]; then
    sudo chsh -s /bin/zsh "$REAL_USER"
    ok "default shell changed to zsh"
else
    ok "zsh already set as default shell"
fi

# -------- [9] DOTFILES --------
stage 9 "Symlinking dotfiles with stow"
cd "$SCRIPT_DIR"
git submodule update --init --recursive
ok "submodules initialised"
stow . --adopt
ok "dotfiles linked"
bash "$SCRIPT_DIR/pop-skills/install_skill.sh"
ok "pop-skills plugin installed"

if [ -d "$USER_HOME/.themes/fonts" ]; then
    cp "$USER_HOME/.themes/fonts/"* "$USER_HOME/.local/share/fonts/"
    fc-cache -fv >/dev/null 2>&1
    ok "custom fonts copied from ~/.themes/fonts"
fi

# -------- [10] XDG DEFAULTS --------
stage 10 "Setting XDG default applications"

for mime in image/jpeg image/png image/gif image/webp image/tiff image/bmp image/svg+xml; do
    xdg-mime default mpv.desktop "$mime"
done
ok "images → mpv"

for mime in video/mp4 video/x-matroska video/webm video/avi video/quicktime video/x-msvideo video/mpeg; do
    xdg-mime default mpv.desktop "$mime"
done
ok "video → mpv"

xdg-mime default org.pwmt.zathura.desktop application/pdf
ok "pdf → zathura"

for mime in text/plain text/x-shellscript text/x-python; do
    xdg-mime default nvim.desktop "$mime"
done
ok "text/editor → nvim"

for mime in text/html x-scheme-handler/http x-scheme-handler/https x-scheme-handler/ftp; do
    xdg-mime default "${BROWSER}.desktop" "$mime"
done
ok "browser → $BROWSER"

# -------- DONE --------
echo ""
echo "============================================================"
echo "  DONE  Setup complete! All $TOTAL_STAGES stages finished."
echo "============================================================"
echo ""
