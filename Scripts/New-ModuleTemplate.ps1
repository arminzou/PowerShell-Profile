#Requires -Version 7.0
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$ModuleName,
    
    [Parameter()]
    [string]$Description = "PowerShell module for $ModuleName functions",
    
    [Parameter()]
    [string]$Author = "Your Name",
    
    [Parameter()]
    [string]$Version = "1.0.0",
    
    [Parameter()]
    [string]$OutputPath = "$HOME\Documents\PowerShell\Modules"
)

# Create the module directory
$moduleDirectory = Join-Path -Path $OutputPath -ChildPath $ModuleName
if (-not (Test-Path -Path $moduleDirectory)) {
    New-Item -Path $moduleDirectory -ItemType Directory -Force | Out-Null
    Write-Host "Created module directory: $moduleDirectory" -ForegroundColor Green
}
else {
    Write-Warning "Module directory already exists: $moduleDirectory"
}

# Create the module file (.psm1)
$moduleFilePath = Join-Path -Path $moduleDirectory -ChildPath "$ModuleName.psm1"
$moduleContent = @"
# $ModuleName.psm1
# $Description

# Define any module-level variables here
`$script:moduleRoot = `$PSScriptRoot

#region Public Functions

function New-Function {
    <#
    .SYNOPSIS
        Example function
    .DESCRIPTION
        Example function showing the structure for a new function
    .PARAMETER Name
        Name parameter description
    .EXAMPLE
        New-Function -Name "Example"
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = `$true)]
        [string]`$Name
    )
    
    Write-Output "Hello, `$Name!"
}

#endregion

#region Private Functions

function Get-PrivateData {
    # This function is not exported and only available within the module
    param([string]`$Data)
    
    return "Private: `$Data"
}

#endregion

# Aliases
New-Alias -Name nfn -Value New-Function -Force -Scope Global

# Export public functions and aliases
Export-ModuleMember -Function New-Function
Export-ModuleMember -Alias nfn
"@

Set-Content -Path $moduleFilePath -Value $moduleContent
Write-Host "Created module file: $moduleFilePath" -ForegroundColor Green

# Create the module manifest (.psd1)
$manifestFilePath = Join-Path -Path $moduleDirectory -ChildPath "$ModuleName.psd1"
$manifestContent = @"
# Module manifest for module '$ModuleName'
@{
    # Script module or binary module file associated with this manifest
    RootModule = '$ModuleName.psm1'

    # Version number of this module
    ModuleVersion = '$Version'

    # ID used to uniquely identify this module
    GUID = '$(New-Guid)'

    # Author of this module
    Author = '$Author'

    # Description of the functionality provided by this module
    Description = '$Description'

    # Minimum version of the PowerShell engine required by this module
    PowerShellVersion = '7.0'

    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry
    FunctionsToExport = @(
        'New-Function'
    )

    # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry
    CmdletsToExport = @()

    # Variables to export from this module
    VariablesToExport = @()

    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry
    AliasesToExport = @(
        'nfn'
    )

    # Private data to pass to the module specified in RootModule/ModuleToProcess
    PrivateData = @{
        PSData = @{
            # Tags applied to this module
            Tags = @('$ModuleName')

            # A URL to the license for this module
            LicenseUri = ''

            # A URL to the main website for this project
            ProjectUri = ''
        }
    }
}
"@

Set-Content -Path $manifestFilePath -Value $manifestContent
Write-Host "Created module manifest: $manifestFilePath" -ForegroundColor Green

# Create a README file
$readmeFilePath = Join-Path -Path $moduleDirectory -ChildPath "README.md"
$readmeContent = @"
# $ModuleName

$Description

## Installation

```powershell
# Copy this module to your PowerShell modules directory
Copy-Item -Path "$moduleDirectory" -Destination "`$(`$env:PSModulePath -split ';')[0]" -Recurse -Force
```

## Functions

- `New-Function` - Example function

## Aliases

- `nfn` - Alias for New-Function
"@

Set-Content -Path $readmeFilePath -Value $readmeContent
Write-Host "Created README file: $readmeFilePath" -ForegroundColor Green

# Output summary
Write-Host "`nModule template created successfully!" -ForegroundColor Cyan
Write-Host "To use this module, add 'Import-Module $ModuleName' to your profile or run it manually." -ForegroundColor Cyan
Write-Host "You can also modify your profile to automatically load all modules in the Modules directory." -ForegroundColor Cyan 