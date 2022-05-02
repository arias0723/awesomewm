#!/bin/bash

# Init
CURRENT_USER=$(cat /etc/passwd | grep "/home" |cut -d: -f1 |head -1)
ARCH_PACKAGES=`grep -vE "^#" arch-packages.txt`
AUR_PACKAGES=`grep -vE "^#" aur-packages.txt`
mkdir -p ~/.config
mkdir -p ~/.local/share/fonts
mkdir ~/Pictures
# update pgp keyring
sudo pacman -Sy --needed --noconfirm archlinux-keyring

# Install base packages
sudo pacman -Syu --needed --noconfirm $ARCH_PACKAGES 2>&1 1>/dev/null
yay -Syu --needed --nodiffmenu --noremovemake --answerclean All --noconfirm $AUR_PACKAGES 2>&1 1>/dev/null

# WM cfg
cp -R resources/.config/. ~/.config/
cp -R resources/.screenlayout ~/
#cp -R resources/.Xresources.d ~/
cp -R resources/wallpapers/. ~/Pictures
cp -R resources/fonts/. ~/.local/share/fonts
cp resources/.Xresources ~/
cp resources/.xinitrc ~/
#cp resources/.gtkrc-2.0 ~/
chmod -R +x ~/.screenlayout
chmod +x ~/.xinitrc
sudo fc-cache -f -v
# patch awesomewm 
git clone https://github.com/arias0723/rxyhn-awesomewm
mv ~/.config/awesome ~/.config/awesome-orig
cp -R ./rxyhn-awesomewm/config/awesome ~/.config/awesome
cp ./rxyhn-awesomewm/misc/.Xresources ~/

# ZSH cfg
cp -R resources/zsh/theme/. ~/
sudo cp -R resources/zsh/theme/. /root
sudo ln -s -f ~/.p10k.zsh /root/.p10k.zsh
sudo ln -s -f ~/.zshrc /root/.zshrc
sudo usermod --shell /usr/bin/zsh $CURRENT_USER
sudo usermod --shell /usr/bin/zsh root

# NVIM cfg
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
nvim +'hi NormalFloat guibg=#1e222a' +PackerSync

# Add extra repositories
curl -O https://blackarch.org/strap.sh
chmod +x strap.sh
sudo ./strap.sh
sudo pacman -Sy

# Services cfg
sudo systemctl enable NetworkManager.service
# charger plug/unplug events (if you have a battery)
sudo systemctl enable acpid.service
sudo systemctl start acpid.service
# GDM init
sudo systemctl enable gdm.service
