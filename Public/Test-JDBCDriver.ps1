function Test-JDBCDriver {
  <#
    .SYNOPSIS
    Test JDBC driver

    .DESCRIPTION
    Check if a JDBC driver exists on a JBoss web-application server

    .PARAMETER Path
    The path parameter corresponds to the path to the JBoss client.

    .PARAMETER Controller
    The controller parameter corresponds to the hostname and port of the JBoss host.

    .PARAMETER Credentials
    The optional credentials parameter correspond to the credentials of the account to use to connect to JBoss.

    .PARAMETER Driver
    The driver parameter corresponds to the name of the JDBC driver to check.

    .INPUTS
    System.String. You can pipe the driver name to Test-JDBCDriver.

    .OUTPUTS
    Boolean. Test-JDBCDriver returns a boolean depending if the JDBC driver exists.

    .NOTES
    File name:      Test-JDBCDriver.ps1
    Author:         Florian Carrier
    Creation date:  15/01/2020
    Last modified:  15/01/2020

    .LINK
    Invoke-JBossClient

    .LINK
    Add-JDBCDriver

    .LINK
    Remove-JDBCDriver
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
      HelpMessage = "Name of the JDBC driver to check",
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
  }
  Process {
    # Define resource
    $Resource = "/subsystem=datasources/jdbc-driver=\""$Driver\"""
    # Check resource
    if ($PSBoundParameters.ContainsKey("Credentials")) {
      Test-Resource -Path $Path -Controller $Controller -Resource $Resource -Credentials $Credentials
    } else {
      Test-Resource -Path $Path -Controller $Controller -Resource $Resource
    }
  }
}
