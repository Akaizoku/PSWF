function Read-ServerState {
  <#
    .SYNOPSIS
    Get web-server status

    .DESCRIPTION
    Get the status of a JBoss web-application server

    .PARAMETER Path
    The optional path parameter corresponds to the path to the JBoss batch client.

    .PARAMETER Controller
    The controller parameter corresponds to the host to connect to.

    .PARAMETER Credentials
    The optional credentials parameter correspond to the credentials of the account to use to connect to JBoss.

    .INPUTS
    None. You cannot pipe objects to Read-ServerState.

    .OUTPUTS
    System.String. Read-ServerState returns the raw output from the JBoss client.

    .EXAMPLE
    Read-ServerState -Path "C:\WildFly\bin\jboss-cli.ps1" -Controller "127.0.0.1:9990"

    In this example, Read-ServerState will query the state of the server specified by the controller 127.0.0.1:9990.

    .EXAMPLE
    $Credentials = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList ("admin", (ConvertTo-SecureString -String "password" -AsPlainText -Force))
    Read-ServerState -Path "C:\WildFly\bin\jboss-cli.ps1" -Controller "127.0.0.1:9990" -Credentials $Credentials

    In this example, Read-ServerState will query the state of the server specified by the controller 127.0.0.1:9990 using the provided admin user credentials.

    .NOTES
    File name:      Read-ServerState.ps1
    Author:         Florian Carrier
    Creation date:  01/12/2019
    Last modified:  10/01/2020

    .LINK
    Invoke-JBossClient
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
    # Define command
    $Command = ':read-attribute(name=server-state)'
    # Execute command
    if ($PSBoundParameters.ContainsKey('Credentials')) {
      Invoke-JBossClient -Path $Path -Controller $Controller -Command $Command -Credentials $Credentials -Redirect
    } else {
      Invoke-JBossClient -Path $Path -Controller $Controller -Command $Command -Redirect
    }
  }
}
