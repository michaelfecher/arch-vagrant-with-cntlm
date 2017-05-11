#!/bin/bash

echo "################################################################################"
echo " BASIC LINUX USER STUFF (creation, permissions..)"
echo "################################################################################"
# creating user, ZSH as shell is already installed by vagrant box image
sudo useradd -m -g wheel -G video,audio,input,power,storage,optical,lp,scanner,vboxsf -s /usr/bin/zsh $VM_USER
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

# update the config/scripts permissions
sudo chown -R $VM_USER:wheel /tmp/
sudo mv /tmp/setup/scripts /etc/scripts
sudo chmod -R a+x /etc/scripts

echo "################################################################################"
echo "ZSH STUFF"
echo "################################################################################"
# clone the ZSH repo in the user dir
git clone https://github.com/robbyrussell/oh-my-zsh.git /home/$VM_USER/.oh-my-zsh
# replace ZSH env path with the current user path ... currently its located in line 2
sed -i "2s/VM_USER/$VM_USER/" /tmp/setup/arch-config/.zshrc
mv /tmp/setup/arch-config/.zshrc /home/$VM_USER/

echo "################################################################################"
echo "# SYSTEM - PACKAGE MANAGER and NTP/UTC Time"
echo "################################################################################"
# apply user repo stuff to pacman 
sudo mv /tmp/setup/arch-config/pacman.conf /etc/pacman.conf

# update the certificates, otherwise all the following pacman updates will fail
sudo pacman -Sy --noconfirm archlinux-keyring 1>/dev/null

# remove the old cert utils and reinstall the new one
sudo pacman -Rdd --noconfirm ca-certificates-utils 1>/dev/null
sudo pacman -S --noconfirm ca-certificates-utils 1>/dev/null

# system update
sudo pacman -Su --noconfirm 1>/dev/null

# installing timezone relevant packages
sudo pacman -S --noconfirm nfs-utils ntp 1>/dev/null 
sudo systemctl enable ntpd
sudo hwclock --systohc --utc

echo "################################################################################"
echo "# SYSTEM - GUI (Tiling Manager, Login Manager, ...) "
echo "################################################################################"
# preparations for GUI
sudo pacman -S --noconfirm xorg-server xorg-xinit xorg-twm xterm lightdm lightdm-gtk-greeter accountsservice 1>/dev/null
sudo pacman -S --noconfirm i3-wm i3status dmenu 1>/dev/null

# terminal + nicer font + copy+paste for terminal
sudo pacman -S --noconfirm ttf-dejavu rxvt-unicode xclip 1>/dev/null
mv /etc/scripts/clipboard /usr/lib/urxvt/perl/
	
# move the x-related files to their appropriate place
mv /tmp/setup/arch-config/.Xresources /home/$VM_USER/
mv /tmp/setup/arch-config/.xinitrc /home/$VM_USER/
	
# i3 tiling manager stuff
mkdir --parents /home/$VM_USER/.config/i3/; mv /tmp/setup/arch-config/config $_
mv /tmp/setup/arch-config/20-keyboard.conf /etc/X11/xorg.conf.d/20-keyboard.conf


# change ownership of the copied files to the $VM_USER
sudo chown -R $VM_USER /home/$VM_USER
sudo chown -R $VM_USER:vboxsf /media
mv /tmp/setup/arch-config/vboxclientall.sh /etc/profile.d/

sudo chown -R $VM_USER /etc/environment

# remove the default.target link, otherwise lightdm won't startup automatically
sudo rm /etc/systemd/system/default.target
sudo systemctl enable lightdm.service
sudo systemctl start lightdm.service
