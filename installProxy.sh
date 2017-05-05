#!/bin/bash
sudo pacman -U --noconfirm /tmp/setup/cntlm-0.92.3-4-x86_64.pkg.tar.xz
sudo mv /tmp/setup/cntlm.conf /etc/cntlm.conf
sudo systemctl enable cntlm.service
sudo systemctl start cntlm.service

sudo mv /tmp/setup/proxy_functions /etc/proxy_functions
sudo chmod a+x /etc/proxy_functions

# keep env variables + proxy stuff when sudo'ing - needed for provisioning
#
# check, if the keeping of the env variables due to sudoers is set.
# if it is no set, then it is appended to the file
sudo grep 'Defaults env_keep += "http_proxy HTTP_PROXY https_proxy HTTPS_PROXY"' /etc/sudoers
if [ $? -eq 1 ]; then
  echo "Setting http proxy in sudoers file..."
  sudo cp /etc/sudoers /tmp/sudoers.old
  echo "Defaults env_keep += \"http_proxy HTTP_PROXY https_proxy HTTPS_PROXY\"" | sudo tee -a /tmp/sudoers.old
 
  echo "Verifying, that everything's ok in the new sudoers file"
  sudo visudo -cf /tmp/sudoers.old
  if [ $? -eq 0 ]; then
	echo "sudoers file was ok... replacing the old one"
	sudo cp /tmp/sudoers.old /etc/sudoers
  fi
fi


