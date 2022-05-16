#!/bin/bash

# Install WhiteSur GTK themes/icons
cd ./.work
git clone https://github.com/arias0723/WhiteSur-gtk-theme
cd WhiteSur-gtk-theme
./install.sh
./tweak.sh -f monterey
cd ..
git clone https://github.com/arias0723/WhiteSur-icon-theme
cd WhiteSur-icon-theme
./install.sh
cd ../..

# NVIM cfg
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
nvim +'hi NormalFloat guibg=#1e222a' +PackerSync

# Add extra repositories
curl -O https://blackarch.org/strap.sh
chmod +x strap.sh
sudo ./strap.sh
sudo pacman -Sy