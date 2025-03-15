# Productivity.psm1
# Productivity enhancement functions and utilities

# Define any module-level variables here
$script:moduleRoot = $PSScriptRoot

#region Public Functions

function Copy-TextToClipboard {
    <#
    .SYNOPSIS
        Copies text to the clipboard
    .DESCRIPTION
        Places the specified text on the Windows clipboard
    .PARAMETER Text
        The text to copy to the clipboard
    .EXAMPLE
        Copy-TextToClipboard "Hello, world!"
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [string]$Text
    )
    
    Set-Clipboard -Value $Text
    Write-Verbose "Text copied to clipboard."
}

function Get-ClipboardContent {
    <#
    .SYNOPSIS
        Gets the content from the clipboard
    .DESCRIPTION
        Retrieves text from the Windows clipboard
    .EXAMPLE
        Get-ClipboardContent
    #>
    [CmdletBinding()]
    param()
    
    return Get-Clipboard
}

function Set-LocationToDocuments {
    <#
    .SYNOPSIS
        Changes to the Documents folder
    .DESCRIPTION
        Sets the current location to the user's Documents folder
    .EXAMPLE
        Set-LocationToDocuments
    #>
    [CmdletBinding()]
    param()
    
    $docs = if (([Environment]::GetFolderPath("MyDocuments"))) { 
        ([Environment]::GetFolderPath("MyDocuments")) 
    } 
    else { 
        $HOME + "\Documents" 
    }
    
    Set-Location -Path $docs
    Write-Host "Changed to Documents folder: $docs" -ForegroundColor Cyan
}

function Set-LocationToDesktop {
    <#
    .SYNOPSIS
        Changes to the Desktop folder
    .DESCRIPTION
        Sets the current location to the user's Desktop folder
    .EXAMPLE
        Set-LocationToDesktop
    #>
    [CmdletBinding()]
    param()
    
    $dtop = if ([Environment]::GetFolderPath("Desktop")) { 
        [Environment]::GetFolderPath("Desktop") 
    } 
    else { 
        $HOME + "\Desktop" 
    }
    
    Set-Location -Path $dtop
    Write-Host "Changed to Desktop folder: $dtop" -ForegroundColor Cyan
}

function Show-DirectoryListing {
    <#
    .SYNOPSIS
        Shows directory content with detailed formatting
    .DESCRIPTION
        Lists all files in the current directory with detailed formatting
    .PARAMETER IncludeHidden
        Whether to include hidden files in the listing
    .EXAMPLE
        Show-DirectoryListing
    .EXAMPLE
        Show-DirectoryListing -IncludeHidden
    #>
    [CmdletBinding()]
    param(
        [Parameter()]
        [switch]$IncludeHidden
    )
    
    if ($IncludeHidden) {
        Get-ChildItem -Path . -Force -Hidden | Format-Table -AutoSize
    }
    else {
        Get-ChildItem -Path . -Force | Format-Table -AutoSize
    }
}

function Show-DirectoryListingWithHidden {
    <#
    .SYNOPSIS
        Shows directory content with detailed formatting including hidden files
    .DESCRIPTION
        Lists all files (including hidden ones) in the current directory with detailed formatting
    .EXAMPLE
        Show-DirectoryListingWithHidden
    #>
    [CmdletBinding()]
    param()
    
    Show-DirectoryListing -IncludeHidden
}

function Find-String {
    <#
    .SYNOPSIS
        Searches for patterns in files
    .DESCRIPTION
        Finds lines in files or input that match a specified pattern
    .PARAMETER Pattern
        The regular expression pattern to search for
    .PARAMETER Path
        The directory to search in (optional)
    .EXAMPLE
        Find-String "error" C:\logs
    .EXAMPLE
        Get-Content log.txt | Find-String "warning"
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Pattern,
        
        [Parameter(Position = 1)]
        [string]$Path,
        
        [Parameter(ValueFromPipeline = $true)]
        [string[]]$InputObject
    )
    
    begin {
        $lines = @()
    }
    
    process {
        if ($InputObject) {
            $lines += $InputObject
        }
    }
    
    end {
        if ($Path) {
            Get-ChildItem $Path | Select-String $Pattern
            return
        }
        
        if ($lines.Count -gt 0) {
            $lines | Select-String $Pattern
        }
    }
}

#endregion

# Aliases
New-Alias -Name cpy -Value Copy-TextToClipboard -Force -Scope Global
New-Alias -Name pst -Value Get-ClipboardContent -Force -Scope Global
New-Alias -Name docs -Value Set-LocationToDocuments -Force -Scope Global
New-Alias -Name dtop -Value Set-LocationToDesktop -Force -Scope Global
New-Alias -Name la -Value Show-DirectoryListing -Force -Scope Global
New-Alias -Name ll -Value Show-DirectoryListingWithHidden -Force -Scope Global
New-Alias -Name grep -Value Find-String -Force -Scope Global

# Export functions and aliases
Export-ModuleMember -Function Copy-TextToClipboard, Get-ClipboardContent, Set-LocationToDocuments,
Set-LocationToDesktop, Show-DirectoryListing, Find-String,
Show-DirectoryListingWithHidden
Export-ModuleMember -Alias cpy, pst, docs, dtop, la, ll, grep 