function Invoke-DeployWAR {
  <#
    .SYNOPSIS
    Deploy a WAR

    .DESCRIPTION
    Deploy a web-application resource (WAR) file

    .PARAMETER Path
    The path parameter corresponds to the path to the JBoss client.

    .PARAMETER Controller
    The controller parameter corresponds to the hostname and port of the JBoss host.

    .PARAMETER Credentials
    The optional credentials parameter correspond to the credentials of the account to use to connect to JBoss.

    .PARAMETER Module
    The module parameter corresponds to the name of the JDBC driver module.

    .NOTES
    File name:      Invoke-DeployWAR.ps1
    Author:         Florian Carrier
    Creation date:  19/12/2019
    Last modified:  19/12/2019
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
      Mandatory   = $false,
      HelpMessage = "Path to the WAR file"
    )]
    [ValidateNotNUllOrEmpty ()]
    [String]
    $WAR,
    [Parameter (
      HelpMessage = "Force switch"
    )]
    [Switch]
    $Force
  )
  Begin {
    # Get global preference variables
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    # Check path
    if (-Not (Test-Path -Path $WAR)) {
      Write-Log -Type "ERROR" -Object "Path not found $WAR" -ExitCode 1
    }
    # Web-application
    $WebApp = Split-Path -Path $WAR -Leaf
  }
  Process {
    Write-Log -Type "INFO" -Object "Deploy $WebApp"
    # Define command
    $Command = "deploy ""$WAR"""
    # Execute command
    if ($PSBoundParameters.ContainsKey('Credentials')) {
      $DeployWAR = Invoke-JBossClient -Path $Path -Controller $Controller -Command $Command -Credentials $Credentials -Force:$Force
    } else {
      $DeployWAR = Invoke-JBossClient -Path $Path -Controller $Controller -Command $Command -Force:$Force
    }
    # Check outcome
    Assert-JBossCliCmdOutcome -Log $DeployWAR -Object $WebApp -Verb "deploy"
  }
}
