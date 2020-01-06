function Add-SecurityRole {
  <#
    .SYNOPSIS
    Add security role

    .DESCRIPTION
    Add a new role to the role-based access security system of WildFly

    .PARAMETER Path
    The path parameter corresponds to the path to the JBoss client.

    .PARAMETER Controller
    The controller parameter corresponds to the hostname and port of the JBoss host.

    .PARAMETER Role
    The role parameter corresponds to the name of the role to create.

    .PARAMETER Credentials
    The optional credentials parameter correspond to the credentials of the account to use to connect to JBoss.

    .PARAMETER Redirect
    The redirect parameter is a flag to enable the redirection of errors to the standard output stream.

    .NOTES
    File name:      Add-SecurityRole.ps1
    Author:         Florian Carrier
    Creation date:  21/10/2019
    Last modified:  06/12/2019
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
      Mandatory   = $true,
      HelpMessage = "Name of the role to be created"
    )]
    [ValidateNotNUllOrEmpty ()]
    [String]
    $Role,
    [Parameter (
      Position    = 4,
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
    Write-Log -Type "INFO" -Object "Creating $Role role"
    # TODO check if role already exists
    # Define JBoss client command
    $Command = "/core-service=management/access=authorization/role-mapping=$($Role):add"
    # Execute command
    if ($PSBoundParameters.ContainsKey("Credentials")) {
      $AddRole = Invoke-JBossClient -Path $Path -Controller $Controller -Command $Command -Credentials $Credentials -Redirect
    } else {
      $AddRole = Invoke-JBossClient -Path $Path -Controller $Controller -Command $Command -Redirect
    }
    # Debugging
    Write-Log -Type "DEBUG" -Object $AddRole
    # Check outcome
    Assert-JBossCliCmdOutcome -Log $AddRole -Object "$Role role" -Verb "create"
  }
}
