function Add-DataSource {
  <#
    .SYNOPSIS
    Add data-source

    .DESCRIPTION
    Add a new data-source

    .PARAMETER Path
    The path parameter corresponds to the path to the JBoss client.

    .PARAMETER Controller
    The controller parameter corresponds to the hostname and port of the JBoss host.

    .PARAMETER Name
    The name parameter corresponds to the name of the data source to create.

    .PARAMETER Credentials
    The optional credentials parameter correspond to the credentials of the account to use to connect to JBoss.

    .NOTES
    File name:      Add-DataSource.ps1
    Author:         Florian Carrier
    Creation date:  16/12/2019
    Last modified:  06/01/2020
    WARNING         This currently does not work if the connection URL contains a reference to the database itself (";databaseName=<dbname>")
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
      HelpMessage = "Name of the data source to be created"
    )]
    [ValidateNotNUllOrEmpty ()]
    [String]
    $DataSource,
    [Parameter (
      Position    = 5,
      Mandatory   = $true,
      HelpMessage = "Name of the database driver"
    )]
    [ValidateNotNUllOrEmpty ()]
    [String]
    $Driver,
    [Parameter (
      Position    = 6,
      Mandatory   = $true,
      HelpMessage = "Database connection URL"
    )]
    [ValidateNotNUllOrEmpty ()]
    [String]
    $ConnectionURL,
    [Parameter (
      Position    = 7,
      Mandatory   = $true,
      HelpMessage = "Name of the data-source user account"
    )]
    [ValidateNotNUllOrEmpty ()]
    [String]
    $UserName,
    [Parameter (
      Position    = 8,
      Mandatory   = $true,
      HelpMessage = "Password of the data-source user account"
    )]
    [ValidateNotNUllOrEmpty ()]
    [String]
    $Password,
    [Parameter (
      HelpMessage = "Switch to disable the data-source"
    )]
    [Switch]
    $Disabled
  )
  Begin {
    # Get global preference variables
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    # Enable flag
    $Enabled = -Not $Disabled
    # JDNI name
    $JNDIName = "java:/jdbc/$DataSource"
  }
  Process {
    Write-Log -Type "DEBUG" -Object "Creating $DataSource data-source"
    # TODO check if data-source already exists
    # Define JBoss client command
    $Command = "/subsystem=datasources/data-source=""$DataSource"":add(enabled=""$Enabled"", jndi-name=""$JNDIName"", driver-name=""$Driver"", connection-url=""$ConnectionURL"", user-name=""$UserName"", password=""$Password"")"
    # Execute command
    if ($PSBoundParameters.ContainsKey("Credentials")) {
      Invoke-JBossClient -Path $Path -Controller $Controller -Command $Command -Credentials $Credentials -Redirect
    } else {
      Invoke-JBossClient -Path $Path -Controller $Controller -Command $Command -Redirect
    }
  }
}