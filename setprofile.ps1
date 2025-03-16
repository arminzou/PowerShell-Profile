$profilePath = Split-Path -Path $PROFILE
Copy-Item -Path .\Microsoft.PowerShell_profile.ps1 -Destination $profilePath