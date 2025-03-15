# GitAliases.psm1
# Git-related functions and shortcuts

# Define any module-level variables here
$script:moduleRoot = $PSScriptRoot

#region Public Functions

function Get-GitStatus {
    <#
    .SYNOPSIS
        Shows the git repository status
    .DESCRIPTION
        Runs git status in the current directory
    .EXAMPLE
        Get-GitStatus
    #>
    [CmdletBinding()]
    param()
    
    git status
}

function Add-GitChanges {
    <#
    .SYNOPSIS
        Adds all changes to git staging
    .DESCRIPTION
        Runs git add . to stage all changes
    .EXAMPLE
        Add-GitChanges
    #>
    [CmdletBinding()]
    param()
    
    git add .
}

function New-GitCommit {
    <#
    .SYNOPSIS
        Creates a new git commit with a message
    .DESCRIPTION
        Commits staged changes with the specified message
    .PARAMETER Message
        The commit message
    .EXAMPLE
        New-GitCommit -Message "Fixed bug in login screen"
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Message
    )
    
    git commit -m "$Message"
}

function Push-GitChanges {
    <#
    .SYNOPSIS
        Pushes local commits to the remote repository
    .DESCRIPTION
        Runs git push to send commits to the remote repository
    .EXAMPLE
        Push-GitChanges
    #>
    [CmdletBinding()]
    param()
    
    git push
}

function New-GitRepository {
    <#
    .SYNOPSIS
        Clones a git repository
    .DESCRIPTION
        Clones a git repository from the specified URL
    .PARAMETER RepositoryUrl
        The URL of the repository to clone
    .EXAMPLE
        New-GitRepository "https://github.com/user/repo.git"
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$RepositoryUrl
    )
    
    git clone "$RepositoryUrl"
}

function Set-GitHubDirectory {
    <#
    .SYNOPSIS
        Changes to the GitHub directory
    .DESCRIPTION
        Uses zoxide to navigate to the github directory
    .EXAMPLE
        Set-GitHubDirectory
    #>
    [CmdletBinding()]
    param()
    
    __zoxide_z github
}

function Submit-GitChanges {
    <#
    .SYNOPSIS
        Stages changes and commits them in one step
    .DESCRIPTION
        Adds all changes to git staging and commits with the specified message
    .PARAMETER Message
        The commit message
    .EXAMPLE
        Submit-GitChanges -Message "Updated README"
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Message
    )
    
    git add .
    git commit -m "$Message"
}

function Complete-GitWorkflow {
    <#
    .SYNOPSIS
        Performs a complete git workflow - add, commit, and push
    .DESCRIPTION
        Stages all changes, commits with the specified message, and pushes to remote
    .PARAMETER Message
        The commit message
    .EXAMPLE
        Complete-GitWorkflow -Message "Implemented new feature"
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Message
    )
    
    git add .
    git commit -m "$Message"
    git push
}

#endregion

# Aliases
New-Alias -Name gs -Value Get-GitStatus -Force -Scope Global
New-Alias -Name ga -Value Add-GitChanges -Force -Scope Global
New-Alias -Name gc -Value New-GitCommit -Force -Scope Global
New-Alias -Name gp -Value Push-GitChanges -Force -Scope Global
New-Alias -Name g -Value Set-GitHubDirectory -Force -Scope Global
New-Alias -Name gcl -Value New-GitRepository -Force -Scope Global
New-Alias -Name gcom -Value Submit-GitChanges -Force -Scope Global
New-Alias -Name lazyg -Value Complete-GitWorkflow -Force -Scope Global

# Export functions and aliases
Export-ModuleMember -Function Get-GitStatus, Add-GitChanges, New-GitCommit, Push-GitChanges, 
                   New-GitRepository, Set-GitHubDirectory, Submit-GitChanges, Complete-GitWorkflow
Export-ModuleMember -Alias gs, ga, gc, gp, g, gcl, gcom, lazyg 