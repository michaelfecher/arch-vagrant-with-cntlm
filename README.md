# Arch Linux VM with automated Proxy configuration via CNTLM
Using an Arch Linux VM behind a (corporate) proxy? 
This solution provides an automated way to setup the CNTLM proxy from Windows, based on PowerShell, Vagrant and CNTLM (Windows/Linux).
You only have to adapt the CNTLM template with general settings and of course the Vagrant provisioning phase.
The forking of this repo is _strictly recommended_ and necessary, because you want to provide the adapted CNTLM template
and the binaries of CNTLM (Windows/Linux) to your users, without downloading it by themselves.

# Why should someone do this?
Because you like to work with Linux on your work-related machine, but can not use it natively, because of all the corporate stuff 
like Outlook, Office.. (yawn).
Even also the setup of CNTLM is very disgusting and error-prone.
If a lot of developers in a department or company want or will have to use Linux in VM, this approach will save a lot of time.

# Prerequisites
Ok, it's not as pain free as someone may expected.
Of course you will need some temporary admin rights on Windows or at least someone who can do that for you for installing the following stuff.

## Git (Optional)
If you don't have access to git, then get yourself a portable version of [GitEye](https://www.collab.net/downloads/giteye).
The application won't need any admin rights to install.
Clone this repo OR download it as snapshot to your computer.

## CNTLM windows binaries
Download the [CNTLM windows binaries](https://sourceforge.net/projects/cntlm/files/cntlm/cntlm%200.92.3/cntlm-0.92.3-win32.zip/download) and extract the ZIP content in the 

    /cntlm-win/

folder.

## CNTLM Arch Linux binaries
This is technically no prerequisite, but noteworthy to mention.

I've built the binary file for Arch Linux and placed it in the `/cntlm-linux/` folder.
The Arch Linux build of CNTLM will be installed via `pacman -U <cntlm-build>`.
The build is based upon the latest [CNTLM Linux version](https://sourceforge.net/projects/cntlm/files/cntlm/cntlm%200.92.3/cntlm-0.92.3.tar.gz/download),
so all credits belong to the owner and author of CNTLM.

## VirtualBox + Guest Extensions
This one can't be done as a non privileged user.

## Vagrant for Windows
Do not install it to your user's home, because it could lead into trouble with Vagrant itself, e.g. the batch file can not start the `vagrant up` process.

# Before you start
## Proxy / NoProxy in cntlm.conf.template
Adapt the proxy settings for your department/company in the `cntlm.conf.template`.
To be more precise, adapt the value after `Proxy` with your proxy-host and proxy-port.
And also adapt the `NoProxy`, if you want to bypass local addresses, e.g. intranet.
You also have to edit the `Domain` value, because nowadays everyone is using NTLMv2 on Windows.

This step usually needs to be done once, except the proxy, the domain or the company changes.

## Adapt the provisioning files
Each development team and their individuals have other preferences, e.g. firefox vs chrome, intellij-idea vs. eclipse and so on.
Therefore you have to adapt the `devTools.sh` and `userSpecificStuff.sh` provisioning files especially.

Currently I am using IDEA, openJDK8, maven and firefox.
Therefore these software packages are installed.

# Run the PowerShell script to setup your VM
After you've adapted the `cntlm.conf.template` to your team's needs, you can 
start it via 

    01_setup.ps1

Enter your proxy user and the related password for the concerned user.
These credentials are also used for generating the Linux user on the VM.

If everything went along the happy path, a separate window with the Windows version of CNTLM and another
one with Vagrant will appear. If there are any failures within this process, make sure you
put the Windows binaries of CNTLM in the correct folder and used your correct credentials.

After the Vagrant process, you can login in your VM with your entered proxy credentials.
Enjoy.

# Improvements
- **Credentials setup**: For user and developer specific access (git, maven, ...) it is necessary to copy
the settings files to the appropriate place. 
- **Install Wizard**: For the provisioning stuff, I'd like to add a wizard, which makes it easier to choose, what
packages are need to be installed by Vagrant. Currently the adaption of the `devTools.sh` and the `userSpecificStuff.sh`
is necessary for the needs of a developer/a development team.
