function Add-JDBCDriver {
  <#
    .SYNOPSIS
    Add JDBC driver

    .DESCRIPTION
    Add a new JDBC driver

    .PARAMETER Path
    The path parameter corresponds to the path to the JBoss client.

    .PARAMETER Controller
    The controller parameter corresponds to the hostname and port of the JBoss host.

    .PARAMETER Driver
    The driver parameter corresponds to the name of the JDBC driver to add.

    .PARAMETER Module
    The module parameter corresponds to the name of the JDBC driver module.

    .PARAMETER Class
    The class parameter corresponds to the name of the JDBC driver class.

    .PARAMETER Credentials
    The optional credentials parameter correspond to the credentials of the account to use to connect to JBoss.

    .NOTES
    File name:      Add-JDBCDriver.ps1
    Author:         Florian Carrier
    Creation date:  19/12/2019
    Last modified:  19/12/2019
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
      HelpMessage = "Name of the JDBC driver to add"
    )]
    [ValidateNotNUllOrEmpty ()]
    [String]
    $Driver,
    [Parameter (
      Position    = 5,
      Mandatory   = $true,
      HelpMessage = "Name of the JDBC driver module"
    )]
    [ValidateNotNUllOrEmpty ()]
    [String]
    $Module,
    [Parameter (
      Position    = 6,
      Mandatory   = $true,
      HelpMessage = "Name of the JDBC driver class"
    )]
    [ValidateNotNUllOrEmpty ()]
    [String]
    $Class
  )
  Begin {
    # Get global preference variables
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    # TODO check if resource already exists
  }
  Process {
    Write-Log -Type "INFO" -Object "Adding $Driver JDBC driver"
    # Define JBoss client command
    $Command = "/subsystem=datasources/jdbc-driver=""$Driver"":add(driver-module-name=""$Module"",driver-name=""$Driver"",driver-class-name=""$Class"")"
    # Execute command
    if ($PSBoundParameters.ContainsKey("Credentials")) {
      $AddJDBCDriver = Invoke-JBossClient -Path $Path -Controller $Controller -Command $Command -Credentials $Credentials
    } else {
      $AddJDBCDriver = Invoke-JBossClient -Path $Path -Controller $Controller -Command $Command
    }
    # Check outcome
    Assert-JBossCliCmdOutcome -Log $AddJDBCDriver -Object "$Driver JDBC driver" -Verb "add"
  }
}
