#!/bin/bash

echo "################################################################################"
echo " User specific applications "
echo "################################################################################"
# firefox proxy is set through /etc/environment
sudo pacman -S --noconfirm firefox 1>/dev/null

