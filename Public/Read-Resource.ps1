function Read-Resource {
  <#
    .SYNOPSIS
    Read resource

    .DESCRIPTION
    Check if a resource exists

    .PARAMETER Path
    The path parameter corresponds to the path to the JBoss batch client.

    .PARAMETER Controller
    The controller parameter corresponds to the host to connect to.

    .PARAMETER Credentials
    The optional credentials parameter correspond to the credentials of the account to use to connect to JBoss.

    .PARAMETER Resource
    The resource parameter corresponds to the path to the resource

    .NOTES
    File name:      Read-Resource.ps1
    Author:         Florian Carrier
    Creation date:  20/12/2019
    Last modified:  20/12/2019
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
      HelpMessage = "Path to the resource"
    )]
    [ValidateNotNUllOrEmpty ()]
    [String]
    $Resource
  )
  Begin {
    # Get global preference variables
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
  }
  Process {
    Write-Log -Type "DEBUG" -Object "Check $Resource resource"
    # Define command
    $Command = "$($Resource):read-resource()"
    # Execute command
    if ($PSBoundParameters.ContainsKey('Credentials')) {
      $ReadResource = Invoke-JBossClient -Path $Path -Controller $Controller -Command $Command -Credentials $Credentials
    } else {
      $ReadResource = Invoke-JBossClient -Path $Path -Controller $Controller -Command $Command
    }
    # Check outcome
    Assert-JBossCliCmdOutcome -Log $ReadResource -Object "$Resource resource" -Verb "exist" -Quiet
  }
}
