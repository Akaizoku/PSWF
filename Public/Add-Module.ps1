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

    Add-Module -Path "C:\WildFly\bin\jboss-cli.ps1" -Controller "127.0.0.1:9990" -Module "mssql.jdbc" -Resource "C:\Modules\sqljdbc42.jar"

    In this example, Add-Module will create a new module named mssql.jdbc containing the files located in "C:\Modules\sqljdbc42.jar".

    .NOTES
    File name:      Add-Module.ps1
    Author:         Florian Carrier
    Creation date:  19/12/2019
    Last modified:  15/01/2020
    Remark:         If the add module operation is successful, no output will be produced. Use Test-Module to validate the outcome.

    .LINK
    Invoke-JBossClient

    .LINK
    Test-Module

    .LINK
    Remove-Module
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
      Mandatory   = $false,
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
    # Define JBoss client command
    # WARNING No quotes around the module name as it is used as-is for the directory structure creation
    $Command = "module add --name=$Module --resources=\""$Resources\"""
    # Add dependencies if required
    if ($PSBoundParameters.ContainsKey("Dependencies")) {
      # WARNING No quotes around the dependencies else "&quot;" will be added in the module dependency XML node
      $Command = $Command + " --dependencies=$Dependencies"
    }
    # Execute command
    if ($PSBoundParameters.ContainsKey("Credentials")) {
      Invoke-JBossClient -Path $Path -Controller $Controller -Command $Command -Credentials $Credentials
    } else {
      Invoke-JBossClient -Path $Path -Controller $Controller -Command $Command
    }
  }
}
