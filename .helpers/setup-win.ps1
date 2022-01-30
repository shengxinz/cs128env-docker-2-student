param([switch]$Elevated)

function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

if ((Test-Admin) -eq $false)  {
    if ($elevated) {
        # tried to elevate, did not work, aborting
    } else {
        Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
    }
    exit
}

'script obtained administrator privilege. continuing...'

$cs128env_dir=Convert-Path ../
docker run -d -v "${cs128env_dir}\src:/home/vagrant/src" -v "${cs128env_dir}\.shared:/home/vagrant/.shared" -p 2222:22 --security-opt seccomp=unconfined --name cs128env michaelrnowak/cpp-dev-env:latest
