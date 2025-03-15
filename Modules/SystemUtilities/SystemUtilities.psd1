# Module manifest for module 'SystemUtilities'
@{
    # Script module or binary module file associated with this manifest
    RootModule = 'SystemUtilities.psm1'

    # Version number of this module
    ModuleVersion = '1.0.0'

    # ID used to uniquely identify this module
    GUID = '1c5bf475-a19a-4946-a387-e48b65c7be4d'

    # Author of this module
    Author = 'Armin Zou'

    # Description of the functionality provided by this module
    Description = 'System management and utility functions'

    # Minimum version of the PowerShell engine required by this module
    PowerShellVersion = '7.0'

    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry
    FunctionsToExport = @(
        'Update-PowerShellCore',
        'Clear-SystemCache',
        'Get-SystemUptime',
        'Start-AdminSession',
        'Get-ComputerInformation',
        'Stop-ProcessByName',
        'Move-ToRecycleBin',
        'Get-VolumeInformation'
    )

    # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry
    CmdletsToExport = @()

    # Variables to export from this module
    VariablesToExport = @()

    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry
    AliasesToExport = @(
        'Update-PowerShell',
        'Clear-Cache',
        'uptime',
        'admin',
        'su',
        'sysinfo',
        'k9',
        'trash',
        'df'
    )

    # Private data to pass to the module specified in RootModule/ModuleToProcess
    PrivateData = @{
        PSData = @{
            # Tags applied to this module
            Tags = @('System', 'Utilities', 'Management', 'Admin')

            # A URL to the license for this module
            LicenseUri = ''

            # A URL to the main website for this project
            ProjectUri = ''
        }
    }
} 