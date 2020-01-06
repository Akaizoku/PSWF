function Invoke-UndeployWAR {
  <#
    .SYNOPSIS
    Undeploy a WAR

    .DESCRIPTION
    Undeploy a web-application resource (WAR) file

    .PARAMETER Path
    The path parameter corresponds to the path to the JBoss client.

    .PARAMETER Controller
    The controller parameter corresponds to the hostname and port of the JBoss host.

    .PARAMETER Credentials
    The optional credentials parameter correspond to the credentials of the account to use to connect to JBoss.

    .PARAMETER Module
    The module parameter corresponds to the name of the JDBC driver module.

    .NOTES
    File name:      Invoke-UndeployWAR.ps1
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
      HelpMessage = "Name of the WAR file"
    )]
    [ValidateNotNUllOrEmpty ()]
    [String]
    $WAR
  )
  Begin {
    # Get global preference variables
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
  }
  Process {
    Write-Log -Type "INFO" -Object "Undeploy $WAR"
    # Check if deployment exists
    if ($PSBoundParameters.ContainsKey('Credentials')) {
      $Check = Read-DeploymentStatus -Path $Path -Controller $Controller -WAR $WAR -Credentials $Credentials
    } else {
      $Check = Read-DeploymentStatus -Path $Path -Controller $Controller -WAR $WAR
    }
    if ($Check -eq "MISSING") {
      Write-Log -Type "WARN" -Object """$WAR"" is not deployed"
    } else {
      # Define command
      $Command = "undeploy ""$WAR"""
      # Execute command
      if ($PSBoundParameters.ContainsKey('Credentials')) {
        $UndeployWAR = Invoke-JBossClient -Path $Path -Controller $Controller -Command $Command -Credentials $Credentials
      } else {
        $UndeployWAR = Invoke-JBossClient -Path $Path -Controller $Controller -Command $Command
      }
      # Check outcome
      Assert-JBossCliCmdOutcome -Log $UndeployWAR -Object $WAR -Verb "undeploy"
    }
  }
}
