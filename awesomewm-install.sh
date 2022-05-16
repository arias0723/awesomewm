#!/bin/bash

# Init
CURRENT_USER=$(cat /etc/passwd | grep "/home" | cut -d: -f1 | head -1)
ARCH_PACKAGES=`grep -vE "^#" arch-packages.txt`
AUR_PACKAGES=`grep -vE "^#" aur-packages.txt`
mkdir -p ~/.config
mkdir -p ~/.local/share/fonts
mkdir ~/Pictures
mkdir ./.work

# Update pgp keyring & system
sudo pacman -Sy --needed --noconfirm archlinux-keyring
sudo pacman -Syu
# Install yay package manager
sudo pacman -S --needed --noconfirm git
git clone https://aur.archlinux.org/yay.git ./.work/yay
cd .work/yay
makepkg -si 
cd ../..
# Install base packages
yay -S --needed --nodiffmenu --noremovemake --answerclean All --noconfirm $AUR_PACKAGES
sudo pacman -S --needed --noconfirm $ARCH_PACKAGES

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
#git clone https://github.com/arias0723/rxyhn-awesomewm
#mv ~/.config/awesome ~/.config/awesome-orig
#cp -R ./rxyhn-awesomewm/config/awesome ~/.config/
#cp ./rxyhn-awesomewm/misc/.Xresources ~/

# install WhiteSur GTK themes/icons
cd .work
git clone https://github.com/arias0723/WhiteSur-gtk-theme
cd WhiteSur-gtk-theme
./install.sh
./tweak.sh -f monterey
cd ..
git clone https://github.com/arias0723/WhiteSur-icon-theme
cd WhiteSur-icon-theme
./install.sh
cd ../..

# ZSH cfg
cp -R resources/zsh/theme/. ~/
sudo cp -R resources/zsh/theme/. /root
sudo ln -s -f ~/.p10k.zsh /root/.p10k.zsh
sudo ln -s -f ~/.zshrc /root/.zshrc
sudo usermod --shell /usr/bin/zsh $CURRENT_USER
sudo usermod --shell /usr/bin/zsh root

# Services cfg
sudo systemctl enable NetworkManager.service
# charger plug/unplug events (if you have a battery)
sudo systemctl enable acpid.service
sudo systemctl start acpid.service
# GDM init
#sudo systemctl enable gdm.service
#sudo systemctl enable lightdm.service
