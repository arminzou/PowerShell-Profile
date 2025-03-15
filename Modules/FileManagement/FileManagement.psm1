# FileManagement.psm1
# Module for file management related functions

# Define any module-level variables here
$script:defaultEncoding = 'ASCII'

#region Public Functions

function New-File {
    <#
    .SYNOPSIS
        Creates a new file or updates the timestamp of an existing file
    .DESCRIPTION
        Mimics the Linux touch command behavior:
        - Creates an empty file if it doesn't exist
        - Updates the timestamp if the file already exists
    .PARAMETER FilePath
        The path of the file to touch
    .EXAMPLE
        touch "myfile.txt"
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [string[]]$FilePath
    )
    
    process {
        foreach ($path in $FilePath) {
            if (Test-Path -Path $path) {
                # File exists - update timestamp only
                (Get-Item -Path $path).LastWriteTime = Get-Date
                Write-Verbose "Updated timestamp: $path"
            }
            else {
                # File doesn't exist - create empty file
                "" | Out-File -FilePath $path -Encoding ASCII
                Write-Verbose "Created file: $path"
            }
        }
    }
}

function Find-Files {
    <#
    .SYNOPSIS
        Recursively finds files matching a name pattern
    .DESCRIPTION
        Searches recursively for files matching the specified pattern
    .PARAMETER Pattern
        The pattern to search for
    .PARAMETER Path
        The path to start searching from (default: current directory)
    .EXAMPLE
        Find-Files "*.txt"
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Pattern,
        
        [Parameter()]
        [string]$Path = "."
    )
    
    Get-ChildItem -Path $Path -Recurse -Filter "*${Pattern}*" -ErrorAction SilentlyContinue | 
    ForEach-Object {
        Write-Output "$($_.FullName)"
    }
}

function Expand-Archive {
    <#
    .SYNOPSIS
        Extracts archive files to the current directory
    .DESCRIPTION
        Extracts the contents of zip, 7z, rar and other archive files
        Uses 7-Zip for non-zip formats if available, falls back to built-in for .zip
    .PARAMETER ArchiveFile
        The path to the archive file
    .PARAMETER DestinationPath
        The destination path (default: current directory)
    .EXAMPLE
        unzip "archive.zip"
    .EXAMPLE
        unzip "archive.7z" "C:\extract\here"
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$ArchiveFile,
        
        [Parameter(Position = 1)]
        [string]$DestinationPath = (Get-Location)
    )
    
    $fullPath = Resolve-Path $ArchiveFile -ErrorAction SilentlyContinue
    if (-not $fullPath) {
        Write-Error "Archive file not found: $ArchiveFile"
        return
    }
    
    Write-Host "Extracting $fullPath to $DestinationPath" -ForegroundColor Cyan
    
    $extension = [System.IO.Path]::GetExtension($fullPath).ToLower()
    $7zipPath = "C:\Program Files\7-Zip\7z.exe"
    
    # Use 7-Zip for non-zip formats or if 7-Zip is available
    if ($extension -ne ".zip" -or (Test-Path $7zipPath)) {
        if (Test-Path $7zipPath) {
            Write-Host "Using 7-Zip" -ForegroundColor DarkCyan
            & $7zipPath x "$fullPath" -o"$DestinationPath" -y
            if ($LASTEXITCODE -ne 0) {
                Write-Error "7-Zip extraction failed with code $LASTEXITCODE"
                
                # Fall back to built-in if it's a zip file
                if ($extension -eq ".zip") {
                    Write-Host "Falling back to built-in Expand-Archive" -ForegroundColor Yellow
                    Microsoft.PowerShell.Archive\Expand-Archive -Path $fullPath -DestinationPath $DestinationPath -Force
                }
            }
        }
        else {
            if ($extension -eq ".zip") {
                Write-Host "Using built-in Expand-Archive" -ForegroundColor DarkCyan
                Microsoft.PowerShell.Archive\Expand-Archive -Path $fullPath -DestinationPath $DestinationPath -Force
            }
            else {
                Write-Error "7-Zip not found at $7zipPath and built-in extractor only supports .zip files."
                Write-Host "Please install 7-Zip to extract $extension files." -ForegroundColor Yellow
            }
        }
    }
    else {
        Write-Host "Using built-in Expand-Archive" -ForegroundColor DarkCyan
        Microsoft.PowerShell.Archive\Expand-Archive -Path $fullPath -DestinationPath $DestinationPath -Force
    }
}

function New-Directory {
    <#
    .SYNOPSIS
        Creates a directory and changes to it
    .DESCRIPTION
        Creates a new directory and changes the current location to it
    .PARAMETER Path
        The path of the directory to create
    .EXAMPLE
        New-Directory "NewProject"
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Path
    )
    
    New-Item -ItemType Directory -Path $Path -Force | Out-Null
    Set-Location -Path $Path
}

#endregion

# Aliases
New-Alias -Name touch -Value New-File -Force -Scope Global
New-Alias -Name ff -Value Find-Files -Force -Scope Global
New-Alias -Name unzip -Value Expand-Archive -Force -Scope Global
New-Alias -Name mkcd -Value New-Directory -Force -Scope Global

# Export functions and aliases
Export-ModuleMember -Function New-File, Find-Files, Expand-Archive, New-Directory
Export-ModuleMember -Alias touch, ff, unzip, mkcd 