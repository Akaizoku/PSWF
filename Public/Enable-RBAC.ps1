function Enable-RBAC {
  <#
    .SYNOPSIS
    Enable RBAC

    .DESCRIPTION
    Configure role-based access control security model for WildFly

    .PARAMETER Path
    The path parameter corresponds to the path to the JBoss client.

    .PARAMETER Controller
    The controller parameter corresponds to the hostname and port of the JBoss host.

    .NOTES
    File name:      Enable-RBAC.ps1
    Author:         Florian Carrier
    Creation date:  18/10/2019
    Last modified:  17/12/2019
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
    Write-Log -Type "INFO" -Object "Enabling role-based access control security model"
    # TODO
    $Command = '/core-service=management/access=authorization:write-attribute(name=provider,value=rbac)'
    # Execute command
    if ($PSBoundParameters.ContainsKey("Credentials")) {
      $RBACSetup = Invoke-JBossClient -Path $Path -Controller $Controller -Command $Command -Credentials $Credentials -Redirect
    } else {
      $RBACSetup = Invoke-JBossClient -Path $Path -Controller $Controller -Command $Command -Redirect
    }
    # Debugging
    Write-Log -Type "DEBUG" -Object $RBACSetup
    # Check outcome
    Assert-JBossCliCmdOutcome -Log $RBACSetup -Object "RBAC security model" -Verb "enable"
  }
}
