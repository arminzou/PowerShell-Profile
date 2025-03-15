# Module manifest for module 'GitAliases'
@{
    # Script module or binary module file associated with this manifest
    RootModule = 'GitAliases.psm1'

    # Version number of this module
    ModuleVersion = '1.0.0'

    # ID used to uniquely identify this module
    GUID = '4d12008c-8003-44c8-ba7a-236071bed2df'

    # Author of this module
    Author = 'Armin Zou'

    # Description of the functionality provided by this module
    Description = 'Git-related functions and shortcuts'

    # Minimum version of the PowerShell engine required by this module
    PowerShellVersion = '7.0'

    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry
    FunctionsToExport = @(
        'Get-GitStatus',
        'Add-GitChanges',
        'New-GitCommit',
        'Push-GitChanges',
        'New-GitRepository',
        'Set-GitHubDirectory',
        'Submit-GitChanges',
        'Complete-GitWorkflow'
    )

    # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry
    CmdletsToExport = @()

    # Variables to export from this module
    VariablesToExport = @()

    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry
    AliasesToExport = @(
        'gs',
        'ga',
        'gc',
        'gp',
        'g',
        'gcl',
        'gcom',
        'lazyg'
    )

    # Private data to pass to the module specified in RootModule/ModuleToProcess
    PrivateData = @{
        PSData = @{
            # Tags applied to this module
            Tags = @('Git', 'GitHub', 'Version Control')

            # A URL to the license for this module
            LicenseUri = ''

            # A URL to the main website for this project
            ProjectUri = ''
        }
    }
} 