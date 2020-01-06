function Remove-JDBCDriver {
  <#
    .SYNOPSIS
    Remove JDBC driver

    .DESCRIPTION
    Remove a JDBC driver

    .PARAMETER Path
    The path parameter corresponds to the path to the JBoss client.

    .PARAMETER Controller
    The controller parameter corresponds to the hostname and port of the JBoss host.

    .PARAMETER Credentials
    The optional credentials parameter correspond to the credentials of the account to use to connect to JBoss.

    .PARAMETER Driver
    The driver parameter corresponds to the name of the JDBC driver to add.

    .PARAMETER Module
    The module parameter corresponds to the name of the JDBC driver module.

    .PARAMETER Class
    The class parameter corresponds to the name of the JDBC driver class.

    .NOTES
    File name:      Remove-JDBCDriver.ps1
    Author:         Florian Carrier
    Creation date:  20/12/2019
    Last modified:  20/12/2019
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
    $Driver
  )
  Begin {
    # Get global preference variables
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    # Resource
    $Resource = "/subsystem=datasources/jdbc-driver=""$Driver"""
  }
  Process {
    Write-Log -Type "INFO" -Object "Removing $Driver JDBC driver"
    # TODO check if resource exists
    if ($PSBoundParameters.ContainsKey("Credentials")) {
      $ReadJDBCDriver = Read-Resource -Path $Path -Controller $Controller -Resource $Resource -Credentials $Credentials
    } else {
      $ReadJDBCDriver = Read-Resource -Path $Path -Controller $Controller -Resource $Resource
    }
    if ($ReadJDBCDriver) {
      # Define JBoss client command
      $RemoveCommand = "$($Resource):remove()"
      # Execute command
      if ($PSBoundParameters.ContainsKey("Credentials")) {
        $RemoveJDBCDriver = Invoke-JBossClient -Path $Path -Controller $Controller -Command $RemoveCommand -Credentials $Credentials
      } else {
        $RemoveJDBCDriver = Invoke-JBossClient -Path $Path -Controller $Controller -Command $RemoveCommand
      }
      # Check outcome
      Assert-JBossCliCmdOutcome -Log $RemoveJDBCDriver -Object "$Driver JDBC driver" -Verb "remove"
    } else {
      Write-Log -Type "WARN" -Object "$Driver JDBC driver is not configured"
    }
  }
}
