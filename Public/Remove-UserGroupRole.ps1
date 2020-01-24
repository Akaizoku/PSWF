function Remove-UserGroupRole {
  <#
    .SYNOPSIS
    Remove user group from security role

    .DESCRIPTION
    Remove a user group from a specifed security role of a JBoss instance

    .PARAMETER Path
    The path parameter corresponds to the path to the JBoss client.

    .PARAMETER Controller
    The controller parameter corresponds to the hostname and port of the JBoss host.

    .PARAMETER Credentials
    The optional credentials parameter correspond to the credentials of the account to use to connect to JBoss.

    .PARAMETER UserGroup
    The user group parameter corresponds to the name of the user group to remove from the role.

    .PARAMETER Role
    The role parameter corresponds to the name of the role to update.

    .INPUTS
    System.String. You can pipe the role name to Remove-UserGroupRole.

    .OUTPUTS
    System.String. Remove-UserGroupRole returns the raw output from the JBoss client.

    .NOTES
    File name:      Remove-UserGroupRole.ps1
    Author:         Florian Carrier
    Creation date:  07/01/2020
    Last modified:  16/01/2020

    .LINK
    Remove-Resource

    .LINK
    Add-UserGroupRole

    .LINK
    Test-UserGroupRole
  #>
  [CmdletBinding (
    SupportsShouldProcess = $true
  )]
  Param (
    [Parameter (
      Position    = 1,
      Mandatory   = $false,
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
      HelpMessage = "User credentials"
    )]
    [ValidateNotNUllOrEmpty ()]
    [System.Management.Automation.PSCredential]
    $Credentials,
    [Parameter (
      Position    = 4,
      Mandatory   = $true,
      HelpMessage = "Name of the user group to remove to the role",
      ValueFromPipeline               = $true,
      ValueFromPipelineByPropertyName = $true
    )]
    [ValidateNotNUllOrEmpty ()]
    [String]
    $UserGroup,
    [Parameter (
      Position    = 5,
      Mandatory   = $true,
      HelpMessage = "Name of the role to be assigned",
      ValueFromPipeline               = $true,
      ValueFromPipelineByPropertyName = $true
    )]
    [ValidateNotNUllOrEmpty ()]
    [String]
    $Role,
    [Parameter (
      Position    = 6,
      Mandatory   = $true,
      HelpMessage = "Name of the realm"
    )]
    [ValidateNotNUllOrEmpty ()]
    [String]
    $Realm
  )
  Begin {
    # Get global preference variables
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
  }
  Process {
    # Define resource
    $Resource = "/core-service=management/access=authorization/role-mapping=$($Role)/include=group-$($UserGroup)"
    # Remove resource
    if ($PSBoundParameters.ContainsKey("Credentials")) {
      Remove-Resource -Path $Path -Controller $Controller -Resource $Resource -Credentials $Credentials
    } else {
      Remove-Resource -Path $Path -Controller $Controller -Resource $Resource
    }
  }
}
