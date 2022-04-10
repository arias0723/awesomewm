#!/bin/bash

# Init
CURRENT_USER=$(cat /etc/passwd | grep "/home" |cut -d: -f1 |head -1)
ARCH_PACKAGES=`grep -vE "^#" arch-packages.txt`
AUR_PACKAGES=`grep -vE "^#" aur-packages.txt`
mkdir -p ~/.config
mkdir -p ~/.local/share/fonts
mkdir ~/Pictures

# Install base packages
sudo pacman -Syu --needed --noconfirm $ARCH_PACKAGES
yay -Syu --needed --nodiffmenu --noremovemake --answerclean All --noconfirm $AUR_PACKAGES

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

# ZSH cfg
#cp -R resources/zsh/theme/. ~/
#sudo cp -R resources/zsh/theme/. /root
#sudo cp -R resources/zsh/plugins/. ~/ /usr/share
#sudo ln -s -f ~/.zshrc /root/.zshrc
#sudo usermod --shell /usr/bin/zsh ghost
#sudo usermod --shell /usr/bin/zsh root

# Services cfg
sudo systemctl enable NetworkManager.service
# For charger plug/unplug events (if you have a battery)
sudo systemctl enable acpid.service
sudo systemctl start acpid.service
sudo fc-cache -f -v

