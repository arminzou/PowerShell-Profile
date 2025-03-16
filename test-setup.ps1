# Test script for verifying PowerShell profile setup
Write-Host "===== PowerShell Profile Setup Test =====" -ForegroundColor Cyan

# Initialize test results
$testResults = @{}

# Function to update test results
function Update-TestResult {
    param (
        [string]$Component,
        [bool]$Success,
        [string]$Details = ""
    )
    
    $testResults[$Component] = $Success
    
    if ($Success) {
        Write-Host "  [PASS] $Component" -ForegroundColor Green
        if ($Details) {
            Write-Host "     $Details" -ForegroundColor Gray
        }
    } else {
        Write-Host "  [FAIL] $Component" -ForegroundColor Red
        if ($Details) {
            Write-Host "     $Details" -ForegroundColor Gray
        }
    }
}

# Test 1: PowerShell Profile
Write-Host "`nTesting PowerShell Profile..." -ForegroundColor Yellow
try {
    $profileExists = Test-Path -Path $PROFILE -PathType Leaf
    if ($profileExists) {
        $profileContent = Get-Content -Path $PROFILE -Raw
        $hasOhMyPoshImport = $profileContent -match "oh-my-posh"
        
        if ($hasOhMyPoshImport) {
            Update-TestResult -Component "PowerShell Profile" -Success $true -Details "Profile exists and contains Oh My Posh configuration"
        } else {
            Update-TestResult -Component "PowerShell Profile" -Success $true -Details "Profile exists but may not have Oh My Posh configuration"
        }
    } else {
        Update-TestResult -Component "PowerShell Profile" -Success $false -Details "Profile file does not exist at $PROFILE"
    }
} catch {
    Update-TestResult -Component "PowerShell Profile" -Success $false -Details "Error: $_"
}

# Test 2: Oh My Posh
Write-Host "`nTesting Oh My Posh installation..." -ForegroundColor Yellow
try {
    $ompCommand = Get-Command oh-my-posh -ErrorAction SilentlyContinue
    if ($ompCommand) {
        $ompVersion = & oh-my-posh --version
        Update-TestResult -Component "Oh My Posh" -Success $true -Details "Version: $ompVersion"
    } else {
        # Try checking with winget as fallback
        $wingetResult = winget list --name "OhMyPosh" -e
        if ($wingetResult -match "Oh My Posh") {
            Update-TestResult -Component "Oh My Posh" -Success $true -Details "Installed according to winget"
        } else {
            Update-TestResult -Component "Oh My Posh" -Success $false -Details "Not found in PATH or winget"
        }
    }
} catch {
    Update-TestResult -Component "Oh My Posh" -Success $false -Details "Error: $_"
}

# Test 3: Nerd Font
Write-Host "`nTesting Nerd Font installation..." -ForegroundColor Yellow
try {
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
    $fontFamilies = (New-Object System.Drawing.Text.InstalledFontCollection).Families.Name
    if ($fontFamilies -contains "CaskaydiaCove NF") {
        Update-TestResult -Component "Nerd Font" -Success $true -Details "CaskaydiaCove NF is installed"
    } else {
        Update-TestResult -Component "Nerd Font" -Success $false -Details "CaskaydiaCove NF is not installed"
    }
} catch {
    Update-TestResult -Component "Nerd Font" -Success $false -Details "Error: $_"
}

# Test 4: Chocolatey
Write-Host "`nTesting Chocolatey installation..." -ForegroundColor Yellow
try {
    $chocoCommand = Get-Command choco -ErrorAction SilentlyContinue
    if ($chocoCommand) {
        $chocoVersion = & choco --version
        Update-TestResult -Component "Chocolatey" -Success $true -Details "Version: $chocoVersion"
    } else {
        Update-TestResult -Component "Chocolatey" -Success $false -Details "Not found in PATH"
    }
} catch {
    Update-TestResult -Component "Chocolatey" -Success $false -Details "Error: $_"
}

# Test 5: Terminal-Icons
Write-Host "`nTesting Terminal-Icons installation..." -ForegroundColor Yellow
try {
    $terminalIconsModule = Get-Module -ListAvailable -Name Terminal-Icons
    if ($terminalIconsModule) {
        $version = $terminalIconsModule.Version.ToString()
        Update-TestResult -Component "Terminal-Icons" -Success $true -Details "Version: $version"
        
        # Test if it can be imported
        Import-Module Terminal-Icons -ErrorAction Stop
        Write-Host "     Module imported successfully" -ForegroundColor Gray
    } else {
        Update-TestResult -Component "Terminal-Icons" -Success $false -Details "Module not found"
    }
} catch {
    Update-TestResult -Component "Terminal-Icons" -Success $false -Details "Error: $_"
}

# Test 6: zoxide
Write-Host "`nTesting zoxide installation..." -ForegroundColor Yellow
try {
    $zoxideCommand = Get-Command zoxide -ErrorAction SilentlyContinue
    if ($zoxideCommand) {
        $zoxideVersion = & zoxide --version
        Update-TestResult -Component "zoxide" -Success $true -Details "Version: $zoxideVersion"
    } else {
        # Try checking with winget as fallback
        $wingetResult = winget list --id ajeetdsouza.zoxide
        if ($wingetResult -match "zoxide") {
            Update-TestResult -Component "zoxide" -Success $true -Details "Installed according to winget"
        } else {
            Update-TestResult -Component "zoxide" -Success $false -Details "Not found in PATH or winget"
        }
    }
} catch {
    Update-TestResult -Component "zoxide" -Success $false -Details "Error: $_"
}

# Calculate overall success
$passedTests = ($testResults.Values | Where-Object { $_ -eq $true }).Count
$totalTests = $testResults.Count
Write-Host "`nPassed $passedTests out of $totalTests tests" -ForegroundColor Cyan

# Provide recommendations for failed tests
Write-Host "`n===== Recommendations for Failed Tests =====" -ForegroundColor Yellow
foreach ($component in $testResults.Keys) {
    if ($testResults[$component] -eq $false) {
        Write-Host "Component: $component" -ForegroundColor Red
        switch ($component) {
            "PowerShell Profile" {
                Write-Host "  - Run the setup script again to create the PowerShell profile" -ForegroundColor Yellow
            }
            "Oh My Posh" {
                Write-Host "  - Install Oh My Posh manually: winget install JanDeDobbeleer.OhMyPosh -e" -ForegroundColor Yellow
            }
            "Nerd Font" {
                Write-Host "  - Download and install CaskaydiaCove NF font manually from https://www.nerdfonts.com/font-downloads" -ForegroundColor Yellow
            }
            "Chocolatey" {
                Write-Host "  - Install Chocolatey manually using the command in setup.ps1" -ForegroundColor Yellow
            }
            "Terminal-Icons" {
                Write-Host "  - Install Terminal-Icons manually: Install-Module -Name Terminal-Icons -Repository PSGallery -Force -Scope CurrentUser" -ForegroundColor Yellow
            }
            "zoxide" {
                Write-Host "  - Install zoxide manually: winget install -e --id ajeetdsouza.zoxide" -ForegroundColor Yellow
            }
        }
    }
}

Write-Host "`n===== End of Test =====" -ForegroundColor Cyan