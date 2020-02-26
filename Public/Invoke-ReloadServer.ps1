function Invoke-ReloadServer {
  <#
    .SYNOPSIS
    Reload web-server

    .DESCRIPTION
    Reload JBoss web-server

    .PARAMETER Path
    The path parameter corresponds to the path to the JBoss client.

    .PARAMETER Controller
    The optional controller parameter corresponds to the hostname and port of the JBoss host.

    .PARAMETER Credentials
    The optional credentials parameter correspond to the credentials of the account to use to connect to JBoss.

    .INPUTS
    None. You cannot pipe objects to Invoke-ReloadServer.

    .OUTPUTS
    System.String. Invoke-ReloadServer returns the raw output from the JBoss client.

    .EXAMPLE
    Invoke-ReloadServer -Path "C:\WildFly\wildfly-11.0.0.Final\bin\jboss-cli.ps1" -Controller "127.0.0.1:9990"

    In this example, Invoke-ReloadServer will reload the server specified by the controller 127.0.0.1:9990.

    .NOTES
    File name:      Invoke-ReloadServer.ps1
    Author:         Florian Carrier
    Creation date:  02/12/2019
    Last modified:  28/01/2020

    .LINK
    Invoke-JBossClient
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
    $Credentials
  )
  Begin {
    # Get global preference variables
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
  }
  Process {
    # Define command
    $Command = ':reload()'
    # Run command
    if ($PSBoundParameters.ContainsKey("Path")) {
      if ($PSBoundParameters.ContainsKey("Controller")) {
        if ($PSBoundParameters.ContainsKey("Credentials")) {
          Invoke-JBossClient -Path $Path -Controller $Controller -Command $Command -Credentials $Credentials
        } else {
          Invoke-JBossClient -Path $Path -Controller $Controller -Command $Command
        }
      } else {
        if ($PSBoundParameters.ContainsKey("Credentials")) {
          Invoke-JBossClient -Path $Path -Command $Command -Credentials $Credentials
        } else {
          Invoke-JBossClient -Path $Path -Command $Command
        }
      }
    } else {
      if ($PSBoundParameters.ContainsKey("Controller")) {
        if ($PSBoundParameters.ContainsKey("Credentials")) {
          Invoke-JBossClient -Controller $Controller -Command $Command -Credentials $Credentials
        } else {
          Invoke-JBossClient -Controller $Controller -Command $Command
        }
      } else {
        if ($PSBoundParameters.ContainsKey("Credentials")) {
          Invoke-JBossClient -Command $Command -Credentials $Credentials
        } else {
          Invoke-JBossClient -Command $Command
        }
      }
    }
  }
}
