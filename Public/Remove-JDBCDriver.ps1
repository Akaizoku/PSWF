function Remove-JDBCDriver {
  <#
    .SYNOPSIS
    Remove JDBC driver

    .DESCRIPTION
    Remove a JDBC driver from a JBoss web-application server

    .PARAMETER Path
    The path parameter corresponds to the path to the JBoss client.

    .PARAMETER Controller
    The controller parameter corresponds to the hostname and port of the JBoss host.

    .PARAMETER Credentials
    The optional credentials parameter correspond to the credentials of the account to use to connect to JBoss.

    .PARAMETER Driver
    The driver parameter corresponds to the name of the JDBC driver to add.

    .INPUTS
    System.String. You can pipe the driver name to Remove-JDBCDriver.

    .OUTPUTS
    System.String. Add-JDBCDriver returns the raw output from the JBoss client.

    .NOTES
    File name:      Remove-JDBCDriver.ps1
    Author:         Florian Carrier
    Creation date:  20/12/2019
    Last modified:  06/01/2020

    .LINK
    Invoke-JBossClient

    .LINK
    Add-JDBCDriver
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
      HelpMessage = "Name of the JDBC driver to remove",
      ValueFromPipeline               = $true,
      ValueFromPipelineByPropertyName = $true
    )]
    [ValidateNotNUllOrEmpty ()]
    [String]
    $Driver
  )
  Begin {
    # Get global preference variables
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    # Resource
    $Resource = "/subsystem=datasources/jdbc-driver=""$Driver"""
  }
  Process {
    Write-Log -Type "DEBUG" -Object "Removing $Driver JDBC driver"
    # Define JBoss client command
    $RemoveCommand = "$($Resource):remove()"
    # Execute command
    if ($PSBoundParameters.ContainsKey("Credentials")) {
      $RemoveJDBCDriver = Invoke-JBossClient -Path $Path -Controller $Controller -Command $RemoveCommand -Credentials $Credentials
    } else {
      $RemoveJDBCDriver = Invoke-JBossClient -Path $Path -Controller $Controller -Command $RemoveCommand
    }
  }
}
