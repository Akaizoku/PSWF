function Grant-SecurityRole {
  <#
    .SYNOPSIS
    Grant role to user group

    .DESCRIPTION
    Grant a specified application security role to a specified user group

    .PARAMETER Path
    The path parameter corresponds to the path to the JBoss client.

    .PARAMETER Hostname
    The hostname parameter corresponds to the name of the JBoss host.

    .PARAMETER Port
    The port parameter corresponds to the port of the management console.

    .PARAMETER Role
    The role parameter corresponds to the name of the security role to be granted.

    .PARAMETER UserGroup
    The user group parameneter corresponds to the name of the user group to be affected.

    .NOTES
    File name:      Grant-SecurityRole.ps1
    Author:         Florian Carrier
    Creation date:  21/10/2019
    Last modified:  13/12/2019
  #>
  [CmdletBinding (
    SupportsShouldProcess = $true
  )]
  Param (
    [Parameter (
      Position    = 1,
      Mandatory   = $true,
      HelpMessage = "Path to the JBoss client"
    )]
    [ValidateNotNUllOrEmpty ()]
    [String]
    $Path,
    [Parameter (
      Position    = 2,
      Mandatory   = $false,
      HelpMessage = "Controller"
    )]
    # TODO validate format
    [ValidateNotNUllOrEmpty ()]
    [String]
    $Controller,
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
    $GrantRole = Invoke-JBossClient -Path $Path -Controller $Controller -Command $Command -Redirect
    Assert-JBossCliCmdOutcome -Log $GrantRole -Object "$Role role" -Verb "grant"
  }
}
