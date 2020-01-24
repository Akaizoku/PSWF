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
    None. You cannot pipe objects to Add-DataSource.

    .OUTPUTS
    System.String. Add-DataSource returns the raw output from the JBoss client.

    .NOTES
    File name:      Add-DataSource.ps1
    Author:         Florian Carrier
    Creation date:  16/12/2019
    Last modified:  21/01/2020
    TODO            - Add support for check-valid-connection-sql configuration
                    - Add warnings if all validation parameters are not provided

    .LINK
    Add-Resource

    .LINK
    Test-DataSource

    .LINK
    Remove-DataSource
  #>
  [CmdletBinding (
    SupportsShouldProcess   = $true,
    DefaultParameterSetName = "security"
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
      Position          = 7,
      Mandatory         = $true,
      HelpMessage       = "Name of the data-source user account",
      ParameterSetName  = "security"
    )]
    [ValidateNotNUllOrEmpty ()]
    [String]
    $UserName,
    [Parameter (
      Position          = 8,
      Mandatory         = $true,
      HelpMessage       = "Password of the data-source user account",
      ParameterSetName  = "security"
    )]
    [ValidateNotNUllOrEmpty ()]
    [String]
    $Password,
    [Parameter (
      Position          = 7,
      Mandatory         = $true,
      HelpMessage       = "Name of the security domain of the data-source",
      ParameterSetName  = "security-domain"
    )]
    [ValidateNotNUllOrEmpty ()]
    [String]
    $SecurityDomain,
    [Parameter (
      Position          = 9,
      Mandatory         = $false,
      HelpMessage       = "Name of the connection checker Java class to use to validate the connection"
    )]
    [ValidateNotNUllOrEmpty ()]
    [String]
    $ConnectionChecker,
    [Parameter (
      Position          = 10,
      Mandatory         = $false,
      HelpMessage       = "Name of the exception sorter Java class to use"
    )]
    [ValidateNotNUllOrEmpty ()]
    [String]
    $ExceptionSorter,
    [Parameter (
      HelpMessage = "Switch to disable the data-source"
    )]
    [Switch]
    $Disabled,
    [Parameter (
      HelpMessage = "Switch to enable data-source staistics"
    )]
    [Switch]
    $EnableStatistics,
    [Parameter (
      HelpMessage = "Switch to configure the connection validation to run in the background"
    )]
    [Switch]
    $BackgroundValidation
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
    # Define resource
    $Resource = "/subsystem=datasources/data-source=\""$DataSource\"""
    # Define base parameters
    $Parameters = "enabled=\""$Enabled\"", jndi-name=\""$JNDIName\"", driver-name=\""$Driver\"", connection-url=\""$ConnectionURL\"""
    # Add security parameters
    switch ($PsCmdlet.ParameterSetName) {
      "security" {
        $Parameters = $Parameters + ", user-name=\""$UserName\"", password=\""$Password\"""
      }
      "security-domain" {
        $Parameters = $Parameters + ", security-domain=\""$SecurityDomain\"""
      }
    }
    # Add validation parameters
    if ($PSBoundParameters.ContainsKey("ConnectionChecker") -And ($PSBoundParameters.ContainsKey("ExceptionSorter"))) {
      $Parameters = $Parameters + ", valid-connection-checker-class-name=\""$ConnectionChecker\"", exception-sorter-class-name=\""$ExceptionSorter\"""
      if ($BackgroundValidation) {
        $Parameters = $Parameters + ", validate-on-match=$false, background-validation=$true"
      } else {
        $Parameters = $Parameters + ", validate-on-match=$true, background-validation=$false"
      }
    }
    # Data-source statistics
    if ($PSBoundParameters.ContainsKey("EnableStatistics")) {
      $Parameters = $Parameters + ", statistics-enabled=$true"
    }
    # Add data-source
    if ($PSBoundParameters.ContainsKey("Credentials")) {
      Add-Resource -Path $Path -Controller $Controller -Resource $Resource -Parameters $Parameters -Credentials $Credentials
    } else {
      Add-Resource -Path $Path -Controller $Controller -Resource $Resource -Parameters $Parameters
    }
  }
}
