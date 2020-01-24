function Test-DataSourceConnection {
  <#
    .SYNOPSIS
    Test data-source connection

    .DESCRIPTION
    Check if a data-source connection pool is working on a JBoss web-application server

    .PARAMETER Path
    The path parameter corresponds to the path to the JBoss client.

    .PARAMETER Controller
    The controller parameter corresponds to the hostname and port of the JBoss host.

    .PARAMETER Credentials
    The optional credentials parameter correspond to the credentials of the account to use to connect to JBoss.

    .PARAMETER DataSource
    The data-source parameter corresponds to the name of the data-source connection to check.

    .INPUTS
    System.String. You can pipe the data-source name to Test-DataSourceConnection.

    .OUTPUTS
    Boolean. Test-DataSourceConnection returns a boolean depending if the data-source exists.

    .NOTES
    File name:      Test-DataSourceConnection.ps1
    Author:         Florian Carrier
    Creation date:  20/01/2020
    Last modified:  22/01/2020

    .LINK
    Invoke-JBossClient

    .LINK
    Add-DataSource

    .LINK
    Remove-DataSource
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
      HelpMessage = "Name of the data-source connection to test",
      ValueFromPipeline               = $true,
      ValueFromPipelineByPropertyName = $true
    )]
    [ValidateNotNUllOrEmpty ()]
    [Alias ("Name")]
    [String]
    $DataSource
  )
  Begin {
    # Get global preference variables
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
  }
  Process {
    # Define resource
    $Command = "/subsystem=datasources/data-source=\""$DataSource\"":test-connection-in-pool()"
    # Check resource
    if ($PSBoundParameters.ContainsKey("Credentials")) {
      Invoke-JBossClient -Path $Path -Controller $Controller -Command $Command -Credentials $Credentials
    } else {
      Invoke-JBossClient -Path $Path -Controller $Controller -Command $Command
    }
  }
}
