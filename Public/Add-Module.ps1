function Add-Module {
  <#
    .SYNOPSIS
    Add module

    .DESCRIPTION
    Add a new module to a JBoss web-application server

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
    None. You cannot pipe objects to Add-Module.

    .OUTPUTS
    System.String. Add-Module returns the raw output from the JBoss client.

    .EXAMPLE

    Add-JDBCDriver -Path "C:\WKFS\WildFly\bin\jboss-cli.ps1" -Controller "127.0.0.1:9990" -Driver "mssql" -Module "mssql.jdbc" -Class "com.microsoft.sqlserver.jdbc.SQLServerDriver"

    In this example, Add-JDBCDriver will add a new driver with the name mssql using the module mssql.jdbc and the class com.microsoft.sqlserver.jdbc.SQLServerDriver to the JBoss server specified by the local controller.

    .NOTES
    File name:      Add-Module.ps1
    Author:         Florian Carrier
    Creation date:  19/12/2019
    Last modified:  07/01/2020
    WARNING         Do not use quotes around dependencies. The values should not contain spaces and the comma prevents the use of double-quotes.

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
      HelpMessage = "Name of the module to add"
    )]
    [ValidateNotNUllOrEmpty ()]
    [String]
    $Module,
    [Parameter (
      Position    = 5,
      Mandatory   = $true,
      HelpMessage = "Path to the module resource files"
    )]
    [ValidateNotNUllOrEmpty ()]
    [String]
    $Resources,
    [Parameter (
      Position    = 6,
      Mandatory   = $true,
      HelpMessage = "Dependencies"
    )]
    [ValidateNotNUllOrEmpty ()]
    [String]
    $Dependencies
  )
  Begin {
    # Get global preference variables
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
  }
  Process {
    Write-Log -Type "DEBUG" -Object "Adding $Module module"
    # Define JBoss client command
    $Command = "module add --name=""$Module"" --resources=""$Resources"" --dependencies=$Dependencies"
    # Execute command
    if ($PSBoundParameters.ContainsKey("Credentials")) {
      Invoke-JBossClient -Path $Path -Controller $Controller -Command $Command -Credentials $Credentials
    } else {
      Invoke-JBossClient -Path $Path -Controller $Controller -Command $Command
    }
  }
}
