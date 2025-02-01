#! /bin/bash

echo "Installing essential tools for papop"
# check if the script is run with sudo or as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root or with sudo."
  exit 1
fi

TMP_FOLDER="~/tmp/arch_install"
mkdir -p "$TMP_FOLDER"
echo "Temporary folder set to: $TMP_FOLDER"
cd "$TMP_FOLDER" || {
  echo "Failed to change directory to $TMP_FOLDER"
  exit 1
}

# AUR package manager
pacman -S --needed base-devel
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si

cd "$TMP_FOLDER" || {
  echo "Failed to change directory to $TMP_FOLDER"
  exit 1
}

# python
pacman -S python python-pip python-numpy

# web browser
pacman -S firefox

# essential tools
pacman -S zip unzip yarn wev

# pdf
pacman -S zathura zathura-pdf-mupdf

# hyprland
pacman -S hyprlock hypridle hyprpaper hyprutils

#media player
pacman -S mpv pulsemixer spotify-launcher

# waybar
pacman -S waybar inotify-tools

# install fonts
pacman -S noto-fonts ttf-hack-nerd

# jupyter notebook
pacman -S jupyter-notebook jupyterlab

# airplay screen sharing
paru uxplay
