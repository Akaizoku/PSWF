function Remove-Module {
  <#
    .SYNOPSIS
    Remove module

    .DESCRIPTION
    Remove a new module to a JBoss web-application server

    .PARAMETER Path
    The path parameter corresponds to the path to the JBoss client.

    .PARAMETER Controller
    The controller parameter corresponds to the hostname and port of the JBoss host.

    .PARAMETER Credentials
    The optional credentials parameter correspond to the credentials of the account to use to connect to JBoss.

    .PARAMETER Module
    The module parameter corresponds to the name of the JDBC driver module.

    .PARAMETER Resources
    The resources parameter corresponds to the path to the module resource files.

    .PARAMETER Dependencies
    The dependencies parameter corresponds to the module depndencies.

    .INPUTS
    System.String. You can pipe the module name to Remove-Module.

    .OUTPUTS
    System.String. Remove-Module returns the raw output from the JBoss client.

    .NOTES
    File name:      Remove-Module.ps1
    Author:         Florian Carrier
    Creation date:  06/01/2020
    Last modified:  15/01/2020

    .LINK
    Invoke-JBossClient

    .LINK
    Add-Module

    .LINK
    Test-Module
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
      HelpMessage = "Name of the module to remove",
      ValueFromPipeline               = $true,
      ValueFromPipelineByPropertyName = $true
    )]
    [ValidateNotNUllOrEmpty ()]
    [String]
    $Module
  )
  Begin {
    # Get global preference variables
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
  }
  Process {
    # Define JBoss client command
    # WARNING No quotes around the module name
    $Command = "module remove --name=$Module"
    # Execute command
    if ($PSBoundParameters.ContainsKey("Credentials")) {
      Invoke-JBossClient -Path $Path -Controller $Controller -Command $Command -Credentials $Credentials
    } else {
      Invoke-JBossClient -Path $Path -Controller $Controller -Command $Command
    }
  }
}
