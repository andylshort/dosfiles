if (-Not (Test-Path -path $profile)) {
    New-Item -Path $profile -Type file -Force
}
Copy-Item -Path Microsoft.PowerShell_profile.ps1 -Destination (Get-Item $profile).Directory -Force

# Install chocolatey
choco install autohotkey.install