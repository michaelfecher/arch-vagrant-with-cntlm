##
## SETUP CNTLM ... THIS IS THE ENTRY POINT AFTER SETTING UP THE CNTLM TEMPLATE - WELCOME TO YOU.
##
## the credentials of the user are NOT stored on the HDD as file, except as env variable in memory / on process time.
## with the help of the credentials, the user on the VM will be created with the provided user:password.

# all files need to be read and written with no windows line feeds (aka -raw when reading, aka -NoNewline when writing)
# otherwise cntlm will fail to generate the correct password
Param(
	[Parameter(Mandatory=$true)] $user_name,
    [Parameter(Mandatory=$true)][SecureString] $user_password 
)   

$user_pw_decrypted = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($user_password))
(get-content .\cntlm.conf.template -raw) | %{$_ -replace "USER_NAME",$user_name} | Set-Content -NoNewline cntlm.conf

$ntlmv2_hash = echo $user_pw_decrypted | .\cntlm-win\cntlm.exe -c ".\cntlm.conf" -H -v | Select-String -Pattern "PassNTLMv2\s+(\S+)"
(get-content .\cntlm.conf -raw) | %{$_ -replace "USER_PASS",$ntlmv2_hash.Matches[0].Groups[1].Value} | Set-Content -NoNewline cntlm.conf

##
## SETUP ENV FOR WINDOWS VAGRANT 
##
## otherwise vagrant can not connect to the internet... 
## these env vars are also going to be exported in the Vagrantfile to the VM
## all env vars are erased after this process
$env:HTTPS_PROXY = "http://localhost:3128"
$env:HTTP_PROXY = $env:HTTPS_PROXY
$env:HTTP_PROXY = $env:HTTPS_PROXY
$env:HTTP_PROXY = $env:HTTPS_PROXY
$env:VM_USER = $user_name.toLower() # needed for linux, because uppercase names are not allowed
$env:VM_PASS = $user_pw_decrypted

##
## START CNTLM WITH PROVIDED OR NEWLY CREATED CONFIG
##
$arguments_cntlm = "-c "".\cntlm.conf"" -v"
Start-Process -FilePath ".\cntlm-win\cntlm.exe" -ArgumentList $arguments_cntlm
##
## START VAGRANT - THE MAGIC HAPPENS IN THE VAGRANTFILE AFTER THIS STEP
##
Start-Process -FilePath "vagrant" -ArgumentList "up" -LoadUserProfile

