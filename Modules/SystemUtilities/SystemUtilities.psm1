# SystemUtilities.psm1
# System management and utility functions

# Define any module-level variables here
$script:moduleRoot = $PSScriptRoot

#region Public Functions

function Update-PowerShellCore {
    <#
    .SYNOPSIS
        Checks for and installs PowerShell Core updates
    .DESCRIPTION
        Queries GitHub API for the latest PowerShell release and updates if needed
    .EXAMPLE
        Update-PowerShellCore
    #>
    [CmdletBinding()]
    param()
    
    try {
        Write-Host "Checking for PowerShell updates..." -ForegroundColor Cyan
        $updateNeeded = $false
        $currentVersion = $PSVersionTable.PSVersion.ToString()
        
        # Test internet connectivity before attempting GitHub API call
        $canConnectToGitHub = Test-Connection github.com -Count 1 -Quiet -TimeoutSeconds 1
        if (-not $canConnectToGitHub) {
            Write-Warning "Cannot connect to GitHub. Skipping PowerShell update check."
            return
        }
        
        try {
            $gitHubApiUrl = "https://api.github.com/repos/PowerShell/PowerShell/releases/latest"
            $latestReleaseInfo = Invoke-RestMethod -Uri $gitHubApiUrl -TimeoutSec 5
            $latestVersion = $latestReleaseInfo.tag_name.Trim('v')
            
            if ($currentVersion -lt $latestVersion) {
                $updateNeeded = $true
                Write-Host "Current version: $currentVersion, Latest version: $latestVersion" -ForegroundColor Yellow
            }
        }
        catch {
            Write-Warning "Failed to check for PowerShell updates. Error: $($_.Exception.Message)"
            return
        }

        if ($updateNeeded) {
            Write-Host "Updating PowerShell..." -ForegroundColor Yellow
            
            # Check if winget is available
            if (Get-Command winget -ErrorAction SilentlyContinue) {
                try {
                    Start-Process powershell.exe -ArgumentList "-NoProfile -Command winget upgrade Microsoft.PowerShell --accept-source-agreements --accept-package-agreements" -Wait -NoNewWindow
                    Write-Host "PowerShell has been updated. Please restart your shell to reflect changes" -ForegroundColor Magenta
                }
                catch {
                    Write-Error "Failed to update PowerShell using winget. Error: $($_.Exception.Message)"
                    Write-Host "Please update PowerShell manually from https://github.com/PowerShell/PowerShell/releases" -ForegroundColor Yellow
                }
            }
            else {
                Write-Warning "Winget not found. Please install PowerShell manually from https://github.com/PowerShell/PowerShell/releases"
            }
        }
        else {
            Write-Host "Your PowerShell is up to date ($currentVersion)." -ForegroundColor Green
        }
    }
    catch {
        Write-Error "Failed to update PowerShell. Error: $($_.Exception.Message)"
        Write-Host "Exception details: $($_)" -ForegroundColor Red
    }
}

function Clear-SystemCache {
    <#
    .SYNOPSIS
        Clears various system caches
    .DESCRIPTION
        Clears Windows Prefetch, Temp, and Internet Explorer cache
    .EXAMPLE
        Clear-SystemCache
    #>
    [CmdletBinding()]
    param()
    
    Write-Host "Clearing cache..." -ForegroundColor Cyan

    # Clear Windows Prefetch
    Write-Host "Clearing Windows Prefetch..." -ForegroundColor Yellow
    Remove-Item -Path "$env:SystemRoot\Prefetch\*" -Force -ErrorAction SilentlyContinue

    # Clear Windows Temp
    Write-Host "Clearing Windows Temp..." -ForegroundColor Yellow
    Remove-Item -Path "$env:SystemRoot\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue

    # Clear User Temp
    Write-Host "Clearing User Temp..." -ForegroundColor Yellow
    Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue

    # Clear Internet Explorer Cache
    Write-Host "Clearing Internet Explorer Cache..." -ForegroundColor Yellow
    Remove-Item -Path "$env:LOCALAPPDATA\Microsoft\Windows\INetCache\*" -Recurse -Force -ErrorAction SilentlyContinue

    Write-Host "Cache clearing completed." -ForegroundColor Green
}

function Get-SystemUptime {
    <#
    .SYNOPSIS
        Displays system uptime
    .DESCRIPTION
        Shows the time since the system was last booted
    .EXAMPLE
        Get-SystemUptime
    #>
    [CmdletBinding()]
    param()
    
    try {
        # check powershell version
        if ($PSVersionTable.PSVersion.Major -eq 5) {
            $lastBoot = (Get-WmiObject win32_operatingsystem).LastBootUpTime
            $bootTime = [System.Management.ManagementDateTimeConverter]::ToDateTime($lastBoot)
        }
        else {
            # Get last boot time using CimInstance which works cross-platform
            $bootTime = (Get-CimInstance -ClassName Win32_OperatingSystem).LastBootUpTime
        }

        # Format the start time
        $formattedBootTime = $bootTime.ToString("dddd, MMMM dd, yyyy HH:mm:ss", [System.Globalization.CultureInfo]::InvariantCulture)
        Write-Host "System started on: $formattedBootTime" -ForegroundColor DarkGray

        # calculate uptime
        $uptime = (Get-Date) - $bootTime

        # Uptime in days, hours, minutes, and seconds
        $days = $uptime.Days
        $hours = $uptime.Hours
        $minutes = $uptime.Minutes
        $seconds = $uptime.Seconds

        # Uptime output
        Write-Host ("Uptime: {0} days, {1} hours, {2} minutes, {3} seconds" -f $days, $hours, $minutes, $seconds) -ForegroundColor Blue
    }
    catch {
        Write-Error "An error occurred while retrieving system uptime."
    }
}

