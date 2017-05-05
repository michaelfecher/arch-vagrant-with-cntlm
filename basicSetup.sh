#!/bin/bash

echo "################################################################################"
echo " BASIC LINUX USER STUFF (creation, permissions..)"
echo "################################################################################"
# creating user, ZSH as shell is already installed by vagrant box image
sudo useradd -m -g wheel -G storage,power -s /usr/bin/zsh $VM_USER
# changes the password according to the given env variables of the host
sudo echo $VM_USER:$VM_PASS | sudo chpasswd
# put the user to the sudoers.d dir - but with password prompt if privileged command needs that
echo "$VM_USER ALL=(ALL) ALL" | sudo tee /etc/sudoers.d/$VM_USER > /dev/null

# german keyboard + german timezone
sudo localectl --no-convert set-keymap de-latin1-nodeadkeys
sudo ln -fs /usr/share/zoneinfo/Europe/Berlin /etc/localtime

# remove the user 'terry', the creator of the vagrant box
sudo rm -f /etc/sudoers.d/terry
sudo userdel -rf terry

echo "################################################################################"
echo "ZSH STUFF"
echo "################################################################################"
# clone the ZSH repo in the user dir
git clone https://github.com/robbyrussell/oh-my-zsh.git /home/$VM_USER/.oh-my-zsh
# replace ZSH env path with the current user path ... currently its located in line 2
sed -i "2s/VM_USER/$VM_USER/" /tmp/setup/.zshrc
mv /tmp/setup/.zshrc /home/$VM_USER/

echo "################################################################################"
echo "# SYSTEM - PACKAGE MANAGER and NTP/UTC Time"
echo "################################################################################"
# apply user repo stuff to pacman 
sudo mv /tmp/setup/pacman.conf /etc/pacman.conf

# update the certificates, otherwise all the following pacman updates will fail
sudo pacman -Sy --noconfirm archlinux-keyring 

# remove the old cert utils and reinstall the new one
sudo pacman -Rdd --noconfirm ca-certificates-utils
sudo pacman -S --noconfirm ca-certificates-utils

# system update
sudo pacman -Su --noconfirm

# installing timezone relevant packages and yaourt AUR
sudo pacman -S --noconfirm nfs-utils ntp yaourt
sudo systemctl enable ntpd
sudo hwclock --systohc --utc

echo "################################################################################"
echo "# SYSTEM - GUI (Tiling Manager, Login Manager, ...) "
echo "################################################################################"
# preparations for GUI
sudo pacman -S --noconfirm xorg-server xorg-server-utils xorg-xinit xorg-twm xterm lightdm-gtk-greeter accountsservice
sudo pacman -S --noconfirm i3-wm i3status dmenu

# terminal + nicer font
sudo pacman -S --noconfirm ttf-dejavu rxvt-unicode xclip
	
# move the x-related files to their appropriate place
mv /tmp/setup/.Xresources /home/$VM_USER/
mv /tmp/setup/.xinitrc /home/$VM_USER/

# i3 tiling manager stuff
mkdir --parents /home/$VM_USER/.config/i3/; mv /tmp/setup/.config/i3/config $_
mv /tmp/setup/X11/xorg.conf.d/20-keyboard.conf /etc/X11/xorg.conf.d/20-keyboard.conf


# change ownership of the copied files to the $VM_USER
sudo chown -R $VM_USER:wheel /home/$VM_USER

sudo systemctl enable lightdm.service
sudo systemctl start lightdm.service