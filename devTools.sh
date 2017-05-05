#!/bin/bash

echo "################################################################################"
echo " Java specific stuff (JDK, some enhancements, maven)"
echo "################################################################################"
sudo pacman -S --noconfirm jdk8-openjdk maven

sudo grep "_JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=lcd'" /etc/environment
if [ $? -eq 1 ]; then
  echo "Set optimized java fonts"
  echo "_JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=lcd'" | sudo tee -a /etc/environment
fi

sudo yum -S --noconfirm intellij-idea-ue-bundled-jre