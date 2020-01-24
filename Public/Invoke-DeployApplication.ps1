function Invoke-DeployApplication {
  <#
    .SYNOPSIS
    Deploy an application

    .DESCRIPTION
    Deploy an application resource file (WAR, EAR, JAR, SAR, etc.)

    .PARAMETER Path
    The path parameter corresponds to the path to the JBoss client.

    .PARAMETER Controller
    The controller parameter corresponds to the hostname and port of the JBoss host.

    .PARAMETER Credentials
    The optional credentials parameter correspond to the credentials of the account to use to connect to JBoss.

    .PARAMETER Application
    The application parameter corresponds to the path to the application to deploy.

    .PARAMETER Unmanaged
    The unmanaged switch defines if the application should be deployed in unmanaged mode..

    .PARAMETER Force
    The force switch defines if the application should overwrite an existing file.

    .NOTES
    File name:      Invoke-DeployApplication.ps1
    Author:         Florian Carrier
    Creation date:  19/12/2019
    Last modified:  15/01/2020
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
      HelpMessage = "Path to the application"
    )]
    [ValidateNotNUllOrEmpty ()]
    [String]
    $Application,
    [Parameter (
      HelpMessage = "Unmanaged mode switch"
    )]
    [Switch]
    $Unmanaged,
    [Parameter (
      HelpMessage = "Force switch"
    )]
    [Switch]
    $Force
  )
  Begin {
    # Get global preference variables
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    # Web-application
    $WebApp = Split-Path -Path $Application -Leaf
  }
  Process {
    # Define command
    $Command = "deploy \""$Application\"""
    # Add unmanaged switch if required
    if ($Unmanaged) {
      $Command = $Command + " --unmanaged"
    }
    # Add force switch if required
    if ($Force) {
      $Command = $Command + " --force"
    }
    # Execute command
    if ($PSBoundParameters.ContainsKey('Credentials')) {
      Invoke-JBossClient -Path $Path -Controller $Controller -Command $Command -Credentials $Credentials
    } else {
      Invoke-JBossClient -Path $Path -Controller $Controller -Command $Command
    }
  }
}
