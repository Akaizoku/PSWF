function Remove-User {
  <#
    .SYNOPSIS
    Remove user

    .DESCRIPTION
    Remove a user from a specified realm of a JBoss instance

    .PARAMETER JBossHome
    The optional JBoss home parameter corresponds to the path to the JBoss home directory.

    .PARAMETER UserName
    The user-name parameter corresponds to the name of the user to remove.

    .PARAMETER Realm
    The realm parameter corresponds to the name of the realm in which the user exists.

    .PARAMETER Domain
    The domain switch specifies if the JBoss instance is configured in domain mode.

    .INPUTS
    System.String. You can pipe the user name to Remove-User.

    .OUTPUTS
    Boolean. Remove-User returns the a boolean depending if the user-group has been removed or not.

    .NOTES
    File name:      Remove-User.ps1
    Author:         Florian Carrier
    Creation date:  07/01/2020
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
      HelpMessage = "Name of the user to remove",
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
      "Application" { $ConfigurationFileName = "application-users.properties" }
      "Management"  { $ConfigurationFileName = "mgmt-users.properties"        }
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
    Write-Log -Type "DEBUG" -Object "Removing $Username user from $Realm realm"
    # Check that user configuration file exists
    if (Test-Path -Path $ConfigurationFile) {
      # Load user configuration
      $Configuration = Get-Content -Path $ConfigurationFile -Raw
      # Check if user exists
      if (Select-String -InputObject $Configuration -Pattern "$Username=" -Quiet) {
        # Remove user
        $NewConfiguration = $Configuration -replace "$UserName=.+\n", ""
        # Save updated user configuration
        $NewConfiguration.Trim() | Out-File -FilePath $ConfigurationFile -Force
        return $true
      } else {
        # If user is not found
        return $false
      }
    } else {
      # If user configuration file is not found return false
      Write-Log -Type "DEBUG" -Object "Path not found $ConfigurationFile"
      return $false
    }
  }
}
