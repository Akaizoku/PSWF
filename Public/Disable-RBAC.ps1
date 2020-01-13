function Disable-RBAC {
  <#
    .SYNOPSIS
    Disable RBAC

    .DESCRIPTION
    Disable role-based access control security model for A JBoss instance

    .PARAMETER Path
    The path parameter corresponds to the path to the JBoss client.

    .PARAMETER Controller
    The controller parameter corresponds to the hostname and port of the JBoss host.

    .PARAMETER Credentials
    The optional credentials parameter correspond to the credentials of the account to use to connect to JBoss.

    .INPUTS
    None. You cannot pipe objects to Remove-UserGroupRole.

    .OUTPUTS
    System.String. Disable-RBAC returns the raw output from the JBoss client.

    .NOTES
    File name:      Disable-RBAC.ps1
    Author:         Florian Carrier
    Creation date:  17/12/2019
    Last modified:  10/01/2020

    .LINK
    Invoke-JBossClient

    .LINK
    Enable-RBAC
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
    $Credentials
  )
  Begin {
    # Get global preference variables
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
  }
  Process {
    # Restore standard security model
    $Command = '/core-service=management/access=authorization:write-attribute(name=provider,value=simple)'
    # Execute command
    if ($PSBoundParameters.ContainsKey("Credentials")) {
      Invoke-JBossClient -Path $Path -Controller $Controller -Command $Command -Credentials $Credentials -Redirect
    } else {
      Invoke-JBossClient -Path $Path -Controller $Controller -Command $Command -Redirect
    }
  }
}