function Start-AdminSession {
    <#
    .SYNOPSIS
        Starts a new session with administrator privileges
    .DESCRIPTION
        Opens a new Windows Terminal session with elevated rights
    .PARAMETER Command
        Optional command to run in the elevated session
    .EXAMPLE
        Start-AdminSession
    .EXAMPLE
        Start-AdminSession "Get-Service | Where-Object {$_.Status -eq 'Running'}"
    #>
    [CmdletBinding()]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Command
    )
    
    if ($Command.Count -gt 0) {
        $argList = $Command -join ' '
        Start-Process wt -Verb runAs -ArgumentList "pwsh.exe -NoExit -Command $argList"
    }
    else {
        Start-Process wt -Verb runAs
    }
}

function Get-ComputerInformation {
    <#
    .SYNOPSIS
        Displays system information
    .DESCRIPTION
        Shows detailed information about the computer
    .EXAMPLE
        Get-ComputerInformation
    #>
    [CmdletBinding()]
    param()
    
    Write-Host "System Information:" -ForegroundColor Cyan
    Get-ComputerInfo
}

function Stop-ProcessByName {
    <#
    .SYNOPSIS
        Stops a process by name
    .DESCRIPTION
        Terminates the specified process
    .PARAMETER Name
        The name of the process to stop
    .EXAMPLE
        Stop-ProcessByName "notepad"
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Name
    )
    
    Get-Process $Name -ErrorAction SilentlyContinue | Stop-Process
    Write-Host "Stopped process: $Name" -ForegroundColor Yellow
}

function Move-ToRecycleBin {
    <#
    .SYNOPSIS
        Moves a file or folder to the recycle bin
    .DESCRIPTION
        Safely deletes a file or folder by moving it to the recycle bin
    .PARAMETER Path
        The path to the item to delete
    .EXAMPLE
        Move-ToRecycleBin "C:\temp\oldfile.txt"
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Path
    )
    
    $fullPath = (Resolve-Path -Path $Path).Path

    if (Test-Path $fullPath) {
        $item = Get-Item $fullPath

        if ($item.PSIsContainer) {
            # Handle directory
            $parentPath = $item.Parent.FullName
        }
        else {
            # Handle file
            $parentPath = $item.DirectoryName
        }

        $shell = New-Object -ComObject 'Shell.Application'
        $shellItem = $shell.NameSpace($parentPath).ParseName($item.Name)

        if ($item) {
            $shellItem.InvokeVerb('delete')
            Write-Host "Item '$fullPath' has been moved to the Recycle Bin." -ForegroundColor Green
        }
        else {
            Write-Host "Error: Could not find the item '$fullPath' to trash." -ForegroundColor Red
        }
    }
    else {
        Write-Host "Error: Item '$fullPath' does not exist." -ForegroundColor Red
    }
}

function Get-VolumeInformation {
    <#
    .SYNOPSIS
        Shows volume information
    .DESCRIPTION
        Displays information about volumes on the system
    .EXAMPLE
        Get-VolumeInformation
    #>
    [CmdletBinding()]
    param()
    
    Get-Volume
}

#endregion

# Aliases
New-Alias -Name Update-PowerShell -Value Update-PowerShellCore -Force -Scope Global
New-Alias -Name Clear-Cache -Value Clear-SystemCache -Force -Scope Global
New-Alias -Name uptime -Value Get-SystemUptime -Force -Scope Global
New-Alias -Name admin -Value Start-AdminSession -Force -Scope Global
New-Alias -Name su -Value Start-AdminSession -Force -Scope Global
New-Alias -Name sysinfo -Value Get-ComputerInformation -Force -Scope Global
New-Alias -Name k9 -Value Stop-ProcessByName -Force -Scope Global
New-Alias -Name trash -Value Move-ToRecycleBin -Force -Scope Global
New-Alias -Name df -Value Get-VolumeInformation -Force -Scope Global

# Export functions and aliases
Export-ModuleMember -Function Update-PowerShellCore, Clear-SystemCache, Get-SystemUptime, 
Start-AdminSession, Get-ComputerInformation, Stop-ProcessByName,
Move-ToRecycleBin, Get-VolumeInformation
Export-ModuleMember -Alias Update-PowerShell, Clear-Cache, uptime, admin, su, sysinfo, k9, trash, df 