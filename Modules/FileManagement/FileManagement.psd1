# Module manifest for module 'FileManagement'
@{
    # Script module or binary module file associated with this manifest
    RootModule = 'FileManagement.psm1'

    # Version number of this module
    ModuleVersion = '1.0.0'

    # ID used to uniquely identify this module
    GUID = '5be1a962-f809-4276-91b0-15663614b887'

    # Author of this module
    Author = 'Armin Zou'

    # Description of the functionality provided by this module
    Description = 'File management utilities'

    # Minimum version of the PowerShell engine required by this module
    PowerShellVersion = '7.0'

    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry
    FunctionsToExport = @(
        'New-File',
        'Find-Files',
        'Expand-Archive',
        'New-Directory'
    )

    # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry
    CmdletsToExport = @()

    # Variables to export from this module
    VariablesToExport = @()

    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry
    AliasesToExport = @(
        'touch',
        'ff',
        'unzip',
        'mkcd'
    )

    # Private data to pass to the module specified in RootModule/ModuleToProcess
    PrivateData = @{
        PSData = @{
            # Tags applied to this module
            Tags = @('FileManagement', 'Files', 'Utilities')

            # A URL to the license for this module
            LicenseUri = ''

            # A URL to the main website for this project
            ProjectUri = ''
        }
    }
} 