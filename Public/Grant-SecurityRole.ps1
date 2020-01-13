function Grant-SecurityRole {
  <#
    .SYNOPSIS
    Grant role to user group

    .DESCRIPTION
    Grant a specified application security role to a specified user group

    .PARAMETER Path
    The path parameter corresponds to the path to the JBoss client.

    .PARAMETER Controller
    The controller parameter corresponds to the hostname and port of the JBoss host.

    .PARAMETER Role
    The role parameter corresponds to the name of the security role to be granted.

    .PARAMETER UserGroup
    The user group parameneter corresponds to the name of the user group to be affected.

    .NOTES
    File name:      Grant-SecurityRole.ps1
    Author:         Florian Carrier
    Creation date:  21/10/2019
    Last modified:  09/01/2020
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
      Mandatory   = $false,
      HelpMessage = "JBoss client user credentials",
      ValueFromPipeline               = $true,
      ValueFromPipelineByPropertyName = $true
    )]
    [ValidateNotNullOrEmpty ()]
    [System.Management.Automation.PSCredential]
    $Credentials,
    [Parameter (
      Position    = 4,
      Mandatory   = $true,
      HelpMessage = "Name of the role",
      ValueFromPipeline               = $true,
      ValueFromPipelineByPropertyName = $true
    )]
    [ValidateNotNullOrEmpty ()]
    [String]
    $Role,
    [Parameter (
      Position    = 5,
      Mandatory   = $true,
      HelpMessage = "Name of the user group",
      ValueFromPipeline               = $true,
      ValueFromPipelineByPropertyName = $true
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
    # Define command
    $Command = "/core-service=management/access=authorization/role-mapping=$Role/include=group-$($UserGroup):add(name=$UserGroup,type=GROUP)"
    # Execute command
    if ($PSBoundParameters.ContainsKey("Credentials")) {
      Invoke-JBossClient -Path $Path -Controller $Controller -Command $Command -Credentials $Credentials
    } else {
      Invoke-JBossClient -Path $Path -Controller $Controller -Command $Command
    }
  }
}
