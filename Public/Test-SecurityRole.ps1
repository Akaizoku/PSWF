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
    System.String. Test-SecurityRole returns the raw output from the JBoss client.

    .NOTES
    File name:      Test-SecurityRole.ps1
    Author:         Florian Carrier
    Creation date:  07/01/2020
    Last modified:  07/01/2020

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
    Write-Log -Type "DEBUG" -Object "Checking $Role role"
    # Define role resource path
    $Resource = "/core-service=management/access=authorization/role-mapping=$($Role)"
    # Check resource
    if ($PSBoundParameters.ContainsKey("Credentials")) {
      $Outcome = Read-Resource -Path $Path -Controller $Controller -Credentials $Credentials -Resource $Resource
    } else {
      $Outcome = Read-Resource -Path $Path -Controller $Controller -Resource $Resource
    }
    # Parse outcome
    if (Select-String -InputObject $Outcome -Pattern '"outcome" => "success"' -SimpleMatch -Quiet) {
      return $true
    } else {
      return $false
    }
  }
}
