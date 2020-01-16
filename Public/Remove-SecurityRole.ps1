function Remove-SecurityRole {
  <#
    .SYNOPSIS
    Remove security role

    .DESCRIPTION
    Remove a new role to the role-based access security system of WildFly

    .PARAMETER Path
    The path parameter corresponds to the path to the JBoss client.

    .PARAMETER Controller
    The controller parameter corresponds to the hostname and port of the JBoss host.

    .PARAMETER Credentials
    The optional credentials parameter correspond to the credentials of the account to use to connect to JBoss.

    .PARAMETER Role
    The role parameter corresponds to the name of the role to remove.

    .INPUTS
    System.String. You can pipe the role name to Remove-SecurityRole.

    .OUTPUTS
    System.String. Remove-SecurityRole returns the raw output from the JBoss client.

    .NOTES
    File name:      Remove-SecurityRole.ps1
    Author:         Florian Carrier
    Creation date:  07/01/2020
    Last modified:  16/01/2020

    .LINK
    Remove-Resource

    .LINK
    Add-SecurityRole

    .LINK
    Test-SecurityRole
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
      Mandatory   = $true,
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
      HelpMessage = "Name of the role to be removed",
      ValueFromPipeline               = $true,
      ValueFromPipelineByPropertyName = $true
    )]
    [ValidateNotNUllOrEmpty ()]
    [String]
    $Role
  )
  Begin {
    # Get global preference variables
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
  }
  Process {
    # Define resource
    $Resource = "/core-service=management/access=authorization/role-mapping=$($Role)"
    # Remove resource
    if ($PSBoundParameters.ContainsKey("Credentials")) {
      Remove-Resource -Path $Path -Controller $Controller -Resource $Resource -Credentials $Credentials
    } else {
      Remove-Resource -Path $Path -Controller $Controller -Resource $Resource
    }
  }
}
