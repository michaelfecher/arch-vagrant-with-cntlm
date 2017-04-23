# Arch Linux VM with automated Proxy configuration via CNTLM
Using an Arch Linux VM behind a (corporate) proxy? 
This solution provides an automated way to setup the CNTLM proxy from Windows without PowerShell stuff.
You only have to adapt the CNTLM template and of course the Vagrant provisioning phase.

# Why should someone do this?
Because you like to work with Linux on your working machine, but can not use it natively, because of all the corporate stuff 
like Outlook, Office.. (yawn).
Even also the setup of the CNTLM is very disgusting and is error-proneous.
If a lot of developers in a department or company want or will have to use Linux in VM, this approach will save a lot of time.

# Prerequisites
Ok, it's not as pain free as someone has expected.
Of course you will need some temporary admin rights on Windows or at least someone who can do that for you for installing the following stuff.
## Git 
If you don't have access to git, then get yourself a portable version of [https://www.collab.net/downloads/giteye][GitEye].
The application won't need any admin rights to install.
Clone this repo.
## VirtualBox + Guest Extensions
This one can't be done as a non priviledged user.
## Vagrant for Windows
Do not install it your user's home, because it could lead into trouble.

# ToDos / Steps to be taken
This steps are not implemented yet, but concepted.
## Enable Linux commands in Windows
Integrate 
[https://frippery.org/busybox/]
or
msys2 portable 
in this repository in order to get grep + sed

It's more easier to use these commands instead of Windows `findStr`

## Setup the files (batch, CNTLM config, CNTLM for Windows&Linux) in Windows
- setup a `cntlm.conf` template, which will be (re-)used in Windows and in the Linux VM.
The template has to include a variable for the username and the password.
Make sure that you adapt the domain in the CNTLM as well.
- start the batch file with username and password for the proxy as arguments

## Commands in the Windows batch file
- replace the username variable in the cntlm template with the provided one via
- run the portable cntlm version on Windows, in order to generate the NTLMv2 password via
 
      cntlm -H

- use `grep -oP "PassNTLMv2\s+\K\w+"` on the CNTLM output to fetch the generated password
- combine previous step with sed to replace the $USER_NTLM hash in the `cntlm.conf.template`
- run  `sed -e 's/$USER_NAME/<YOUR_ENTERED_USERNAME>/g' cntlm.conf.template > cntlm.conf`

## Run Vagrant via the batch file
- Adapt the Linux distribution, because you freely can change to another one, e.g. CentOS, Ubuntu..
- Copy all the CNTLM binaries for the Linux distribution (**caution**: get the appropriate ones, if you don't want to use Arch)
