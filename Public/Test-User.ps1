function Test-User {
  <#
    .SYNOPSIS
    Test user

    .DESCRIPTION
    Check if a user exists in a specified realm of a JBoss instance

    .PARAMETER JBossHome
    The optional JBoss home parameter corresponds to the path to the JBoss home directory.

    .PARAMETER UserName
    The user-name parameter corresponds to the name of the user to check.

    .PARAMETER Realm
    The realm parameter corresponds to the name of the realm in which the user exists.

    .PARAMETER Domain
    The domain switch specifies if the JBoss instance is configured in domain mode.

    .INPUTS
    System.String. You can pipe the user name to Test-User.

    .OUTPUTS
    Boolean. Test-User returns the a boolean depending if the user exists.

    .NOTES
    File name:      Test-User.ps1
    Author:         Florian Carrier
    Creation date:  09/01/2020
    Last modified:  09/01/2020

    .LINK
    Add-User

    .LINK
    Test-User
  #>
  [CmdletBinding (
    SupportsShouldProcess = $true
  )]
  Param (
    [Parameter (
      Position    = 1,
      Mandatory   = $true,
      HelpMessage = "Path to the JBoss home directory"
    )]
    [ValidateNotNUllOrEmpty ()]
    [String]
    $JBossHome,
    [Parameter (
      Position    = 2,
      Mandatory   = $true,
      HelpMessage = "Name of the user to check",
      ValueFromPipeline               = $true,
      ValueFromPipelineByPropertyName = $true
    )]
    [ValidateNotNUllOrEmpty ()]
    [String]
    $UserName,
    [Parameter (
      Position    = 3,
      Mandatory   = $true,
      HelpMessage = "Realm of the user"
    )]
    [ValidateSet (
      "ApplicationRealm",
      "ManagementRealm"
    )]
    [String]
    $Realm,
    [Parameter (
      HelpMessage = "Switch to configure an instance configured in domain mode"
    )]
    [Switch]
    $Domain
  )
  Begin {
    # Get global preference variables
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    # User configuration file
    switch ($Realm) {
      "ApplicationRealm" { $ConfigurationFileName = "application-users.properties" }
      "ManagementRealm"  { $ConfigurationFileName = "mgmt-users.properties"        }
    }
    # Define configuration file path
    if ($Domain) {
      # Domain instance configuration
      $ConfigurationFile = Join-Path -Path $JBossHome -ChildPath "domain\configuration\$ConfigurationFileName"
    } else {
      # Standalone instance configuration
      $ConfigurationFile = Join-Path -Path $JBossHome -ChildPath "standalone\configuration\$ConfigurationFileName"
    }
  }
  Process {
    # Check that user configuration file exists
    if (Test-Path -Path $ConfigurationFile) {
      # Load user configuration
      $Configuration = Get-Content -Path $ConfigurationFile -Raw
      # Check if user exists
      if (Select-String -InputObject $Configuration -Pattern "$Username=" -Quiet) {
        # If user is found
        return $true
      } else {
        # If user is not found
        return $false
      }
    } else {
      # If user configuration file is not found
      Write-Log -Type "DEBUG" -Object "Path not found $ConfigurationFile"
      return $false
    }
  }
}
