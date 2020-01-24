function Test-SecurityRole {
  <#
    .SYNOPSIS
    Test security role

    .DESCRIPTION
    Check if a security role exists on a JBoss web-application server

    .PARAMETER Path
    The path parameter corresponds to the path to the JBoss client.

    .PARAMETER Controller
    The controller parameter corresponds to the hostname and port of the JBoss host.

    .PARAMETER Credentials
    The optional credentials parameter correspond to the credentials of the account to use to connect to JBoss.

    .PARAMETER Role
    The role parameter corresponds to the name of the role to check.

    .INPUTS
    System.String. You can pipe the role name to Test-SecurityRole.

    .OUTPUTS
    Boolean. Test-SecurityRole returns a boolean depnding if the security role exists.

    .NOTES
    File name:      Test-SecurityRole.ps1
    Author:         Florian Carrier
    Creation date:  07/01/2020
    Last modified:  15/01/2020

    .LINK
    Invoke-JBossClient

    .LINK
    Add-SecurityRole

    .LINK
    Remove-SecurityRole
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
      HelpMessage = "Name of the role to be created",
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
    # Check resource
    if ($PSBoundParameters.ContainsKey("Credentials")) {
      Test-Resource -Path $Path -Controller $Controller -Resource $Resource -Credentials $Credentials
    } else {
      Test-Resource -Path $Path -Controller $Controller -Resource $Resource
    }
  }
}
