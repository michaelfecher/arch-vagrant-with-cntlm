# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "terrywang/archlinux"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.56.99"
  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
   config.vm.provider "virtualbox" do |vb|
     # Display the VirtualBox GUI when booting the machine
     vb.gui = true
     vb.cpus = 4
     vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
     vb.customize ["modifyvm", :id, "--draganddrop", "hosttoguest"]
     # Customize the amount of memory on the VM:
     vb.memory = "8096"
   end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
    # set the shared folder of host (1st argument) + guest (2nd argument)
  config.vm.synced_folder "C:/vm_shared", "/media/sf_vm_shared", create: true,
	group: "wheel",
	mount_options: ["dmode=775,fmode=664"]
  
  # copy CNTLM stuff to VM 
  # the cntlm snapshot can be found here: https://aur.archlinux.org/packages/cntlm/
  # manual steps before:
  # extract the snapshot tar and built via makepkg
  # this needs to be installed via pacman -U
  config.vm.provision :file do |file|
    file.source = "cntlm-linux/cntlm-0.92.3-4-x86_64.pkg.tar.xz"
    file.destination = "/tmp/setup/cntlm-0.92.3-4-x86_64.pkg.tar.xz"
  end
  
  # proxy settings
  config.vm.provision :file do |file|
    file.source = "cntlm.conf"
    file.destination = "/tmp/setup/cntlm.conf"
  end   

  # useful scripts / functions for use in the linux terminal
  config.vm.provision :file do |file|
    file.source = "scripts"
    file.destination = "/tmp/setup/scripts"
  end
  
  config.vm.provision :file do |file|
    file.source = "arch-config"
    file.destination = "/tmp/setup"
  end
  
  # copy credentials
  config.vm.provision :file do |file|
    file.source = "credentials-files"
    file.destination = "/tmp/setup/credentials-files"
  end  

  config.vm.provision "shell", path: "installProxy.sh"
  
  config.vm.provision "shell", path: "basicSetup.sh", 
  env: {
  "VM_USER" => ENV['VM_USER'], 
  "VM_PASS" => ENV['VM_PASS'],
  "HTTP_PROXY" => ENV['HTTP_PROXY'],
  "http_proxy" => ENV['HTTP_PROXY'],
  "https_proxy" => ENV['HTTP_PROXY'],
  "HTTPS_PROXY" => ENV['HTTP_PROXY']
  }
  
  config.vm.provision "shell", path: "devTools.sh", 
  env: {
  "VM_USER" => ENV['VM_USER'], 
  "VM_PASS" => ENV['VM_PASS'],
  "HTTP_PROXY" => ENV['HTTP_PROXY'],
  "http_proxy" => ENV['HTTP_PROXY'],
  "https_proxy" => ENV['HTTP_PROXY'],
  "HTTPS_PROXY" => ENV['HTTP_PROXY']
  }
  
  
  config.vm.provision "shell", path: "userSpecificStuff.sh",
  env: {
  "VM_USER" => ENV['VM_USER'], 
  "VM_PASS" => ENV['VM_PASS'],
  "HTTP_PROXY" => ENV['HTTP_PROXY'],
  "http_proxy" => ENV['HTTP_PROXY'],
  "https_proxy" => ENV['HTTP_PROXY'],
  "HTTPS_PROXY" => ENV['HTTP_PROXY']
  }
end
