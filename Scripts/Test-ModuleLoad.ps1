# Test-ModuleLoad.ps1
# Tests if modules load correctly after GUID fixes

$modules = @(
    "FileManagement",
    "GitAliases",
    "NetworkTools",
    "SystemUtilities",
    "Productivity"
)

Write-Host "Testing module loading after GUID fixes..." -ForegroundColor Cyan
Write-Host ""

foreach ($module in $modules) {
    Write-Host "Testing module: $module" -ForegroundColor Yellow
    
    # Remove the module if already loaded
    if (Get-Module -Name $module) {
        Remove-Module -Name $module -Force
        Write-Host "  Removed existing module instance" -ForegroundColor Gray
    }
    
    # Try to import the module
    try {
        Import-Module -Name $module -ErrorAction Stop
        Write-Host "  ✅ Successfully loaded module: $module" -ForegroundColor Green
        
        # List exported functions
        $functions = Get-Command -Module $module -CommandType Function | Select-Object -ExpandProperty Name
        Write-Host "  Functions: $($functions -join ', ')" -ForegroundColor Gray
        
        # List exported aliases
        $aliases = Get-Alias | Where-Object { $_.ModuleName -eq $module } | Select-Object -ExpandProperty Name
        Write-Host "  Aliases: $($aliases -join ', ')" -ForegroundColor Gray
    }
    catch {
        Write-Host "  ❌ Failed to load module: $module" -ForegroundColor Red
        Write-Host "  Error: $_" -ForegroundColor Red
    }
    
    Write-Host ""
}

Write-Host "Module test completed. If all modules loaded successfully, the GUID issues have been fixed." -ForegroundColor Cyan 