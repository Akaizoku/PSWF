function Add-DataSource {
  <#
    .SYNOPSIS
    Add data-source

    .DESCRIPTION
    Add a new data-source to a JBoss web-application server.

    .PARAMETER Path
    The path parameter corresponds to the path to the JBoss client.

    .PARAMETER Controller
    The controller parameter corresponds to the hostname and port of the JBoss host.

    .PARAMETER Credentials
    The optional credentials parameter correspond to the credentials of the account to use to connect to JBoss.

    .PARAMETER DataSource
    The data-source parameter corresponds to the name of the data source to create.

    .PARAMETER Driver
    The driver parameter corresponds to the driver to use.

    .PARAMETER ConnectionURL
    The connection URL parameter corresponds to the database connection URL.

    .PARAMETER UserName
    The user-name parameter corresponds to the name of the user to use for the datase connection.

    .PARAMETER Password
    The password parameter corresponds to the password of the user to use for the datase connection.

    .PARAMETER Disabled
    The disabled switch specifies whether the data-source should be disabled or not.

    .INPUTS
    None. You cannot pipe objects to Add-DataSource.DESCRIPTION

    .OUTPUTS
    System.String. Add-DataSource returns the raw output from the JBoss client command.

    .NOTES
    File name:      Add-DataSource.ps1
    Author:         Florian Carrier
    Creation date:  16/12/2019
    Last modified:  06/01/2020
    WARNING         This currently does not work if the connection URL contains a reference to the database itself (";databaseName=<dbname>")

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
