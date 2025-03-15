# Module manifest for module 'Productivity'
@{
    # Script module or binary module file associated with this manifest
    RootModule = 'Productivity.psm1'

    # Version number of this module
    ModuleVersion = '1.0.0'

    # ID used to uniquely identify this module
    GUID = 'ff88387a-4b2f-4924-a019-5e19a54b4420'

    # Author of this module
    Author = 'Armin Zou'

    # Description of the functionality provided by this module
    Description = 'Productivity enhancement functions and utilities'

    # Minimum version of the PowerShell engine required by this module
    PowerShellVersion = '7.0'

    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry
    FunctionsToExport = @(
        'Copy-TextToClipboard',
        'Get-ClipboardContent',
        'Set-LocationToDocuments',
        'Set-LocationToDesktop',
        'Show-DirectoryListing',
        'Show-DirectoryListingWithHidden',
        'Submit-TextToHasteBin',
        'Find-String'
    )

    # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry
    CmdletsToExport = @()

    # Variables to export from this module
    VariablesToExport = @()

    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry
    AliasesToExport = @(
        'cpy',
        'pst',
        'docs',
        'dtop',
        'la',
        'll',
        'hb',
        'grep'
    )

    # Private data to pass to the module specified in RootModule/ModuleToProcess
    PrivateData = @{
        PSData = @{
            # Tags applied to this module
            Tags = @('Productivity', 'Utilities', 'Clipboard', 'Navigation')

            # A URL to the license for this module
            LicenseUri = ''

            # A URL to the main website for this project
            ProjectUri = ''
        }
    }
} 