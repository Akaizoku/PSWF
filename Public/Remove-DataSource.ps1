function Remove-DataSource {
  <#
    .SYNOPSIS
    Remove data-source

    .DESCRIPTION
    Remove a data-source from JBoss web-application server

    .PARAMETER Path
    The path parameter corresponds to the path to the JBoss client.

    .PARAMETER Controller
    The controller parameter corresponds to the hostname and port of the JBoss host.

    .PARAMETER Credentials
    The optional credentials parameter correspond to the credentials of the account to use to connect to JBoss.

    .PARAMETER DataSource
    The data-source parameter corresponds to the name of the data source to remove.

    .INPUTS
    System.String. You can pipe the data-source name to Remove-DataSource.

    .OUTPUTS
    System.String. Remove-DataSource returns the raw output of the JBoss client command.

    .NOTES
    File name:      Remove-DataSource.ps1
    Author:         Florian Carrier
    Creation date:  19/12/2019
    Last modified:  06/01/2020

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
    $Credentials,
    [Parameter (
      Position    = 4,
      Mandatory   = $true,
      HelpMessage = "Name of the data source to be removed",
      ValueFromPipeline               = $true,
      ValueFromPipelineByPropertyName = $true
    )]
    [ValidateNotNUllOrEmpty ()]
    [String]
    $DataSource
  )
  Begin {
    # Get global preference variables
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
  }
  Process {
    Write-Log -Type "DEBUG" -Object "Removing $DataSource data-source"
    # Define JBoss client command
    $Command = "/subsystem=datasources/data-source=""$DataSource"":remove()"
    # Execute command
    if ($PSBoundParameters.ContainsKey("Credentials")) {
      Invoke-JBossClient -Path $Path -Controller $Controller -Command $Command -Credentials $Credentials
    } else {
      Invoke-JBossClient -Path $Path -Controller $Controller -Command $Command
    }
  }
}
