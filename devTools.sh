#!/bin/bash

echo "################################################################################"
echo " Java specific stuff (JDK, some enhancements, maven)"
echo "################################################################################"
sudo pacman -S --noconfirm jdk8-openjdk maven 1>/dev/null

sudo grep "_JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=lcd'" /etc/environment
if [ $? -eq 1 ]; then
  echo "Set optimized java fonts"
  echo "_JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=lcd'" | sudo tee -a /etc/environment
fi

yaourt -S --noconfirm intellij-idea-community-edition 1>/dev/null
