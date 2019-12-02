function Grant-SecurityRole {
  <#
    .SYNOPSIS
    Grant role to user group

    .DESCRIPTION
    Grant a specified application security role to a specified user group

    .PARAMETER Properties
    The properties parameter corresponds to the environment properties.

    .PARAMETER Role
    The role parameter corresponds to the name of the security role to be granted.

    .PARAMETER UserGroup
    The user group parameneter corresponds to the name of the user group to be affected.

    .NOTES
    File name:      Grant-SecurityRole.ps1
    Author:         Florian Carrier
    Creation date:  21/10/2019
    Last modified:  21/10/2019
  #>
  [CmdletBinding (
    SupportsShouldProcess = $true
  )]
  Param (
    [Parameter (
      Position    = 1,
      Mandatory   = $true,
      HelpMessage = "List of properties"
    )]
    [ValidateNotNullOrEmpty ()]
    [System.Collections.Specialized.OrderedDictionary]
    $Properties,
    [Parameter (
      Position    = 3,
      Mandatory   = $true,
      HelpMessage = "Name of the role"
    )]
    [ValidateNotNullOrEmpty ()]
    [String]
    $Role,
    [Parameter (
      Position    = 3,
      Mandatory   = $true,
      HelpMessage = "Name of the user group"
    )]
    [ValidateNotNullOrEmpty ()]
    [String]
    $UserGroup
  )
  Begin {
    # Get global preference variables
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
  }
  Process {
    Write-Log -Type "INFO" -Object "Grant $Role role to user group $UserGroup"
    # Define command
    $Command = "/core-service=management/access=authorization/role-mapping=$Role/include=group-$($UserGroup):add(name=$UserGroup,type=GROUP)"
    # Execute command
    $GrantRole = Invoke-JBossCli -Properties $Properties -Command $Command -Redirect
    Test-JBossCliCmd -Log $GrantRole -Object "$Role role" -Verb "grant"
  }
}
