function Enable-DataSource {
  <#
    .SYNOPSIS
    Enable data-source

    .DESCRIPTION
    Enable a data-source from a JBoss instance

    .PARAMETER Path
    The path parameter corresponds to the path to the JBoss client.

    .PARAMETER Controller
    The controller parameter corresponds to the hostname and port of the JBoss host.

    .PARAMETER Credentials
    The optional credentials parameter correspond to the credentials of the account to use to connect to JBoss.

    .PARAMETER DataSource
    The data-source parameter corresponds to the name of the data source to enable.

    .INPUTS
    System.String. You can pipe the data-source name to Enable-DataSource.

    .OUTPUTS
    System.String. Enable-DataSource returns the raw output of the JBoss client command.

    .NOTES
    File name:      Enable-DataSource.ps1
    Author:         Florian Carrier
    Creation date:  22/01/2020
    Last modified:  22/01/2020

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
      HelpMessage = "Name of the data source to enable",
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
    # Define command
    $Command = "/subsystem=datasources/data-source=\""$DataSource\"":enable()"
    # Run command
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
  }
}
